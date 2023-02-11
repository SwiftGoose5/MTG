//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

protocol AdvancedCardSearchCollectionViewCellDelegate {
    func collectionViewCellCloseButtonPressed(from index: Int)
}

class AdvancedCardSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var searchFilterLabel: UILabel!
    @IBOutlet weak var searchTermLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel: AdvancedCardSearchCollectionViewModel!
    var delegate: AdvancedCardSearchCollectionViewCellDelegate!
    
    static let identifier = "AdvancedCardSearchCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AdvancedCardSearchCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 8
        searchFilterLabel.text = viewModel.searchFilter
        searchTermLabel.text = viewModel.searchTerm
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate.collectionViewCellCloseButtonPressed(from: viewModel.tag)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.width = ceil(size.width)
        frame.size.height = 22
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
}
