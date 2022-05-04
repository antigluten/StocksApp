//
//  PersistanceManager.swift
//  Stocks
//
//  Created by Vladimir Gusev on 22.04.2022.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    struct Constants {
        static let onBoardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
    }
    
    private init() {}
    
    // MARK: - Public
    
    var watchList: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onBoardedKey)
            setupDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    func addToWatchList(symbol: String, name: String) {
        var newList = watchList
        newList.append(symbol)
        
        userDefaults.set(name, forKey: symbol)
        userDefaults.set(newList, forKey: Constants.watchListKey)
        
        NotificationCenter.default.post(name: .didAddToWatchlist, object: nil)
    }
    
    func removeFromWatchlist(symbol: String) {
        var newList = [String]()
        userDefaults.set(nil, forKey: symbol)
        print("Deleting \(symbol)")
        for item in watchList where item != symbol {
            print("\(item)")
            newList.append(item)
        }
        userDefaults.set(newList, forKey: Constants.watchListKey)
//        print(UserDefaults.standard.dictionaryRepresentation())
//        print(UserDefaults.standard.dictionary(forKey: Constants.watchListKey))
    }
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onBoardedKey)
    }
    
    private func setupDefaults() {
        let map: [String: String] = [
            "AAPL": "Apple Inc.",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com Inc.",
            "WORK": "Slack Technologies",
            "FB": "Facebook Inc.",
            "NVDA": "Nvidia Inc.",
            "NKE": "Nike",
            "PINS": "Pinterest Inc."
        ]
        
        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constants.watchListKey)
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
