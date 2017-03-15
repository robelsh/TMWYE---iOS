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
        //var count:Int = 0
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
                self.movies.append(movie)
            }
        }
        self.tableView.reloadData()
        SwiftSpinner.hide()

        
        /*ref.child("medias").observe(.value, with: { snapshot in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let childItem = child.value as! [String:String]
                let movie = Movie()
                self.loadImage(img: childItem["poster"]!, index: count)
                if let title = childItem["title"]{
                    movie.title = title
                }
                if let year = childItem["year"]{
                    movie.year = year
                }
                if let rating = childItem["rating"]{
                    movie.rating = rating
                }
                if let plot = childItem["plot"]{
                    movie.plot = plot
                }
                if let runtime = childItem["runtime"]{
                    movie.runtime = runtime
                }
                if let released = childItem["released"]{
                    movie.released = released
                }
                if let genre = childItem["genre"]{
                    movie.genre = genre
                }
                if let country = childItem["country"]{
                    movie.country = country
                }
                if let imdbId = childItem["imdbId"]{
                    movie.imdbId = imdbId
                }
                if let id = childItem["id"]{
                    movie.id = id
                }
                self.movies.append(movie)
                count=count+1
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        })
        
        ref.child("medias").observe(.childRemoved, with: { (snapshot) -> Void in
            let filmItem:Dictionary<String,String> = snapshot.value as! Dictionary<String,String>
            let index = self.movies.index(where: { (movie) -> Bool in
                movie.imdbId == filmItem["imdbId"]!
            })
            self.movies.remove(at: index!)
            self.tableView.reloadData()
        })*/
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            ref.child("medias/" + movies[indexPath.row].id).removeValue()
            self.tableView.reloadData()
        }
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
            svc.movie = self.movies[(indexPath?.row)!]
        }
    }
}


