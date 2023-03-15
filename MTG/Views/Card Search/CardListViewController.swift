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
    
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sortStyleButton: UIButton!
    @IBOutlet weak var viewStyleButton: UIButton!
    
    var cardViewModel: OneCardSearchViewModel!
//    var cards: [Card] = []
//    var cardsManaCost: [String?] = []
//    var cardsManaSymbols: [UIImage] = []
    var cardSearchViewModel: Cards!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CardTableViewCell.nib(), forCellReuseIdentifier: CardTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configure(with viewModel: Cards) {
        self.cardSearchViewModel = viewModel
        
        guard let totalCards = cardSearchViewModel.totalCards else { return }
        cardCountLabel.text = String("Displaying 10 out of \(totalCards) cards")
    }
    
    @IBAction func tableSortStyleTapped(_ sender: Any) {
        let pickerModel = PickerModel(terms: [.Name, .Color, .ManaValue, .Power, .Toughness])
        
        let vc = CardListPickerViewController()
        vc.configure(with: pickerModel, identifier: .SortStyle)
        vc.pickerDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func tableViewStyleTapped(_ sender: Any) {
        let pickerModel = PickerModel(terms: [.CardFull, .CardSmall, .TextList, .TextCard])
        
        let vc = CardListPickerViewController()
        vc.configure(with: pickerModel, identifier: .ViewStyle)
        vc.pickerDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
}

extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cards.count
//        return 1

        return cardSearchViewModel.totalCards ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath) as! CardTableViewCell

//        cell.cardName.text = cards[indexPath.row].name
//        cell.cardType.text = cards[indexPath.row].typeLine
//        cell.cardSet.text = cards[indexPath.row].setName
//        cell.cardRarity.text = cards[indexPath.row].rarity?.uppercased()
//        cell.cardManaCost = cards[indexPath.row].manaCost
//        cell.cardManaSymbols = cardsManaSymbols
        
//        cell.cardName.text = cardViewModel.card?.name
//        cell.cardType.text = cardViewModel.card?.typeLine
//        cell.cardSet.text = cardViewModel.card?.setName
//        cell.cardRarity.text = cardViewModel.card?.rarity
//        cell.cardManaCost = cardViewModel.cardManaCost
//        cell.cardManaSymbols = cardViewModel.cardManaCostSymbols
        
        cell.configure(with: cardSearchViewModel.data![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let card = cards[indexPath.row]
//        let card = cardViewModel.card
        let card = cardSearchViewModel.data![indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "CardDetailViewController") as! CardDetailViewController
        vc.card = card
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension CardListViewController: PickerDelegate {
    func pickerOptionSelected(option: PickerOptions, identifier: PickerIdentifier) {
        
        // TODO: - Imeplement sorting
        
        switch identifier {
        case .SortStyle:
            sortStyleButton.setTitle(option.rawValue, for: .normal)
            
        case .ViewStyle:
            viewStyleButton.setTitle(option.rawValue, for: .normal)
        }
        
    }
}
