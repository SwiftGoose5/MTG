//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

struct ColorCollectionViewCellViewModel {
    let image: UIImage
}

class ColorSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var colorViewModel: ColorCollectionViewCellViewModel!
    
    static let identifier = "ColorSearchCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ColorSearchCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func configure(with colorViewModel: ColorCollectionViewCellViewModel) {
        self.colorViewModel = colorViewModel
        imageView.image = colorViewModel.image
    }

}
