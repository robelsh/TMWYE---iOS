//
//  ViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

class ViewController: UITableViewController {
    var ref: FIRDatabaseReference!
    var movies:[Movie] = []
    let searchController = UISearchController(searchResultsController: nil)
    var titleView:String = ""
    var genreId:NSNumber = 0
    var tableViewControler = UITableViewController(style: .plain)
    let baseURL = "https://api.themoviedb.org/3/genre/"
    let suiteURL = "/movies?api_key=72e58ed9123ba68d1f814768448360c0&language=en-US&include_adult=false&sort_by=created_at.asc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleView
        SwiftSpinner.show("Loading, please wait...")
        self.ref = FIRDatabase.database().reference()
        let dictData = (try! JSONSerialization.jsonObject(with: getJSON(urlToRequest: self.baseURL + self.genreId.stringValue + self.suiteURL), options: .mutableContainers)) as? [String: Any]
        let results = dictData?["results"] as! [Dictionary<String,Any>]
        if !results.isEmpty {
            for i in 0...results.count-1 {
                let movie = Movie()
                movie.title = results[i]["title"] as! String
                let id = results[i]["id"] as! NSNumber
                movie.imdbId = id.stringValue
                if let year = results[i]["release_date"] as! String? {
                    if(year != ""){
                        let startIndex = year.index(year.startIndex, offsetBy: 4)
                        movie.year = year.substring(to: startIndex)
                    }
                }
                if let poster = results[i]["poster_path"] as! String? {
                    movie.poster = try! Data(contentsOf:  URL(string: "https://image.tmdb.org/t/p/w500"+poster)!)
                }
                self.movies.append(movie)
            }
        }
        
        self.tableView.reloadData()
        SwiftSpinner.hide()
    }
    
    func loadImage(img:String,index:Int){
        DispatchQueue.main.async(execute: {
            let url = URL(string: img)
            let image = try! Data(contentsOf:  url!)
            self.movies[index].poster = image
            self.tableView.reloadData()
        })
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
        let cell:TableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        if !self.movies.isEmpty {
            cell.display(data:movies[indexPath.row])
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? UITableViewCell
        if cell != nil {
            let indexPath = tableView.indexPath(for: cell!)
            let svc = segue.destination as! DetailViewController;
            let imdbID:String = self.movies[(indexPath?.row)!].imdbId
            let dictData = (try! JSONSerialization.jsonObject(with: getJSON(urlToRequest: "https://api.themoviedb.org/3/movie/"+imdbID+"?api_key=72e58ed9123ba68d1f814768448360c0"), options: .mutableContainers)) as? [String: Any]
            let movie:Movie = Movie()
            movie.imdbId = imdbID
            if let datas = dictData {
                movie.title = datas["title"] as! String
                if let runtime = datas["runtime"] as! NSNumber? {
                    movie.runtime = runtime.stringValue
                }
                if let poster = datas["poster_path"] as! String? {
                    movie.poster = try! Data(contentsOf:  URL(string: "https://image.tmdb.org/t/p/w500"+poster)!)
                }
                movie.plot = datas["overview"] as! String
                movie.released = datas["release_date"] as! String
                if let rating = datas["vote_average"] as! NSNumber? {
                    movie.rating = rating.stringValue
                }
                
                if let genre = datas["genres"] as? [[String:Any]] {
                    for i in 0...genre.count-1 {
                        let genreItem = genre[i]["name"] as! String
                        movie.genre = movie.genre + " " + genreItem
                    }
                }
                
                svc.movie = movie
    
            }
        }

    }
}


