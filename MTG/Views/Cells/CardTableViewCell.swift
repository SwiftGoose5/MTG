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
    
    var cardManaSymbols: [UIImage?]!
    
    var cardManaCost: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardCostCollectionView.dataSource = self
        cardCostCollectionView.delegate = self
        cardCostCollectionView.register(ManaCostCollectionViewCell.nib(), forCellWithReuseIdentifier: ManaCostCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        cardCostCollectionView.reloadData()
    }
}

extension CardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cardManaCost = cardManaCost else { return 0 }
        return cardManaCost.parseManaSymbols().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManaCostCollectionViewCell.identifier, for: indexPath) as! ManaCostCollectionViewCell
        
        cell.configure(with: cardManaSymbols[indexPath.row]!)
        
        return cell
    }
    
}
