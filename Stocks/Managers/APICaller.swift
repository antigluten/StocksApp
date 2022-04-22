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
        static let apiKey = ""
        static let sandboxApiKey = ""
        static let baseUrl = ""
    }
    
    // MARK: PUBLIC
    
    
    // MARK: PRIVATE
    
    private enum Endpoints: String {
        case search
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }
    
    
    private func url(for endpoint: Endpoints, queryParams: [String: String] = [:]) -> URL? {
        
        return nil
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
}

