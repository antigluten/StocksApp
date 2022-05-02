//
//  TopStoriesViewControllers.swift
//  Stocks
//
//  Created by Vladimir Gusev on 22.04.2022.
//

import UIKit

class NewsViewController: UIViewController {
    
    enum `Type` {
        case topStories
        case company(symbol: String)
        
        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"
            case .company(let symbol):
                return symbol.uppercased()
            }
        }
    }
    
    // MARK: - Properties
    
//    private var stories = [NewsStory]()
    private var stories: [NewsStory] = [
        .init(category: "tech",
              datetime: 100,
              headline: "the world sucks because there are no chips available to buy here",
              id: 1,
              image: "https://s.yimg.com/uu/api/res/1.2/S8SCotpO9m2XQyQUIGU5dw--~B/aD02MzA7dz0xMjAwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/marketwatch.com/96d076434b2a015a3010bd2787b8c856",
              related: "",
              source: "mysite.com",
              summary: "the world sucks because there are no chips available to buy here",
              url: ""),
        .init(category: "fuck-here",
              datetime: 100,
              headline: "the world sucks shall know pain",
              id: 1,
              image: "https://s.yimg.com/ny/api/res/1.2/uOuU.eGVGV._0O0x817tgw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02MDA-/https://s.yimg.com/uu/api/res/1.2/M4_qCwcZywsD5ZfkmRkaXw--~B/aD02NDA7dz0xMjgwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/Barrons.com/ffd44c282c3e899030610a0c6aee1cb7",
              related: "",
              source: "fuckyou.com",
              summary: "",
              url: ""),
        .init(category: "tech",
              datetime: 100,
              headline: "the world sucks because there are no chips available to buy here",
              id: 1,
              image: "",
              related: "",
              source: "mysite.com",
              summary: "the world sucks because there are no chips available to buy here",
              url: ""),
        .init(category: "fuck-here",
              datetime: 100,
              headline: "the world sucks shall know pain",
              id: 1,
              image: "",
              related: "",
              source: "fuckyou.com",
              summary: "",
              url: ""),
        .init(category: "tech",
              datetime: 100,
              headline: "the world sucks because there are no chips available to buy here",
              id: 1,
              image: "",
              related: "",
              source: "mysite.com",
              summary: "the world sucks because there are no chips available to buy here",
              url: ""),
        .init(category: "fuck-here",
              datetime: 100,
              headline: "the world sucks shall know pain",
              id: 1,
              image: "",
              related: "",
              source: "fuckyou.com",
              summary: "",
              url: ""),
        .init(category: "tech",
              datetime: 100,
              headline: "the world sucks because there are no chips available to buy here",
              id: 1,
              image: "",
              related: "",
              source: "mysite.com",
              summary: "the world sucks because there are no chips available to buy here",
              url: ""),
        .init(category: "fuck-here",
              datetime: 100,
              headline: "the world sucks shall know pain",
              id: 1,
              image: "",
              related: "",
              source: "fuckyou.com",
              summary: "",
              url: "")
    ]
    
    private let type: Type
    
    let tableView: UITableView = {
        let table = UITableView()
        // Register a cell
        table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        // Register a header
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
//        table.backgroundColor = .yellow
        return table
    }()
    
    // MARK: - Initializing
    
    init(type: Type) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private
    
    private func setup() {
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Clear separator lines
        tableView.separatorColor = .clear
    }
    
    private func fetchNews() {
        
    }
    
    private func open(url: URL) {
        
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Open news story
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            return nil
        }
        
        header.configure(with: .init(title: self.type.title, shouldShowAddButton: false))
        
        return header
    }
}
