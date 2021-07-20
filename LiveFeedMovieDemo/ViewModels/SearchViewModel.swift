
import Foundation

class SearchViewModel : NSObject {
    
    //MARK:- Properties
    private var apiService: APIService
    private (set) var state: Bindable<FetchingServiceState> = Bindable(.loading)
    private (set) var searchResult: Bindable<[SearchMovie]> = Bindable([])
    private (set) var searchMode = false
    private (set) var currentPage: Int = 1
    private (set) var totalPages: Int = Int.max
    private (set) var currentQuery: String?
    private var searchWaitTimer: Timer?
    var error: NSError?
    
    
    //MARK:- init
    override init() {
        self.apiService =  APIService()
    }

    //MARK:- Methods
    func search(query: String) {
        if currentQuery != query {
            resetValues()
            currentQuery = query
        }
        if currentPage > totalPages { return }
        state.value = .loading
        apiService.searchMovie(query: query, currentPage: "\(currentPage)", completion: { [weak self] response in
            self?.state.value = .finishedLoading
            switch response {
            case .success(let result):
                self?.searchResult.value.append(contentsOf: result.movies)
                self?.totalPages = result.totalPages
                self?.currentPage += 1
            case .failure(let error):
                self?.state.value = .error(.unknown)
            }
        })
    }

    func searchTextChanged(query: String?) {
        if query == nil || query?.isEmpty == true {
            stopSearchTimer()
            searchMode = false
        } else {
            searchMode = true
            startSearchTimer(query: query ?? "")
        }
    }

    func searchDidBeginEditing(query: String?) {
        if query == nil || query?.isEmpty == true {
            resetSearch()
        }
        searchMode = true
    }
    
    func resetSearch() {
        searchMode = false
        resetValues()
    }

    //MARK:- Helpers
    private func resetValues() {
        currentPage = 1
        totalPages = Int.max
        searchResult.value.removeAll()
    }

    private func stopSearchTimer() {
         searchWaitTimer?.invalidate()
         searchWaitTimer = nil
     }

    private func startSearchTimer(query: String) {
         stopSearchTimer()
         searchWaitTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[weak self] _ in
            self?.performSearch(query: query)
         })
     }

    private func performSearch(query: String) {
         stopSearchTimer()
         search(query: query)
     }
}
