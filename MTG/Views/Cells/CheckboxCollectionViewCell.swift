//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit


class CheckboxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var checkboxLabel: UILabel!
    
    static let identifier = "CheckboxCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CheckboxCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with text: String) {
        checkboxLabel.text = text
        print("ghost")
        
        checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "square.fill"), for: .selected)
    }

}

