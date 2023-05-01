//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class CardDetailViewController: UIViewController {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardPower: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardRarity: UILabel!
    @IBOutlet weak var cardText: UILabel!
    @IBOutlet weak var cardArtist: UILabel!
    @IBOutlet weak var cardSet: UILabel!
    @IBOutlet weak var cardFlavor: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var cardCostCollectionView: UICollectionView!
    
    var card: Card!
    var cardManaSymbols: [UIImage]!
    var cardManaCost: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardCostCollectionView.dataSource = self
        cardCostCollectionView.delegate = self
        cardCostCollectionView.register(ManaCostCollectionViewCell.nib(), forCellWithReuseIdentifier: ManaCostCollectionViewCell.identifier)
    }
    
    func configure(with card: Card) {
        self.card = card
        cardName.text = card.name
        cardPower.text = card.power == nil ? (" ") : (String((card.power ?? "") + "/" + (card.toughness ?? "")))
        cardType.text = card.typeLine
        cardRarity.text = card.rarity?.uppercased()
        cardArtist.text = card.artist == nil ? (" ") : (String("Illustrated by " + (card.artist ?? "")))
        cardText.text = card.oracleText?.replacingOccurrences(of: "\n", with: "\n\n")
        cardSet.text = card.setName
        cardFlavor.text = card.flavorText
        
        cardFlavor.isHidden = true
        card.flavorText == nil ? (segmentedControl.isHidden = true) : (segmentedControl.isHidden = false)
        
        cardType.textColor = .systemBlue
        cardSet.textColor = .systemBlue
        
        if card.manaCost != nil {
            cardManaCost = ScryfallInteractor.parseManaCostForSymbols(from: card)
            
            cardManaSymbols = [UIImage].init(repeating: UIImage(), count: cardManaCost.count)
            
            Task {
                cardManaSymbols = await ScryfallInteractor.getCardManaSymbols(from: card)
                cardCostCollectionView.reloadData()
            }
        }

        guard let imageURL = card.imageUris?.normal else { return }
        
        Task {
            cardImageView.image = await ScryfallInteractor.getCardImage(from: imageURL)
        }
    }
    
    
    @IBAction func segmentedControlTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cardFlavor.isHidden = false
        default:
            cardFlavor.isHidden = true
        }
    }
}

extension CardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
