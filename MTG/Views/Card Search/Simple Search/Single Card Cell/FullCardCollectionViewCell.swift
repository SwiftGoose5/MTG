//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class FullCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "FullCardCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FullCardCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with imageURL: String?) {
//        let maxSize = self.contentView.bounds.size
        
        Task {
            guard let imageURL = imageURL else { return }
            imageView.image = await ScryfallInteractor.getCardImage(from: imageURL)
//            let scaledImage = image.scaleToFit(size: maxSize)
//            imageView.image = scaledImage
        }
    }
}

extension UIImage {
    func scaleToFit(size: CGSize) -> UIImage? {
        let originalSize = self.size
        
        let widthRatio = size.width / originalSize.width
        let heightRatio = size.height / originalSize.height
        let scaleRatio = min(widthRatio, heightRatio)
        
        let scaledSize = CGSize(width: originalSize.width * scaleRatio, height: originalSize.height * scaleRatio)
        
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
