
import Foundation

class MovieDetailsViewModel : NSObject {
    
    private var apiService : APIService!
    var error: NSError?
    private(set) var movieDetailsData : Movie!{
        didSet {
            self.bindMovieDetailsViewModelToController()
        }
    }
    
    private(set) var movieSimilarData : SimilarMovies?{
        didSet {
            self.bindMovieDetailsViewModelToController()
        }
    }
    
    var movieId: Int = 0 {
        didSet {
            if oldValue != movieId {
                //print(oldValue)
                callFuncToGetMovieDetailsData(id: movieId)
                callFuncToGetMovieSimilarData(id: movieId)
            }
        }
    }
    
    var bindMovieDetailsViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    func callFuncToGetMovieDetailsData(id: Int) {
        self.movieDetailsData = nil
        self.apiService.apiToGetMovieDetailData(id: id) { [weak self] (result) in
            switch result {
            case .success(let movie):
                self?.movieDetailsData = movie
            case .failure(let error):
                self?.error = error as NSError
            }
        }
    }
    
    func callFuncToGetMovieSimilarData(id : Int) {
        self.apiService.apiToGetSimilarMovieData(id: id) { (data, error) in
            self.movieSimilarData = data
        }
    }
}
