//
//  FlixMovie.swift
//  Flix
//
//  Created by Sudipta Bhowmik on 10/12/17.
//  Copyright © 2017 Sudipta Bhowmik. All rights reserved.
//

import Foundation
class FlixMovie {
    var title: String
    var voteAverage : Double
    var posterPath : String
    var releaseDate : String
    var overview : String
    
    
    struct responseDictKeys {
        static let overview = "overview"
        static let title = "title"
        static let voteAvg = "vote_average"
        static let posterPath = "poster_path"
        static let relDate = "release_date"
    }
    
    
    init (movieDict : NSDictionary) {
        title = movieDict[responseDictKeys.title] as! String
        voteAverage = movieDict[responseDictKeys.voteAvg] as! Double
        posterPath = movieDict[responseDictKeys.posterPath] as! String
        releaseDate = movieDict[responseDictKeys.relDate] as! String
        overview = movieDict[responseDictKeys.overview] as! String
    }
}
