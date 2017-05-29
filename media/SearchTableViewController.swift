//
//  SearchTableViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 14/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Alamofire

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
            searchController.searchBar.tintColor = UIColor.black
            searchController.searchBar.barTintColor = UIColor.lightText
            searchController.dimsBackgroundDuringPresentation = false
            tableView.tableHeaderView = searchController.searchBar
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
            svc.imdbId = self.movies[(indexPath?.row)!].imdbId
        }
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.movies.removeAll()
        if let searchBarText = self.searchController.searchBar.text {
            if(searchBarText != ""){
                let film:String = (searchBarText.replacingOccurrences(of: " ", with: "+"))
                
                Alamofire.request(baseURL+"search/movie?api_key=72e58ed9123ba68d1f814768448360c0&query="+film+"&language="+Locale.current.languageCode!).responseJSON { response in
                    if let JSON = response.result.value as? [String: Any] {
                        let results = JSON["results"] as! [Dictionary<String,Any>]
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
                    }
                }
            } else {
                self.tableView.reloadData()   
            }
        }
    }
}
