//
//  PersistanceManager.swift
//  Stocks
//
//  Created by Vladimir Gusev on 22.04.2022.
//

import Foundation

final class PersistanceManager {
    static let shared = PersistanceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        
    }
    
    private init() {}
    
    // MARK: - Public
    
    var watchList = [String]()
    
    func addToWatchList() {
        
    }
    
    func removeFromWatchlist() {
        
    }
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        return false
    }
}
