//
//  Movie.swift
//  media
//
//  Created by Etienne Jézéquel on 08/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import Foundation

class Movie {
    var title:String
    var year:String
    var poster:String
    var rating:String
    var plot:String
    var runtime:String
    var released:String
    var genre:String
    var country:String
    var imdbId:String
    var id:String

    
    init(title:String, year:String, poster:String, rating:String, plot:String, runtime:String, released:String, genre:String, country:String, imdbId:String, id:String) {
        self.country = country
        self.year = year
        self.title = title
        self.poster = poster
        self.rating = rating
        self.plot = plot
        self.runtime = runtime
        self.released = released
        self.genre = genre
        self.imdbId = imdbId
        self.id = id
    }
    
    init(){
        self.country = ""
        self.year = ""
        self.title = ""
        self.poster = ""
        self.rating = ""
        self.plot = ""
        self.runtime = ""
        self.released = ""
        self.genre = ""
        self.imdbId = ""
        self.id = ""
    }
    

    
}
