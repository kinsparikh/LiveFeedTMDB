
import Foundation

class MovieNowShowingViewModel : NSObject {
    
    private var apiService : APIService!
    private(set) var movieData : NowShowing! {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    
    var bindMoviesViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
        callFuncToGetMovieData()
    }
    
    func callFuncToGetMovieData() {
        self.apiService.apiToGetMovieData { (data, error) in
            self.movieData = data
        }
    }
}
