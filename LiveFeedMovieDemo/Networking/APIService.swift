//
//  APIService.swift
//  LiveFeedMovieDemo
//
//  Created by Kayaan Parikh on 15/06/21.
//  Copyright © 2021 Kayaan Parikh. All rights reserved.
//

import Foundation

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}

class APIService :  NSObject {
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func apiToGetMovieData(onCompletion : @escaping (NowShowing?, ErrorCase) -> Void){
        
        RestAPIManager.sharedInstance.makeHTTPGetRequest(path: URL_NOW_PLAYING) { (json,data, error)  in
            //print("Movies Data: \(json)")
            var nowShowingResponseModel : NowShowing? = nil
            guard json.dictionaryObject != nil else{
                onCompletion(nil, error!)
                return
            }
            
            if error == ErrorCase.NoError
            {
                do {
                    nowShowingResponseModel = try decoder.decode(NowShowing.self, from: jsonToDataForCodableModel(inputJson : json))
                    
                    if nowShowingResponseModel?.results?.count ?? 0 > 0{
                        onCompletion(nowShowingResponseModel, ErrorCase.NoError)
                    }else{
                        onCompletion(nowShowingResponseModel, ErrorCase.SomethingWentWrong)
                    }
                } catch {
                     onCompletion(nil, ErrorCase.SomethingWentWrong)
                    //print(error.localizedDescription)
                }
            }
            else{
                onCompletion(nowShowingResponseModel, ErrorCase(rawValue: error!.rawValue)!)
            }
        }
    }
    
    func apiToGetSimilarMovieData(id : Int, onCompletion : @escaping (SimilarMovies?, ErrorCase) -> Void){
        
        RestAPIManager.sharedInstance.makeHTTPGetRequest(path: "\(BASE_URL)/movie/\(id)" + URL_SIMILAR_MOVIE) { (json,data, error)  in
            //print("Movies Similar Data: \(json)")
            var similarResponseModel : SimilarMovies? = nil
            guard json.dictionaryObject != nil else{
                onCompletion(nil, error!)
                return
            }
            
            if error == ErrorCase.NoError
            {
                do {
                    similarResponseModel = try decoder.decode(SimilarMovies.self, from: jsonToDataForCodableModel(inputJson : json))
                    
                    if similarResponseModel?.results?.count ?? 0 > 0{
                        onCompletion(similarResponseModel, ErrorCase.NoError)
                    }else{
                        onCompletion(similarResponseModel, ErrorCase.SomethingWentWrong)
                    }
                } catch {
                     onCompletion(nil, ErrorCase.SomethingWentWrong)
                    //print(error.localizedDescription)
                }
            }
            else{
                onCompletion(similarResponseModel, ErrorCase(rawValue: error!.rawValue)!)
            }
        }
    }
    
    func apiToGetMovieDetailData(id : Int, onCompletion : @escaping (Result<Movie, MovieError>) -> Void){
        
            guard let url = URL(string: "\(BASE_URL)/movie/\(id)") else {
                onCompletion(.failure(.invalidEndpoint))
                return
            }
            self.loadURLAndDecode(url: url, params: [
                "append_to_response": "credits,reviews"
            ], completion: onCompletion)
    }
    
    func searchMovie(query: String, currentPage : String, completion: @escaping (Result<SearchMovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(BASE_URL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "page": currentPage,
            "query": query
        ], completion: completion)
    }
    
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: MovieDatabaseKeys.API_KEY)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                
                let decodedResponse = (url.absoluteString.contains("search")) ? try JSONDecoder().decode(D.self, from: data) : try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}


func jsonToDataForCodableModel(inputJson jsonValue: JSON) -> Data{
    let jsonDataString = jsonValue.dictionaryObject!.convertIntoJSONString()
    let jsonData = jsonDataString!.data(using: .utf8)!
    return jsonData
}


extension Dictionary {
   
    func convertIntoJSONString() -> String? {
       
       do {
           let jsonData: Data = try JSONSerialization.data(withJSONObject: self, options:  .prettyPrinted)
           if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
               return jsonString as String
           }
           
       } catch let error as NSError {
           //print("Array convertIntoJSON - \(error.description)")
       }
       return nil
   }
   static func += <K, V> (left: inout [K:V], right: [K:V]) {
       for (k, v) in right {
           left[k] = v
       }
   }
}
