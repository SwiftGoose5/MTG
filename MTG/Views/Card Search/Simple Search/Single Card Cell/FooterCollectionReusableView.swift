//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

protocol FooterCollectionDelegate {
    func showMoreResultsTapped()
}

class FooterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var showMoreResultsButton: UIButton!
    
    static let identifier = "FooterCollectionReusableView"
    
    var footerDelegate: FooterCollectionDelegate!
    var cardsShowing: Int = 0
    var totalCards: Int = 0
    
    static func nib() -> UINib {
        return UINib(nibName: "FooterCollectionReusableView", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with cardsShowing: Int, and totalCards: Int) {
        self.cardsShowing = cardsShowing
        self.totalCards = totalCards
    }
    
    @IBAction func showMoreResultsButtonTapped(_ sender: Any) {
        cardsShowing += 10
        
        if cardsShowing >= totalCards {
            cardsShowing = totalCards
            showMoreResultsButton.isHidden = true
        }
        footerDelegate.showMoreResultsTapped()
    }
}
