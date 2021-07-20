
import UIKit

class MovieDetailsVC: UITableViewController {
    
    //MARK:- IBOutlet
    @IBOutlet var lblReview: ExpandableLabel!
    @IBOutlet var lblStarring: UILabel!
    @IBOutlet var lblDirector: UILabel!
    @IBOutlet var lblRatingValue: UILabel!
    @IBOutlet var lblStar: UILabel!
    @IBOutlet var lblMovieTitle: UILabel!
    @IBOutlet var lblOverview: UILabel!
    @IBOutlet var lblGernYearDuration: UILabel!
    @IBOutlet var lblMovieSubtitle: UILabel!
    @IBOutlet var imgMovieBgCover: UIImageView!
    @IBOutlet var imgMovieCover: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    var movieIdToPass = 0
    var list : [ResultsSimilarMovie] = [ResultsSimilarMovie]()
    var movieDetailsViewModel = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.tabelViewSetup()
    }
    
    
    //MARK:- UI Setup
    private func setupUI() {
        self.configureNavigationWithAction(NSLocalizedString("Movie Details", comment: ""), leftImage: nil, actionForLeft: nil, rightImage: nil, actionForRight: nil)
        self.getMovieData(movieId: movieIdToPass)
        self.lblReview.delegate = self
        self.lblReview.collapsedAttributedLink = NSAttributedString(string: "Read More")
        collectionView.register(UINib.init(nibName: "SimilarMovieListCell", bundle: nil), forCellWithReuseIdentifier: "SimilarMovieListCell")
        
    }
    
    func tabelViewSetup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }
    
    //MARK:- Data Binding
    func getMovieData(movieId : Int){
        self.movieDetailsViewModel.movieId = movieId
        self.movieDetailsViewModel.bindMovieDetailsViewModelToController = {
            if self.movieDetailsViewModel.movieDetailsData?.genres?.count ?? 0 > 0 {
                self.movieData(movie: self.movieDetailsViewModel.movieDetailsData!)
            }
            if (self.movieDetailsViewModel.movieSimilarData?.results != nil){
                self.list = self.movieDetailsViewModel.movieSimilarData?.results ?? []
                self.configure(items: self.list)
            }
            
        }
    }
    func movieData(movie : Movie){
       
        DispatchQueue.main.async
        {
            //print(movie.imageBgURL)
            self.lblMovieTitle.text = "\(movie.title)"
            self.lblMovieSubtitle.text = "\(movie.tagline ?? "")"
            self.imgMovieCover.roundCorners([.allCorners], radius: 10.0)
            self.imgMovieBgCover.downloadImageWithCaching(with: movie.imageBgURL,placeholderImage: #imageLiteral(resourceName: "moviePlaceholder"))
            self.imgMovieCover.downloadImageWithCaching(with: movie.imageURL ,placeholderImage: #imageLiteral(resourceName: "moviePlaceholder"))
            self.lblOverview.text = "\(movie.overview)"
            self.lblGernYearDuration.text = "\(movie.genreText)" + " | " + "\(movie.yearText)" + " \(movie.durationText)"
            
            if !movie.ratingText.isEmpty {
                self.lblStar.text = movie.ratingText
                self.lblStar.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                self.lblRatingValue.text = "\(movie.scoreText)"
            }

            if movie.cast != nil && movie.cast!.count > 0 {
                //    Text("Starring").font(.headline)
                var arrCast = [String]()
                arrCast = movie.cast?.prefix(10).compactMap{$0.name} ?? []
                let joined = arrCast.joined(separator: "\n")
                self.lblStarring.text = "\(joined)"
                }

            if movie.crew != nil && movie.crew!.count > 0 {
                var arrCrew = [String]()
                arrCrew = movie.crew?.prefix(8).compactMap{$0.name} ?? []
                let joinedCrew = arrCrew.joined(separator: "\n")
                self.lblDirector.text = "\(joinedCrew)"
                }

            if(movie.reviews?.results?.first?.content == "" || movie.reviews?.results?.first?.content == nil){
                self.lblReview.text = "No Reviews Available"
            }else{
                self.lblReview.text = "\(movie.reviews?.results?[0].content ?? "")"
            }
            
            self.tableView.reloadData()
        }
        
    }
}

//MARK:- Tableview Related
extension MovieDetailsVC {
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
      }
      
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 255
        }else if(indexPath.section == 5){
            return 230
        }else{
            return UITableView.automaticDimension
        }
      }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.font = UIFont(name: "AvenirNext-Regular", size: 15)
            header.textLabel!.textColor = UIColor.white
        }
    }
}

//MARK:- Expandable Label
extension MovieDetailsVC : ExpandableLabelDelegate{
    func willExpandLabel(_ label: ExpandableLabel) {
        self.tableView.reloadData()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        print(label)
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        print(label)
        self.tableView.reloadData()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        print(label)
    }
    
    
}

//MARK:- CollectionView Related
extension MovieDetailsVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func configure(items : [ResultsSimilarMovie]) {
        list = items
        DispatchQueue.main.async
        {
            self.collectionView.delegate = self
            self.collectionView.dataSource  = self
        
            self.setLayout()
        }
    }
    
    func setLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.itemSize = CGSize(width: self.collectionView.frame.width / 2 - 25, height: self.collectionView.frame.width / 2 + 10)
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarMovieListCell", for: indexPath as IndexPath) as! SimilarMovieListCell
        cell.titleLabel.text = self.list[indexPath.row].title
        cell.imgMovieCover.downloadImageWithCaching(with: "\(self.list[indexPath.row].imageURL)" ,placeholderImage: #imageLiteral(resourceName: "moviePlaceholder"))
        cell.backgroundColor = .clear
        return cell
    }

}
