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
    var test:[String] = ["a","b","c","d"]
    
    let DATAS_USER_DEFAULT_KEY:String = "DATA"
    let IMG_USER_DEFAULT_KEY:String = "IMAGE"
    let baseURL = "https://www.omdbapi.com"
    var ref: FIRDatabaseReference!
    var movies:[Movie] = []
    
    var tableViewControler = UITableViewController(style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()

        ref.child("medias").observe(.childAdded, with: { (snapshot) -> Void in
            let filmItem:Dictionary<String,String> = snapshot.value as! Dictionary<String,String>
            let movie = Movie(title: filmItem["title"]!, year: filmItem["year"]!, poster: filmItem["poster"]!, rating: filmItem["rating"]!, plot: filmItem["plot"]!, runtime: filmItem["runtime"]!, released: filmItem["released"]!, genre: filmItem["genre"]!, country: filmItem["country"]!, imdbId: filmItem["imdbId"]!)
            self.movies.append(movie)
            self.tableView.reloadData()
        })
        /*
        ref.child("medias").observe(.childRemoved, with: { (snapshot) -> Void in
            let filmItem:Dictionary<String,String> = snapshot.value as! Dictionary<String,String>
            self.film.remove(at: self.film.index(of: filmItem["name"]!)!)
            self.updateDatas()
        })
    
        ref.child("medias").observe(.childChanged, with: { (snapshot) -> Void in
            let filmItem:Dictionary<String,String> = snapshot.value as! Dictionary<String,String>
            let index = self.film.index(of: filmItem["name"]!)!
            self.film[index] = filmItem["name"]!
            self.updateDatas()
        })*/
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        if !self.movies.isEmpty {
            cell.display(data:movies[indexPath.row])
        }
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? UITableViewCell
        let indexPath = tableView.indexPath(for: cell!)
        let svc = segue.destination as! DetailViewController;
        svc.image = self.test[(indexPath?.row)!]
    }
}

