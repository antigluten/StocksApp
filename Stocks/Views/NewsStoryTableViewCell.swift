//
//  NewsStoryTableViewCell.swift
//  Stocks
//
//  Created by Vladimir Gusev on 02.05.2022.
//

import UIKit
import SDWebImage

class NewsStoryTableViewCell: UITableViewCell {
    static let identifier = "NewsStoryTableViewCell"
    static let preferredHeight: CGFloat = 140
    
    public struct ViewModel {
        let source: String
        let headline: String
        let date: String
        let imageUrl: URL?
        
        init(model: NewsStory) {
            self.source = model.source
            self.headline = model.headline
            self.date = .string(from: model.datetime)
            self.imageUrl = URL(string: model.image)
        }
    }
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22 , weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = nil
        backgroundColor = nil
        
        addSubviews(sourceLabel, headlineLabel, storyImageView, dateLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 6
        storyImageView.frame = CGRect(x: contentView.width - imageSize - 10, y: 3, width: imageSize, height: imageSize)
        
        // Layout labels
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imageSize - 15
        dateLabel.frame = CGRect(x: separatorInset.left, y: contentView.height - 40, width: availableWidth, height: 40)
        
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(x: separatorInset.left, y: 4, width: availableWidth, height: sourceLabel.height)
        
        let headlinePadding = contentView.height - sourceLabel.bottom - dateLabel.height - 10
        headlineLabel.frame = CGRect(x: separatorInset.left, y: sourceLabel.bottom + 5, width: availableWidth, height: headlinePadding)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    public func configure(with viewModel: ViewModel) {
        sourceLabel.text = viewModel.source
        headlineLabel.text = viewModel.headline
        dateLabel.text = viewModel.date
        
        storyImageView.sd_setImage(with: viewModel.imageUrl)
        // Manually downloaded image
        //storyImageView.setImage(with: viewModel.imageUrl)
    }
}
