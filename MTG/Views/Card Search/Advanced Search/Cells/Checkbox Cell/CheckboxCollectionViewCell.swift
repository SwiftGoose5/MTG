//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

protocol CheckboxDelegate {
    func checkboxTapped(title: String, state: Bool)
}

class CheckboxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkboxButton: UIButton!
    
    static let identifier = "CheckboxCollectionViewCell"
    
    var checkboxDelegate: CheckboxDelegate!
    
    static func nib() -> UINib {
        return UINib(nibName: "CheckboxCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with text: String) {
        checkboxButton.setTitle(text, for: .normal)
        
        checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "square.fill"), for: .selected)
    }

    @IBAction func checkboxButtonTapped(_ sender: Any) {
        checkboxButton.isSelected.toggle()
        checkboxDelegate.checkboxTapped(title: checkboxButton.titleLabel!.text!, state: checkboxButton.isSelected)
    }
}

