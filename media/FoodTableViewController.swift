//
//  FoodTableViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import Firebase
import CellAnimator
import SwiftyJSON

class FoodTableViewController: UITableViewController {
    var ref: FIRDatabaseReference!
    var movies:[Movie] = []
    let searchController = UISearchController(searchResultsController: nil)
    var titleView:String = ""
    var catId:NSNumber = 0
    var tableViewControler = UITableViewController(style: .plain)
    let baseURL = "https://api.themoviedb.org/3/genre/"
    let suiteURL = "/movies?api_key=72e58ed9123ba68d1f814768448360c0&language="+Locale.current.languageCode!+"&include_adult=false&sort_by=created_at.asc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleView
        SwiftSpinner.show("Loading, please wait...")
        self.ref = FIRDatabase.database().reference()
        ref.child("mediasByFood/\(self.catId.stringValue)").queryOrdered(byChild: "votes_count").queryLimited(toLast: 5).observe(.childAdded, with: { (snapshot) -> Void in
            self.loadDatas(imdbId: snapshot.key)
        })
    }
    
    func loadDatas(imdbId: String) {
        Alamofire.request("https://api.themoviedb.org/3/movie/"+imdbId+"?api_key=72e58ed9123ba68d1f814768448360c0&language="+Locale.current.languageCode!).responseJSON { response in
            let movie = Movie()
            let json = JSON(response.result.value!)
            
            if let runtime = json["runtime"].number {
                movie.runtime = runtime.stringValue
            }
            
            if let imdbId = json["id"].number {
                movie.imdbId = imdbId.stringValue
            }
            
            if let poster = json["poster_path"].string {
                movie.posterURL = poster
            }
            
            if let plot = json["overview"].string {
                movie.plot = plot
            }
            
            if let released = json["release_date"].number {
                movie.released = released.stringValue
            }
            
            if let rating = json["vote_average"].number {
                movie.rating = rating.stringValue
            }
            
            if let title = json["title"].string {
                movie.title = title
            }
            
            if let genre = json["genres"].array {
                if genre.count != 0 {
                    for i in 0...genre.count-1 {
                        let genreItem = genre[i]["name"]
                        movie.genre.append(genreItem.stringValue)
                    }
                }
            }

            self.movies.append(movie)
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func parseJSON(inputData:Data) -> Dictionary<String,String> {
        let dictData = (try! JSONSerialization.jsonObject(with: inputData, options: .mutableContainers)) as! Dictionary<String,String>
        return dictData
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        
        return .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FoodTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as! FoodTableViewCell
        if !self.movies.isEmpty {
            cell.display(data:movies[indexPath.row])
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformWave, andDuration: 0.5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? UITableViewCell
        if cell != nil {
            let indexPath = tableView.indexPath(for: cell!)
            let svc = segue.destination as! DetailViewController;
            svc.imdbId = self.movies[(indexPath?.row)!].imdbId            
        }
    }
}


