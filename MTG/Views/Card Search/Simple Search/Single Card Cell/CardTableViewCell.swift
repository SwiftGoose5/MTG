//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class CardTableViewCell: UITableViewCell {
    
    static let identifier = "CardTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CardTableViewCell", bundle: nil)
    }

    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardCostCollectionView: UICollectionView!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardSet: UILabel!
    @IBOutlet weak var cardRarity: UILabel!
    
    var cardManaSymbols: [UIImage]!
    var cardManaCost: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        cardCostCollectionView.dataSource = self
        cardCostCollectionView.delegate = self
        cardCostCollectionView.register(ManaCostCollectionViewCell.nib(), forCellWithReuseIdentifier: ManaCostCollectionViewCell.identifier)
    }
    
    func configure(with card: Card) {
        cardName.text = card.name
        cardType.text = card.typeLine
        cardSet.text = card.setName
        cardRarity.text = card.rarity?.capitalized

        if card.manaCost != nil {
            cardManaCost = ScryfallInteractor.parseManaCostForSymbols(from: card)
            
            cardManaSymbols = [UIImage].init(repeating: UIImage(), count: cardManaCost.count)
            
            Task {
                cardManaSymbols = await ScryfallInteractor.getCardManaSymbols(from: card)
                cardCostCollectionView.reloadData()
            }
        }
    }
}

extension CardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardManaCost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManaCostCollectionViewCell.identifier, for: indexPath) as! ManaCostCollectionViewCell
        
        cell.configure(with: cardManaSymbols[indexPath.row])
        
        return cell
    }
    
}
