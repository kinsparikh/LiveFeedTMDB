
import Foundation

struct MovieResponse: Decodable {
    
    let results: [Movie]
    var page: Int
    var totalPages: Int

}


struct Movie: Decodable, Identifiable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let title: String
    let tagline: String?
    let backdropPath: String?
    let posterPath: String?
    var imageURL : String {
        if _imageURL != nil {
            return _imageURL ?? ""
        }
        if posterPath != nil {
            return IMAGE_URL + (posterPath ?? "")
        }
        return ""
    }
    var _imageURL: String?
    
    var imageBgURL : String {
        if _imageBgURL != nil {
            return _imageBgURL ?? ""
        }
        if backdropPath != nil {
            return IMAGE_URL + (backdropPath ?? "")
        }
        return ""
    }
    var _imageBgURL: String?
    
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    
    let genres: [MovieGenre]?
    let credits: MovieCredit?
    let reviews: MovieReviewsModel?
    let similarMovies : SimilarMovies?
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        return ratingText
    }
    
    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }
    
    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        return Movie.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    var cast: [MovieCast]? {
        credits?.cast
    }
    
    var crew: [MovieCrew]? {
        credits?.crew
    }
    
    var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    
    var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    
    var screenWriters: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }
    
    
}

struct MovieGenre: Decodable {
    
    let name: String
}

struct MovieCredit: Decodable {
    
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
}

struct MovieCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
}


struct MovieReviewsModel: Codable {

  enum CodingKeys: String, CodingKey {
    case totalPages = "total_pages"
    case id
    case page
    case results
    case totalResults = "total_results"
  }

  var totalPages: Int?
  var id: Int?
  var page: Int?
  var results: [ReviewsResults]?
  var totalResults: Int?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    page = try container.decodeIfPresent(Int.self, forKey: .page)
    results = try container.decodeIfPresent([ReviewsResults].self, forKey: .results)
    totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
  }

}

struct AuthorDetails: Codable {

  enum CodingKeys: String, CodingKey {
    case rating
    case avatarPath = "avatar_path"
    case username
    case name
  }

  var rating: Int?
  var avatarPath: String?
  var username: String?
  var name: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    rating = try container.decodeIfPresent(Int.self, forKey: .rating)
    avatarPath = try container.decodeIfPresent(String.self, forKey: .avatarPath)
    username = try container.decodeIfPresent(String.self, forKey: .username)
    name = try container.decodeIfPresent(String.self, forKey: .name)
  }

}

struct ReviewsResults: Codable {

  enum CodingKeys: String, CodingKey {
    case id
    case url
    case content
    case createdAt = "created_at"
    case authorDetails = "author_details"
    case author
    case updatedAt = "updated_at"
  }

  var id: String?
  var url: String?
  var content: String?
  var createdAt: String?
  var authorDetails: AuthorDetails?
  var author: String?
  var updatedAt: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(String.self, forKey: .id)
    url = try container.decodeIfPresent(String.self, forKey: .url)
    content = try container.decodeIfPresent(String.self, forKey: .content)
    createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    authorDetails = try container.decodeIfPresent(AuthorDetails.self, forKey: .authorDetails)
    author = try container.decodeIfPresent(String.self, forKey: .author)
    updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
  }

}

