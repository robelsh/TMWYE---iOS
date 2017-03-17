//
//  DetailViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftSpinner

class DetailViewController: UIViewController {
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var plot: UITextView!
    @IBOutlet weak var genre: UILabel!

    var movie:Movie = Movie()
    var ref: FIRDatabaseReference!
    var imdbId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading, please wait...")
        self.loadDatas()
    }
    
    func loadDatas(){
        Alamofire.request("https://api.themoviedb.org/3/movie/"+self.imdbId+"?api_key=72e58ed9123ba68d1f814768448360c0&language="+Locale.current.languageCode!).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                self.movie.title = JSON["title"] as! String
                if let runtime = JSON["runtime"] as! NSNumber? {
                    self.movie.runtime = runtime.stringValue
                }
                if JSON["poster_path"] == nil {
                    if let poster = JSON["poster_path"] as! String? {
                        self.movie.poster = try! Data(contentsOf:  URL(string: "https://image.tmdb.org/t/p/w500"+poster)!)
                    }
                }
                
                self.movie.plot = JSON["overview"] as! String
                self.movie.released = JSON["release_date"] as! String
                if let rating = JSON["vote_average"] as! NSNumber? {
                    self.movie.rating = rating.stringValue
                }
                
                if let genre = JSON["genres"] as? [[String:Any]] {
                    if genre.count != 0 {
                        for i in 0...genre.count-1 {
                            let genreItem = genre[i]["name"] as! String
                            self.movie.genre = self.movie.genre + " " + genreItem
                        }
                    }
                }
                self.title = self.movie.title
                self.country.text = self.movie.country
                self.genre.text = self.movie.genre
                self.plot.text = self.movie.plot
                self.rating.text = self.movie.rating
                self.released.text = self.movie.released
                self.year.text = self.movie.year
                self.runtime.text = self.movie.runtime
                self.titleTextLabel.text = self.movie.title
                self.image.image = UIImage(data: self.movie.poster)
            }
            SwiftSpinner.hide()
        }
    }
    
    @IBAction func addFilm(_ sender: Any) {
        self.ref = FIRDatabase.database().reference()
        let uid:String = (FIRAuth.auth()?.currentUser?.uid)! as String
        let update = ["medias/\(self.movie.imdbId)":
            ["imdbId":self.movie.imdbId,
             "votes": ["uid": uid]
            ]
        ]
        ref.updateChildValues(update)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
