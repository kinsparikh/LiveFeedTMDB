//
//  Environment.swift
//  MovieApp
//
//  Created by Kayaan Parikh on 12/11/18.
//  Copyright © 2021 Kayaan Parikh. All rights reserved.
//

import Foundation

enum Server {
    case developement
    case staging
    case production
}

class Environment {
   
    static let server:Server    =   .developement
    
    // To print the log set true.
    static let debug:Bool       =   true
    
    class func APIBasePath() -> String {
        switch self.server {
            case .developement:
                return "https://api.themoviedb.org/"
            case .staging:
                return "https://api.themoviedb.org/"
            case .production:
                return "https://api.themoviedb.org/"
        }
    }
    
    class func APIVersionPath() -> String {
        switch self.server {
        case .developement:
            return "3/"
        case .staging:
            return "3/"
        case .production:
            return "3/"
        }
    }
    
    class func MOVIEDB_APIKEY() -> String {
        switch self.server {
        case .developement:
            return "14bc774791d9d20b3a138bb6e26e2579"
        case .staging:
            return "14bc774791d9d20b3a138bb6e26e2579"
        case .production:
            return "14bc774791d9d20b3a138bb6e26e2579"
        }
    }
    
}


