//
//  MovieAPiService.swift
//  Codigo TMDB
//
//  Created by Ibrahim Baisa on 16/03/24.
//

import Foundation
import Alamofire

class MovieAPIService {
    static let shared = MovieAPIService()
    
    private let baseURL = "https://api.themoviedb.org/3/movie"
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhZTcyNjc0NjdhMGQ2ZjAwZWM2NDhiN2RkM2U5M2IzMiIsInN1YiI6IjVmMWI4ZDRmMWIxZjNjMDAzNTZlODE2MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.mywOlIQenONRAJ6LAeK9UBMMTZGM4O5X38OL_EPSiHY"
    
    private init() {}
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let url = "\(baseURL)/\(endpoint)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(.success(movieResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
