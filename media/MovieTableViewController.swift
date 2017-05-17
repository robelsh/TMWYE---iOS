//
//  MovieTableViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import CellAnimator
import SwiftyJSON

class MovieTableViewController: UITableViewController {
    var movies:[Movie] = []
    let searchController = UISearchController(searchResultsController: nil)
    var titleView:String = ""
    var genreId:NSNumber = 0
    var tableViewControler = UITableViewController(style: .plain)
    let baseURL = "https://api.themoviedb.org/3/genre/"
    let suiteURL = "/movies?api_key=72e58ed9123ba68d1f814768448360c0&language="+Locale.current.languageCode!+"&include_adult=false&sort_by=created_at.asc"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleView
        SwiftSpinner.show("Loading, please wait...")
        Alamofire.request(self.baseURL + self.genreId.stringValue + self.suiteURL).responseJSON { response in
            let json = JSON(response.result.value!)
            
            if var results = json["results"].array {
                for i in 0...results.count-1 {
                    let movie = Movie()
                    if let imdbId = results[i]["id"].number {
                        movie.imdbId = imdbId.stringValue
                    }
                    
                    if let poster = results[i]["poster_path"].string {
                        movie.posterURL = poster
                    }
                    
                    if let released = results[i]["release_date"].string {
                        movie.year = movie.extractYearFromRelease(released: released)
                    }
                    
                    if let title = results[i]["title"].string {
                        movie.title = title
                    }
                    
                    self.movies.append(movie)
                }
            }
    
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func getJSON(urlToRequest:String) -> Data {
        let data = try? Data(contentsOf: URL(string: urlToRequest)!)
        return data!
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
        let cell:MovieTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieTableViewCell
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


