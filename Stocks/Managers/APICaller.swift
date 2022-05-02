//
//  APICaller.swift
//  Stocks
//
//  Created by Vladimir Gusev on 22.04.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    private struct Constants {
        static let apiKey = "c9htbeqad3idasnd9k2g"
        static let sandboxApiKey = "sandbox_c9htbeqad3idasnd9k30"
        static let baseUrl = "https://finnhub.io/api/v1/"
        
        static let day: TimeInterval = 3600 * 24
        static let week: TimeInterval = day * 7
    }
    
    // MARK: - PUBLIC
    
    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let url = url(for: .search, queryParams: ["q":safeQuery]) else {
            return
        }
        
        request(url: url, expecting: SearchResponse.self, completion: completion)
    }
    
    public func request<T:Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            // invalid url
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func news(for type: NewsViewController.`Type`, comletionHandler: @escaping (Result<[NewsStory], Error>) -> Void ) {
        
        switch type {
        case .topStories:
            request(url: url(for: .topStories, queryParams: ["category": "general"]), expecting: [NewsStory].self, completion: comletionHandler)
        case .company(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.week))
            request(url: url(
                for: .companyNews,
                queryParams: ["symbol": symbol, "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack), "to": DateFormatter.newsDateFormatter.string(from: today)]),
                    expecting: [NewsStory].self,
                    completion: comletionHandler)
        }
        
        
    }
    
    // MARK: - PRIVATE
    
    private enum Endpoints: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }
    
    
    private func url(for endpoint: Endpoints, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        // Add any parameters to URL
        for (key, value) in queryParams {
            queryItems.append(.init(name: key, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // Convert query iterms to suffix strings
        
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        urlString += "?" + queryString
        
        print("\n\(urlString)\n")
        
        return URL(string: urlString)
    }
    
    
}

