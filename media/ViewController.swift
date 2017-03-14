//
//  ViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    var ref: FIRDatabaseReference!
    var movies:[Movie] = []
    let searchController = UISearchController(searchResultsController: nil)

    var tableViewControler = UITableViewController(style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        var count:Int = 0
        ref.child("medias").observe(.childAdded, with: { (snapshot) -> Void in
            let filmItem:Dictionary<String,String> = snapshot.value as! Dictionary<String,String>
            self.loadImage(img: filmItem["poster"]!, index: count)
            let movie = Movie()
            if let title = filmItem["title"]{
                movie.title = title
            }
            if let year = filmItem["year"]{
                movie.year = year
            }
            if let rating = filmItem["rating"]{
                movie.rating = rating
            }
            if let plot = filmItem["plot"]{
                movie.plot = plot
            }
            if let runtime = filmItem["runtime"]{
                movie.runtime = runtime
            }
            if let released = filmItem["released"]{
                movie.released = released
            }
            if let genre = filmItem["genre"]{
                movie.genre = genre
            }
            if let country = filmItem["country"]{
                movie.country = country
            }
            if let imdbId = filmItem["imdbId"]{
                movie.imdbId = imdbId
            }
            if let id = filmItem["id"]{
                movie.id = id
            }
            self.movies.append(movie)
            self.tableView.reloadData()
            count=count+1
        })
            
        ref.child("medias").observe(.childRemoved, with: { (snapshot) -> Void in
            let filmItem:Dictionary<String,String> = snapshot.value as! Dictionary<String,String>
            let index = self.movies.index(where: { (movie) -> Bool in
                movie.imdbId == filmItem["imdbId"]!
            })
            self.movies.remove(at: index!)
            self.tableView.reloadData()
        })
    }
    
    func loadImage(img:String,index:Int){
        DispatchQueue.main.async(execute: {
            let url = URL(string: img)
            let image = try! Data(contentsOf:  url!)
            self.movies[index].poster = image
            self.tableView.reloadData()
        })
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


