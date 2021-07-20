

import Foundation

struct SearchMovieResponse: Codable {
    var movies: [SearchMovie]
    var page: Int
    var totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
    }
}

struct SearchMovie: Codable {

    var id: Int
    var title: String?
    var overview: String?
    var poster: String?
    private var voteAverage: Decimal
    var releaseDate: String?
    var rating: NSDecimalNumber {
        get { return NSDecimalNumber(decimal: voteAverage) }
    }

    init(id: Int, title: String, overview: String, poster: String, voteAverage: Decimal, releaseDate: String) {
        self.id = id
        self.title = title
        self.overview = overview
        self.poster = poster
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
    }

    func posterUrl() -> URL? {
        return URL(string: "\(IMAGE_URL)\(poster ?? "")")
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case poster = "poster_path"
        case voteAverage = "vote_average"
    }
}
