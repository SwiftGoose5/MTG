//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardPower: UILabel!
    @IBOutlet weak var cardSet: UILabel!
    
    var cardManaSymbols: [UIImage]!
    var cardManaCost: [String] = []
    
    static let identifier = "ListTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ListTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ManaCostCollectionViewCell.nib(), forCellWithReuseIdentifier: ManaCostCollectionViewCell.identifier)
        
        let layout = RightAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        collectionView.collectionViewLayout = layout
    }
    
    func configure(with card: Card) {
        cardName.text = card.name
        cardType.text = card.typeLine
        cardSet.text = card.cardSet?.uppercased()
        cardPower.text = card.power == nil ? (" ") : (String((card.power ?? "") + "/" + (card.toughness ?? "")))

        if card.manaCost != nil {
            cardManaCost = ScryfallInteractor.parseManaCostForSymbols(from: card)
            
            cardManaSymbols = [UIImage].init(repeating: UIImage(), count: cardManaCost.count)
            
            Task {
                cardManaSymbols = await ScryfallInteractor.getCardManaSymbols(from: card)
                collectionView.reloadData()
            }
        }
    }
}

extension ListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cardManaCost.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManaCostCollectionViewCell.identifier, for: indexPath) as! ManaCostCollectionViewCell
        
        cell.configure(with: cardManaSymbols[indexPath.row])
        
        return cell
    }
}
