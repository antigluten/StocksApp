//
//  AppDelegate.swift
//  Stocks
//
//  Created by Vladimir Gusev on 22.04.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        debug()
        
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    func debug() {
//        APICaller.shared.search(query: "Apple") { result in
//            switch result {
//            case .success(let response):
//                print(response.result)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        APICaller.shared.news(for: .company(symbol: "AAPL")) { result in
//            switch result {
//            case .success(let news):
//                print(news.count)
//            case .failure(let error):
//                print(error)
//            }
//        }
        APICaller.shared.marketData(for: "AAPL", numberOfDays: 1) { result in
            switch result {
            case .success(let response):
                print(response.candleSticks.count)
                let candleSticks = response.candleSticks
            case .failure(let error):
                print(error)
            }
        }
    }


}

