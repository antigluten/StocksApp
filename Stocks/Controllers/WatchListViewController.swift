//
//  ViewController.swift
//  Stocks
//
//  Created by Vladimir Gusev on 22.04.2022.
//

import UIKit

class WatchListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setupSearchConroller()
    }
    
    private func setupSearchConroller() {
        let resultVC = SearchResultsViewController()
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }


}

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, let resultsVC = searchController.searchResultsController as? SearchResultsViewController, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        // Optimize searches after user stopped typing
        
        // Call API to search
        
        print(query)
        
        // Update results controll
    }
    
    
}

