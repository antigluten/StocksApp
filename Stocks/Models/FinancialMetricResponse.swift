//
//  FinancialMetricResponse.swift
//  Stocks
//
//  Created by Vladimir Gusev on 10.05.2022.
//

import Foundation

struct FinancialMetricResponse: Codable {
    let metric: Metrics
}

struct Metrics: Codable {
    let tenDayAverageTradingVolume: Float
    let annualWeekHigh: Double
    let annualWeekLow: Double
    let annualLowDate: String
    let annualPriceReturnDaily: Float
    let beta: Float
    
    enum CodingKeys: String, CodingKey {
        case tenDayAverageTradingVolume = "10DayAverageTradingVolume"
        case annualWeekHigh = "52WeekHigh"
        case annualWeekLow = "52WeekLow"
        case annualLowDate = "52WeekLowDate"
        case annualPriceReturnDaily = "52WeekPriceReturnDaily"
        case beta
    }
}
