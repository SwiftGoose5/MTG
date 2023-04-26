//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class SmallCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "SmallCardCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SmallCardCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFit
    }
    
    func configure(with imageURL: String?) {
        Task {
            guard let imageURL = imageURL else { return }
            imageView.image = await ScryfallInteractor.getCardImage(from: imageURL)
            imageView.sizeToFit()
        }
    }
}
