
import UIKit

class SearchMovieVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    //MARK:- Variables
    private var movieSearchViewModel : SearchViewModel = SearchViewModel()
    var recentSearchModel : [SearchMovie] = [SearchMovie]()
    let searchController = UISearchController(searchResultsController: nil)
    var selectedIndexForCell = -1
    
    //MARK:- Initialisation
    init(searchViewModel: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.movieSearchViewModel = searchViewModel
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setUpTableView()
        self.moviesTableView.backgroundColor = #colorLiteral(red: 0.1696988046, green: 0.1906097233, blue: 0.2814527452, alpha: 1)
    }
    
    private func setUpTableView() {
        self.moviesTableView.register(UINib(nibName: CellIdentifier.SearchMovieCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.SearchMovieCell)
        self.moviesTableView.register(UINib(nibName: LoadingCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: LoadingCell.cellIdentifier)
        self.moviesTableView.register(UINib(nibName: EmptyDataCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: EmptyDataCell.cellIdentifier)
        
        self.moviesTableView.rowHeight = UITableView.automaticDimension
        self.moviesTableView.estimatedRowHeight = 300
        self.moviesTableView.tableFooterView = UIView()
    }
    
    private func setupUI() {
    
        self.configureNavigationWithAction(NSLocalizedString("Movies Search", comment: ""), leftImage: nil, actionForLeft: nil, rightImage: nil, actionForRight: nil)

        searchBar.delegate = self
        searchBar.becomeFirstResponder()

        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
        }
        
        self.bindViewModel()
    }
    
    //MARK:- Data binding
    private func bindViewModel() {
        let data = UserDefaults.standard.data(forKey: Constants.Keys.savedMovieData)
        
        do {
            recentSearchModel = try PropertyListDecoder().decode([SearchMovie].self, from: data ?? Data())
            //print(recentSearchModel.count )
            
            DispatchQueue.main.async {
                self.moviesTableView?.reloadData()
            }
        }
        catch _ {
//            return nil
        }
        
        movieSearchViewModel.searchResult.bind {[weak self] _ in
            DispatchQueue.main.async {
                self?.moviesTableView?.reloadData()
            }
        }

        movieSearchViewModel.state.bind({[weak self] state in
            switch state {
            case .error(let error):
                self?.presentNetworkError(error: error)
            case .loading, .finishedLoading:
                break
            }
        })
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension SearchMovieVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if movieSearchViewModel.searchMode == true {
            if(movieSearchViewModel.currentPage > movieSearchViewModel.totalPages){
                return 2
            }else{
                return 3
            }
        }else{
            
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if recentSearchModel.count == 0 {
                return 1
               } else {
                
                tableView.restore()
                return recentSearchModel.count
               }
        } else if section == 1 {
            if(movieSearchViewModel.searchMode == true){
                let state = movieSearchViewModel.state.value
                let movieList = movieSearchViewModel.searchResult.value
                
                if(movieList.count == 0 && state != .loading){
                    return 2
                }else{
                    return movieList.count
                    
                }
            }else{
                return 0
            }
        }else if section == 2 {
            if(movieSearchViewModel.searchResult.value.count > 0){
                return 1
            }else{
                //tableView.setEmptyMessage("No data available")
                return 0
            }
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.textColor = .white
        headerView.backgroundColor = #colorLiteral(red: 0.1696988046, green: 0.1906097233, blue: 0.2814527452, alpha: 1)
        
        switch section {
        case 0:
                label.text = " Recent Search"
        case 1:
            if(movieSearchViewModel.searchResult.value.count > 0){
                label.text = " Search Movies"
            }else{
                label.text = ""
            }
            
        default:
            label.text = ""
        }
        headerView.addSubview(label)
        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SearchMovieCell) as? SearchMovieCell else { return UITableViewCell() }
        
        switch indexPath.section{
        case 0:
            if (recentSearchModel.count > 0){

                let objList = recentSearchModel[indexPath.row]
                cell.titleLabel.text = objList.title
                cell.overviewLabel.text = objList.overview
                if let moviePoster = objList.posterUrl() {
                cell.posterImage.downloadImageWithCaching(with: moviePoster.absoluteString ,placeholderImage: #imageLiteral(resourceName: "icons8-film_reel"))
                    //cell.btnReadMore.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)


                } else {
                cell.posterImage.image = #imageLiteral(resourceName: "icons8-film_reel")
                }

                if (indexPath.row % 2) != 0{
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.1696988046, green: 0.1906097233, blue: 0.2814527452, alpha: 0.8050584604)
                }else{
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.1696988046, green: 0.1906097233, blue: 0.2814527452, alpha: 1)

                }
                return cell
            }
            else {

                if let cell = tableView.dequeueReusableCell(withIdentifier: EmptyDataCell.cellIdentifier) as? EmptyDataCell {
                    cell.emptyMessageLabel.text = "Your recent search list is empty"
                    return cell
                }else{
                    return UITableViewCell()
                }
            }
                        
        case 1:
          if movieSearchViewModel.searchMode == true{
            if (movieSearchViewModel.searchResult.value.count > 0){
                    
            let objList = movieSearchViewModel.searchResult.value[indexPath.row]
            cell.titleLabel.text = objList.title
            cell.overviewLabel.text = objList.overview
            if let moviePoster = objList.posterUrl() {
                cell.posterImage.downloadImageWithCaching(with: moviePoster.absoluteString ,placeholderImage: #imageLiteral(resourceName: "icons8-film_reel"))
            } else {
                cell.posterImage.image = #imageLiteral(resourceName: "icons8-film_reel")
            }
            
                if (indexPath.row % 2) != 0{
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.1696988046, green: 0.1906097233, blue: 0.2814527452, alpha: 0.8050584604)
                }else{
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.1696988046, green: 0.1906097233, blue: 0.2814527452, alpha: 1)

                }
                return cell
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: EmptyDataCell.cellIdentifier) as? EmptyDataCell {
                    cell.emptyMessageLabel.text = ""
                    return cell
                }else{
                    return UITableViewCell()
                }
              }
            } else{
                return UITableViewCell()
                
            }
            default :
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.cellIdentifier) as? LoadingCell else { return UITableViewCell() }
                       cell.activityIndicator.startAnimating()
                       return cell

        }
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return UITableView.automaticDimension
      }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var movieId : Int = -1
        if(indexPath.section == 0){
            let movieToSave = recentSearchModel[indexPath.row]
            movieId = movieToSave.id
        }else{
            let movieToSave = movieSearchViewModel.searchResult.value[indexPath.row]
            movieId = movieToSave.id
            if recentSearchModel.filter({$0.id == movieToSave.id}).count == 0{
            if recentSearchModel.count > 0 && recentSearchModel.count < 5{
                
                recentSearchModel.insert(movieToSave, at: 0)
            }else{
                if (recentSearchModel.count > 0){
                    recentSearchModel.remove(at: recentSearchModel.count - 1)
                }
                recentSearchModel.insert(movieToSave, at: 0)
            }
                
                self.moviesTableView.reloadData()
            }
            do{
                let dataEncoded = try PropertyListEncoder().encode(recentSearchModel)
                UserDefaults.standard.set(dataEncoded, forKey: Constants.Keys.savedMovieData)
                                        UserDefaults.standard.synchronize()
            }catch {
                //print(error)
                
            }
        }
        
        let detailVC:MovieDetailsVC = MainStoryBoard.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
                detailVC.movieIdToPass = movieId
            self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height){
            if movieSearchViewModel.searchMode == true && searchBar.text != ""{
                guard let searchText = searchBar.text else { return }
                movieSearchViewModel.search(query: searchText)
            }
        }
    }
    
    
}

extension SearchMovieVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movieSearchViewModel.searchTextChanged(query: searchBar.text)
        if movieSearchViewModel.searchMode == false {
            moviesTableView.reloadData()
        }
        
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        movieSearchViewModel.searchDidBeginEditing(query: searchBar.text)
        
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        movieSearchViewModel.resetSearch()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


