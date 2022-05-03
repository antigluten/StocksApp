//
//  WatchListTableViewCell.swift
//  Stocks
//
//  Created by Vladimir Gusev on 03.05.2022.
//

import UIKit

class WatchListTableViewCell: UITableViewCell {
    static let identifier = "WatchListTableViewCell"
    
    static let preferredHeight: CGFloat = 70
    
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String // formatted
        let changeColor: UIColor
        let changePercentage: String // formatted
        // chart viewModel
        // let chartViewModel: StockChartView.ViewModel
    }
    
    // Symbol label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    // Company label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    // Price label
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    // Change label
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let miniChartView = StockChartView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews(
            symbolLabel,
            nameLabel,
            priceLabel,
            changeLabel,
            miniChartView
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
        // Configure the chart
    }
}
