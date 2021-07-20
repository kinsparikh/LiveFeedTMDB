
import Foundation

struct SimilarMovies: Codable {

  enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case results
    case totalPages = "total_pages"
  }

  var page: Int?
  var totalResults: Int?
  var results: [ResultsSimilarMovie]?
  var totalPages: Int?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    page = try container.decodeIfPresent(Int.self, forKey: .page)
    totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
    results = try container.decodeIfPresent([ResultsSimilarMovie].self, forKey: .results)
    totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
  }

}

struct ResultsSimilarMovie: Codable {

  enum CodingKeys: String, CodingKey {
    case id
    case genreIds = "genre_ids"
    case posterPath = "poster_path"
    case originalTitle = "original_title"
    case releaseDate = "release_date"
    case originalLanguage = "original_language"
    case voteCount = "vote_count"
    case voteAverage = "vote_average"
    case backdropPath = "backdrop_path"
    case overview
    case video
    case title
    case popularity
    case adult
    case _imageURL
  }

    var id: Int?
    var genreIds: [Int]?
    var posterPath: String?
    var imageURL : String {
    if _imageURL != nil {
        return _imageURL ?? ""
    }
    if posterPath != nil {
        return IMAGE_URL + (posterPath ?? "")
    }
    return ""
    }
    var _imageURL : String?
    var originalTitle: String?
    var releaseDate: String?
    var originalLanguage: String?
    var voteCount: Int?
    var voteAverage: Float?
    var backdropPath: String?
    var overview: String?
    var video: Bool?
    var title: String?
    var popularity: Float?
    var adult: Bool?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)
    posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
    releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
    originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
    voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
    voteAverage = try container.decodeIfPresent(Float.self, forKey: .voteAverage)
    backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    overview = try container.decodeIfPresent(String.self, forKey: .overview)
    video = try container.decodeIfPresent(Bool.self, forKey: .video)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    popularity = try container.decodeIfPresent(Float.self, forKey: .popularity)
    adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
    _imageURL = try container.decodeIfPresent(String.self, forKey: ._imageURL)
  }

}

