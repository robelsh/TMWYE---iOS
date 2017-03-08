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
    var film:[String] = []
    var datas:[Dictionary<String,String>] = [[:]]
    var images:[Data] = []
    var ref: FIRDatabaseReference!
    
    var tableViewControler = UITableViewController(style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()

        ref.child("medias").observe(.childAdded, with: { (snapshot) -> Void in
            let filmItem:Dictionary<String,String> = snapshot.value as! Dictionary<String,String>
            self.film.append(filmItem["name"]!)
            self.updateDatas()
        })
        
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
        })
    
    }
    
    func updateDatas(){
        self.getDatas()
        self.tableView.reloadData()
    }
    
    func getDatas(){
        var imagesItems:[Data] = []
        var datasItems:[Dictionary<String,String>] = [[:]]
        
        for movie in film {
            let data = parseJSON(inputData: getJSON(urlToRequest: baseURL + "/?t="+movie+"&y=&plot=short&r=json"))
            let url = URL(string: data["Poster"]!)
            imagesItems.append(try! Data(contentsOf:  url!))
            datasItems.append(data)
        }
        self.datas = datasItems
        self.images = imagesItems
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
        return images.count
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            ref.child("medias/name/\(indexPath.row)").removeValue()
            self.test.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        if !self.datas.isEmpty {
            cell.display(poster: images[indexPath.row],data:self.datas[indexPath.row+1])
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

