//
//  SearchTableViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 14/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var search:Bool = false
    let baseURL = "https://api.themoviedb.org/3/"
    var movies:[Movie] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var tableViewControler = UITableViewController(style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
            searchController.searchResultsUpdater = self
            searchController.searchBar.delegate = self
            definesPresentationContext = true
            searchController.searchBar.placeholder = "Looking for a movie ?"
            searchController.searchBar.barTintColor = UIColor.darkGray
            searchController.dimsBackgroundDuringPresentation = false
            tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getJSON(urlToRequest:String) -> Data {
        let data = try? Data(contentsOf: URL(string: urlToRequest)!)
        return data!
    }
    
    func parseJSON(inputData:Data) -> Dictionary<String,String> {
        let dictData = (try! JSONSerialization.jsonObject(with: inputData, options: .mutableContainers)) as! Dictionary<String,String>
        return dictData
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
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SearchListTableViewCell {
        let cell:SearchListTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchListTableViewCell
        if !self.movies.isEmpty {
            cell.display(title: self.movies[indexPath.row].title, year: self.movies[indexPath.row].year)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? UITableViewCell
        if cell != nil {
            let indexPath = tableView.indexPath(for: cell!)
            let svc = segue.destination as! DetailViewController;
            let film:String = self.movies[(indexPath?.row)!].imdbId
            let dictData = (try! JSONSerialization.jsonObject(with: getJSON(urlToRequest: baseURL+"movie/"+film+"?api_key=72e58ed9123ba68d1f814768448360c0"), options: .mutableContainers)) as? [String: Any]
            let movie:Movie = Movie()
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

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.movies.removeAll()
        if let searchBarText = self.searchController.searchBar.text {
            if(searchBarText != ""){
                let film:String = (searchBarText.replacingOccurrences(of: " ", with: "+"))
                let dictData = (try! JSONSerialization.jsonObject(with: getJSON(urlToRequest: baseURL+"search/movie?api_key=72e58ed9123ba68d1f814768448360c0&query="+film), options: .mutableContainers)) as? [String: Any]
                let results = dictData?["results"] as! [Dictionary<String,Any>]

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
        }
        
    }
}
