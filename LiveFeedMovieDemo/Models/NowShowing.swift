
import Foundation

struct NowShowing: Codable {

  enum CodingKeys: String, CodingKey {
    case results
    case totalResults = "total_results"
    case dates
    case totalPages = "total_pages"
    case page
  }

  var results: [MovieResults]?
  var totalResults: Int?
  var dates: Dates?
  var totalPages: Int?
  var page: Int?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    results = try container.decodeIfPresent([MovieResults].self, forKey: .results)
    totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
    dates = try container.decodeIfPresent(Dates.self, forKey: .dates)
    totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
    page = try container.decodeIfPresent(Int.self, forKey: .page)
  }

}

struct MovieResults: Codable {

  enum CodingKeys: String, CodingKey {
    case backdropPath = "backdrop_path"
    case voteCount = "vote_count"
    case popularity
    case posterPath = "poster_path"
    case id
    case adult
    case title
    case releaseDate = "release_date"
    case overview
    case video
    case genreIds = "genre_ids"
    case originalLanguage = "original_language"
    case voteAverage = "vote_average"
    case originalTitle = "original_title"
    case _imageURL
  }

    var backdropPath: String?
    var voteCount: Int?
    var popularity: Float?
    var posterPath: String?
    var id: Int?
    var adult: Bool?
    var title: String?
    var releaseDate: String?
    var overview: String?
    var video: Bool?
    var genreIds: [Int]?
    var originalLanguage: String?
    var voteAverage: Float?
    var originalTitle: String?
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



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
    popularity = try container.decodeIfPresent(Float.self, forKey: .popularity)
    posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
    overview = try container.decodeIfPresent(String.self, forKey: .overview)
    video = try container.decodeIfPresent(Bool.self, forKey: .video)
    genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)
    originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
    voteAverage = try container.decodeIfPresent(Float.self, forKey: .voteAverage)
    originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
    _imageURL = try container.decodeIfPresent(String.self, forKey: ._imageURL)
  }

}

struct Dates: Codable {

  enum CodingKeys: String, CodingKey {
    case maximum
    case minimum
  }

  var maximum: String?
  var minimum: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    maximum = try container.decodeIfPresent(String.self, forKey: .maximum)
    minimum = try container.decodeIfPresent(String.self, forKey: .minimum)
  }

}
