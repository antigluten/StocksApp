//
//  ViewController.swift
//  Stocks
//
//  Created by Vladimir Gusev on 22.04.2022.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {
    
    static var maxChangeWidth: CGFloat = 0
    
    private var searchTimer: Timer?
    
    // Model
    private var watchlistMap: [String: [CandleStick]] = [:]
    
    // ViewModel
    private var viewModels = [WatchListTableViewCell.ViewModel]()
    
//    private var floatingPanel: FloatingPanelController?
    
    private let tableView: UITableView = {
        let table = UITableView()
        // Register cell - WatchListTableViewCell
        table.register(WatchListTableViewCell.self, forCellReuseIdentifier: WatchListTableViewCell.identifier)
        return table
    }()
    
    private var observer: NSObjectProtocol?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setup() {
        setupSearchConroller()
        setupTableView()
        fetchWatchlistData()
        setupFloatingPanel()
        setupTitleView()
        setupObserver()
    }
    
    // MARK: Private
    
    private func setupSearchConroller() {
        let resultVC = SearchResultsViewController()
        // MARK: Delegating
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    private func setupTitleView() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.height, height: navigationController?.navigationBar.height ?? 100))
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        
        titleView.addSubview(label)
        
        navigationItem.titleView = titleView
    }
    
    private func setupFloatingPanel() {
        let vc = NewsViewController(type: .topStories)
        
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.tableView)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupObserver() {
        observer = NotificationCenter.default.addObserver(forName: .didAddToWatchlist, object: nil, queue: .main) { [weak self] _ in
            self?.viewModels.removeAll()
            self?.fetchWatchlistData()
        }
    }
    
    private func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchList
        
        let group = DispatchGroup()

        for symbol in symbols where watchlistMap[symbol] == nil {
            group.enter()
            
            // fetch market data
            // MARK: should handle error or status messages, some market data can be nil
            
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchlistMap[symbol] = candleSticks
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
//        tableView.reloadData()
        group.notify(queue: .main) { [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
    }
    
    private func createViewModels() {
        var viewModels = [WatchListTableViewCell.ViewModel]()
        
        for (symbol, candleSticks) in watchlistMap {
            let changePercentage = getChangePercentage(symbol: symbol, data: candleSticks)
            viewModels.append(
                .init(
                    symbol: symbol,
                    companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                    price: getLatestClosingPrice(from: candleSticks),
                    changeColor: changePercentage < 0 ? .systemRed : .systemGreen,
                    changePercentage: .percentage(from: changePercentage),
                    chartViewModel: .init(
                        data: candleSticks.reversed().map { $0.close },
                        showLegend: true,
                        showAxis: true
                    )
                )
            )
        }
        
        self.viewModels = viewModels
    }
    
    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else {
            return ""
        }
        
        return .formatterNumber(number: closingPrice)
    }
    
    private func getChangePercentage(symbol: String, data: [CandleStick]) -> Double {
        if data.isEmpty {
            return 0
        }
        let latestDate = data[0].date
        
//        let day: TimeInterval = 3600 * 24
//        let period: TimeInterval = day * 4
//        let priorDate = Date().addingTimeInterval(-(period))
        
        guard let latestClose = data.first?.close,
                let priorClose = data.first(where: {
                    !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
                })?.close else {
            return 0
        }
        
        let diff = 1 - (priorClose / latestClose)
        
//        print("\(symbol) \(latestDate) Current: \(latestClose) | Prior: \(priorClose) | Diff: \(diff)%")
        
        return diff
    }
}

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, let resultsVC = searchController.searchResultsController as? SearchResultsViewController, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        // Reset the timer
        searchTimer?.invalidate()
        
        // Kick off new timer
        // Optimize searches after user stopped typing
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            // Call API to search
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        resultsVC.update(with: response.result)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        resultsVC.update(with: [])
                    }
                    print(error)
                }
            }
        })
        
//        print(query)
        // Update results control
        
    }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
        // Present Stock details for given selection
//        print("Did select \(searchResult.displaySymbol)")
        
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        let vc = StockDetailsViewController(
            symbol: searchResult.symbol,
            companyName: searchResult.description
        )
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVC, animated: true)
    }
}

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WatchListTableViewCell.identifier,
            for: indexPath
        ) as? WatchListTableViewCell else {
            fatalError()
        }
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchListTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Open details for selection
        let viewModel = viewModels[indexPath.row]
        let candleStickData = watchlistMap[viewModel.symbol] ?? []
        let vc = StockDetailsViewController(symbol: viewModel.symbol, companyName: viewModel.companyName, candleStickData: candleStickData)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // Update persistence
            PersistenceManager.shared.removeFromWatchlist(symbol: viewModels[indexPath.row].symbol)
            // Update viewModels
            viewModels.remove(at: indexPath.row)
            // Delete row
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

extension WatchListViewController: WatchListTableViewCellDelegate {
    func didUpdateMaxWidth() {
        // Optimize: Refresh only rows prior to the current row that changes the max width
        tableView.reloadData()
    }
}
