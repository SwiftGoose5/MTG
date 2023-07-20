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
        cardPower .text = card.power == nil ? (" ") : (String((card.power ?? "") + "/" + (card.toughness ?? "")))
        cardType.text = card.typeLine
        cardRarity.text = card.rarity?.uppercased()
        cardArtist.text = card.artist == nil ? (" ") : (String("Illustrated by " + (card.artist ?? "")))
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
            cardText.attributedText = await convertOracleTextToAttributed(card.oracleText?.replacingOccurrences(of: "\n", with: "\n\n") ?? "")
        }
    }
    
    func convertOracleTextToAttributed(_ flavorText: String) async -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: flavorText)
        
        let pattern = #"\{(\w)\}"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: flavorText, options: [], range: NSRange(location: 0, length: flavorText.utf16.count))
        
        for match in matches.reversed() {
            let fullRange = match.range(at: 0) // Full range of the match, including curly braces
            let capturedCharacterRange = match.range(at: 1) // Range of the captured character
            
            let capturedCharacter = (flavorText as NSString).substring(with: capturedCharacterRange)
            
            let symbol = await ScryfallInteractor.getOneCardSymbol(from: capturedCharacter)
            
            let textAttachment = NSTextAttachment()
            textAttachment.image = symbol
            
            // Adjust the image size and position within the text
            let font = UIFont.systemFont(ofSize: 18)
            let imageSize = CGSize(width: font.capHeight, height: font.capHeight)
            let imageOffsetY = -(font.capHeight - imageSize.height) / 2
            textAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageSize.width, height: imageSize.height)
            
            let imageString = NSAttributedString(attachment: textAttachment)
            
            // Replace the matched pattern with the image
            attributedString.replaceCharacters(in: fullRange, with: imageString)
        }
        
        return attributedString
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
