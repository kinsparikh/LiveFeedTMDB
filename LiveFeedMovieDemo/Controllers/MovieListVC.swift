//
//  ViewController.swift
//  LiveFeedMovieDemo
//
//  Created by Kayaan Parikh on 15/06/21.
//  Copyright © 2021 Kayaan Parikh. All rights reserved.
//

import UIKit

class MovieListVC: UIViewController, UITableViewDelegate,ActivityIndicatorViewable {
    
    //MARK:- IBOutlet
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet var searchBarView: UIView!
    
    //MARK:- Variables
    private var movieViewModel : MovieNowShowingViewModel!
    private var movieDataViewModel : NowShowing!
    private var dataSource : MoviesTableViewDataSource<MoviesListCell,MovieResults>!
    var searchBar:UISearchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.tabelViewSetup()
        self.callToViewModelForUIUpdate()
    }
    
    //MARK:- UI Setup
    private func setupUI() {
        
        self.configureNavigationWithAction(NSLocalizedString("Movies List", comment: ""), leftImage: nil, actionForLeft: nil, rightImage: nil, actionForRight: nil)
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .default
        searchBar.placeholder = " Search movies here..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
        }
        searchBarView.addSubview(searchBar)
    }
    private func tabelViewSetup(){
        self.moviesTableView.backgroundColor = #colorLiteral(red: 0.1696988046, green: 0.1906097233, blue: 0.2814527452, alpha: 1)
        self.moviesTableView.register(UINib(nibName: CellIdentifier.MoviesListCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.MoviesListCell)
        self.moviesTableView.rowHeight = UITableView.automaticDimension
        self.moviesTableView.estimatedRowHeight = 300
        self.moviesTableView.delegate = self
    }
    
    func callToViewModelForUIUpdate(){
        DispatchQueue.main.async {
            self.showActivityIndicator()
        }
        self.movieViewModel =  MovieNowShowingViewModel()
        self.movieViewModel.bindMoviesViewModelToController = {
            if self.movieViewModel.movieData.results?.count ?? 0 > 0 {
                self.updateDataSource()
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            }
        }
    }
    
    //MARK:- Update Table Data
    func updateDataSource(){
        
        self.dataSource = MoviesTableViewDataSource(cellIdentifier: CellIdentifier.MoviesListCell, items: self.movieViewModel.movieData.results ?? [] , configureCell: { (cell, movie) in
            cell.imgMovie.downloadImageWithCaching(with: movie.imageURL,placeholderImage: #imageLiteral(resourceName: "moviePlaceholder"))
            cell.lblMovieTitle.text = "\(movie.title ?? "")"
            cell.lblMovieDescription.text = "\(movie.overview ?? "")"
            cell.lblMovieReleaseDate.text = "\(movie.releaseDate ?? "")"
            cell.buttoPress = {
                let detailVC:MovieDetailsVC = MainStoryBoard.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
                let selectedItemId = movie.id
                detailVC.movieIdToPass = selectedItemId ?? 0
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
        })
        DispatchQueue.main.async {
            self.moviesTableView.dataSource = self.dataSource
            self.moviesTableView.reloadData()
        }
    }

   
}

//MARK:- SearchBar Delegate
extension MovieListVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {

    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
       return true
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC:SearchMovieVC = MainStoryBoard.instantiateViewController(withIdentifier: "SearchMovieVC") as! SearchMovieVC
        self.navigationController?.pushViewController(searchVC, animated: true)
        return false
    }
    
    
    
}


