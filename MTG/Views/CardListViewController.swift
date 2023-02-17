//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit
import SVGKit

class CardListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cardViewModel: OneCardSearchViewModel!
//    var cards: [Card] = []
//    var cardsManaCost: [String?] = []
//    var cardsManaSymbols: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CardTableViewCell.nib(), forCellReuseIdentifier: CardTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cards.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath) as! CardTableViewCell

        cell.selectionStyle = .none
//        cell.cardName.text = cards[indexPath.row].name
//        cell.cardType.text = cards[indexPath.row].typeLine
//        cell.cardSet.text = cards[indexPath.row].setName
//        cell.cardRarity.text = cards[indexPath.row].rarity?.uppercased()
//        cell.cardManaCost = cards[indexPath.row].manaCost
//        cell.cardManaSymbols = cardsManaSymbols
        
        cell.cardName.text = cardViewModel.card?.name
        cell.cardType.text = cardViewModel.card?.typeLine
        cell.cardSet.text = cardViewModel.card?.setName
        cell.cardRarity.text = cardViewModel.card?.rarity
        cell.cardManaCost = cardViewModel.cardManaCost
        cell.cardManaSymbols = cardViewModel.cardManaCostSymbols
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let card = cards[indexPath.row]
        let card = cardViewModel.card
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "CardDetailViewController") as! CardDetailViewController
        vc.card = card
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
