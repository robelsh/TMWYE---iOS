//
//  Movie.swift
//  media
//
//  Created by Etienne Jézéquel on 08/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import Foundation

class Movie {
    var title:String = ""
    var year:String = ""
    var poster:Data = Data()
    var rating:String = ""
    var plot:String = ""
    var runtime:String = ""
    var released:String = ""
    var genre:[String] = []
    var countries:[String] = []
    var imdbId:String = ""
    var id:String = ""
    var posterURL:String = ""
    
    func extractYearFromRelease(released:String) -> String {
        let index = released.index(released.startIndex, offsetBy: 4)
        return released.substring(to: index)
    }
}
