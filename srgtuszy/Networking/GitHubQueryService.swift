//
//  GitHubQueryService.swift
//  srgtuszy
//
//  Created by admin on 9/9/21.
//

import Foundation

final class GitHubQueryService {
    //
    // MARK: - Constants
    //
    private let defaultSession = URLSession(configuration: .default)
    private let scheme = "https"
    private let host = "api.github.com"
    private let searchRepoPath = "/search/repositories"
    
    //
    // MARK: - Properties
    //
    private var dataTask: URLSessionDataTask?

    
    //
    // MARK: - Type Alias
    //
    typealias SearchResultCompletion = (Result<Repository, NetworkError>) -> Void
    
    //
    // MARK: - Public
    //
    
    public func getSearchResults(search q: String,
                          order: String = "asc",
                          sort: String = "stars",
                          completion: @escaping SearchResultCompletion) {
        dataTask?.cancel()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = searchRepoPath
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "sort", value: sort),
            URLQueryItem(name: "order", value: order)
        ]
        
        guard let url = urlComponents.url else { return }
        dataTask = defaultSession.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  let repositories = self?.parseSearchResults(data),
                  response.statusCode == 200 else {
                debugPrint(error)
                return completion(.failure(.invalidData))
            }
                        
            completion(.success(repositories))
        }
        
        dataTask?.resume()
    }
    
    //
    // MARK: - Private
    //
    private func parseSearchResults(_ data: Data) -> Repository? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let repositories = try decoder.decode(Repository.self, from: data)
            return repositories
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
}

