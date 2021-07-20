//
//  Utils.swift
//  SwiftUIMovieDb
//
//  Created by Kayaan Parikh on 15/06/21.
//  Copyright © 2021 Kayaan Parikh. All rights reserved.
//

import Foundation

class Utils {
    
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
}

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

enum Task {
    case requestPlain
    case requestParameters([String: String])
}

enum ParametersEncoding {
    case url
    case json
}

enum APIResponse<T> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError {
    case unauthorized
    case unknown
    case noJSONData
    case JSONDecoder
}

enum FetchingServiceState: Equatable {
    case loading
    case finishedLoading
    case error(NetworkError?)
}
