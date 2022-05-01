//
//  SearchResponse.swift
//  Stocks
//
//  Created by Vladimir Gusev on 23.04.2022.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
