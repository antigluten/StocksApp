//
//  MarketDataResponse.swift
//  Stocks
//
//  Created by Vladimir Gusev on 03.05.2022.
//

import Foundation

struct MarketDataResponse: Codable {
    let open: [Double]
    let close: [Double]
    let high: [Double]
    let low: [Double]
    let status: String
    let timeStamps: [TimeInterval]
    
    enum CodingKeys: String, CodingKey {
        case open = "o"
        case close = "c"
        case high = "h"
        case low = "l"
        case status = "s"
        case timeStamps = "t"
    }
    
    var candleSticks: [CandleStick] {
        var result = [CandleStick]()
        
        for index in 0..<open.count {
            result.append(.init(date: Date(timeIntervalSince1970: timeStamps[index]), open: open[index], close: close[index], high: high[index], low: low[index]))
        }
        
        let sorted = result.sorted(by: { $0.date > $1.date })
            
        return sorted
    }
}

struct CandleStick {
    let date: Date
    let open: Double
    let close: Double
    let high: Double
    let low: Double
}
