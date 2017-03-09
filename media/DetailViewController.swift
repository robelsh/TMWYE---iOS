//
//  DetailViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var plot: UITextView!
    @IBOutlet weak var genre: UILabel!

    var movie:Movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movie.title
        self.country.text = movie.country
        self.genre.text = movie.genre
        self.plot.text = movie.plot
        self.rating.text = movie.rating
        self.released.text = movie.released
        self.year.text = movie.year
        self.runtime.text = movie.runtime
        self.titleTextLabel.text = movie.title
        self.image.image = UIImage(data: movie.poster)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
