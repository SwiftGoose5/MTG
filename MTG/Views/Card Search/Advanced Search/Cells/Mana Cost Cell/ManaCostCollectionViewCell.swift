//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class ManaCostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ManaCostCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ManaCostCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
