
import Foundation
import UIKit


let IMAGE_URL           = "https://image.tmdb.org/t/p/w200"
let BACK_IMAGE_URL      = "https://image.tmdb.org/t/p/w500"

let BASE_URL = "https://api.themoviedb.org/3"
let URL_NOW_PLAYING = "\(BASE_URL)" + "/movie/now_playing?api_key=" + "\(MovieDatabaseKeys.API_KEY)"
let URL_SIMILAR_MOVIE = "/similar?api_key=" + "\(MovieDatabaseKeys.API_KEY)"


struct MovieDatabaseKeys {
    
    static let API_KEY = "7629f0cb2f838d0592a4c47d91717b6a"
}

struct CellIdentifier {

    static let MoviesListCell = "MoviesListCell"
    static let SearchMovieCell = "SearchMovieCell"
}


let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

let selectedTabIndexKey = "selectedTabIndex"

struct Constants {
    
    enum titles:Int, CustomStringConvertible, CaseIterable {
        case features = 1
       
        public var description: String {
            get {
                switch self {
                case .features:
                    return ""
                
            }
         }
       }
    }
    
    struct Keys {
        static let savedMovieData = "savedMovieData"
    }
}
