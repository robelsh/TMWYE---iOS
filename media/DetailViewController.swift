//
//  DetailViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class DetailViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var plot: UITextView!
    @IBOutlet weak var genre: UILabel!
    
    var movie:Movie = Movie()
    var imdbId:String = ""
    var key = ""
    var categories:[String] = []
    var categoriesId:[NSNumber] = []
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading, please wait...")
        self.loadDatas()
    }
    
    func loadDatas(){
        Alamofire.request("https://api.themoviedb.org/3/movie/"+self.imdbId+"?api_key=72e58ed9123ba68d1f814768448360c0&language="+Locale.current.languageCode!).responseJSON { response in
            let json = JSON(response.result.value!)
            
            if let countries = json["production_countries"].array {
                if countries.count != 0 {
                    for i in 0...countries.count-1 {
                        let country = countries[i]["name"].string
                        self.movie.countries.append(country!)
                    }
                }
            }
            
            if let title = json["title"].string {
                self.movie.title = title
            }
            
            if let runtime = json["runtime"].number {
                self.movie.runtime = runtime.stringValue
            }
            
            if let imdbId = json["id"].number {
                self.movie.imdbId = imdbId.stringValue
            }
            
            if let plot = json["overview"].string {
                self.movie.plot = plot
            }
            
            if let released = json["release_date"].string {
                self.movie.released = released
            }
            
            if let rating = json["vote_average"].number {
                self.movie.rating = rating.stringValue
            }
            
            if let genre = json["genres"].array {
                if genre.count != 0 {
                    for i in 0...genre.count-1 {
                        let genreItem = genre[i]["name"]
                        self.movie.genre.append(genreItem.stringValue)
                    }
                }
            }
            
            if let posterBck = json["backdrop_path"].string {
                Alamofire.request("https://image.tmdb.org/t/p/w500"+posterBck).responseData(){ response in
                    self.backgroundImage.image = UIImage(data: response.result.value!)
                }
            }

            self.plot.text = self.movie.plot
            self.rating.text = self.movie.rating + " 🌟"
            self.released.text = self.movie.released
            self.year.text = self.movie.year
            self.runtime.text = self.movie.runtime + " 🕐"
            self.titleTextLabel.text = self.movie.title
            self.country.text = self.movie.countries[0]
            SwiftSpinner.hide()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "embeddedSegue") {
            let childViewController = segue.destination as! VotesCollectionViewController
            childViewController.imdbId = self.imdbId
        }
    }
}
