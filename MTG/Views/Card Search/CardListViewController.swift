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
    
    var footerButton: UIButton = UIButton()
    
    var cardViewModel: OneCardSearchViewModel!
//    var cards: [Card] = []
//    var cardsManaCost: [String?] = []
//    var cardsManaSymbols: [UIImage] = []
    var cardSearchViewModel: Cards?
    var cards: [Card] = []
    
    var cardsShowing: Int = 0
    var totalCards: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CardTableViewCell.nib(), forCellReuseIdentifier: CardTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configure(with viewModel: Cards) {
        cardSearchViewModel = viewModel
        
        cards = cardSearchViewModel?.data ?? []
        totalCards = cards.count
        
        if totalCards > 10 {
            cardsShowing = 10
        } else {
            cardsShowing = totalCards
        }
        
        addTableFooter()
        cardCountLabel.text = String("Displaying \(cardsShowing) out of \(totalCards) cards")
    }
    
    @IBAction func tableSortStyleTapped(_ sender: Any) {
        let pickerModel = PickerModel(options: [.Name, .Name, .Color, .Color, .ManaValue, .ManaValue, .Power, .Power, .Toughness, .Toughness],
                                      icons: [.Ascending, .Descending, .Ascending, .Descending, .Ascending, .Descending, .Ascending, .Descending, .Ascending, .Descending])
        
        let vc = CardListPickerViewController()
        vc.configure(with: pickerModel, identifier: .SortStyle)
        vc.pickerDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func tableViewStyleTapped(_ sender: Any) {
        let pickerModel = PickerModel(options: [.CardsFull, .CardsSmall, .TextList, .TextCard],
                                      icons: [.CardsFull, .CardsSmall, .TextList, .TextCard])
        
        let vc = CardListPickerViewController()
        vc.configure(with: pickerModel, identifier: .ViewStyle)
        vc.pickerDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    private func addTableFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        footerButton = UIButton(frame: CGRect(x: tableView.frame.width / 4, y: 30, width: tableView.frame.width / 2, height: 40), primaryAction: UIAction(handler: loadMoreResultsTapped))
        footerButton.setTitle("Show more results", for: .normal)
        footerButton.backgroundColor = .systemBlue
        footerButton.layer.cornerRadius = 8
        footerView.addSubview(footerButton)
        
        footerButton.isHidden = true
        
        if totalCards > 10 {
            footerButton.isHidden = false
        }
        
        tableView.tableFooterView = footerView
    }
    
    private func loadMoreResultsTapped(action: UIAction) {
        cardsShowing += 10
        
        if cardsShowing >= totalCards {
            cardsShowing = totalCards
            footerButton.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.cardCountLabel.text = String("Displaying \(self.cardsShowing) out of \(self.totalCards) cards")
            self.tableView.reloadData()
        }
    }
    
}

extension CardListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cards.count
//        return 1
        
        return cardsShowing > totalCards ? totalCards : cardsShowing
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
        
        cell.configure(with: cards[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let card = cards[indexPath.row]
//        let card = cardViewModel.card
        let card = cards[indexPath.row]
        
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
    func pickerOptionSelected(option: PickerOptions, icon: PickerIcons, identifier: PickerIdentifier) {
        
        // TODO: - Imeplement sorting
        
        switch identifier {
        case .SortStyle:
            sortStyleButton.setTitle(option.rawValue, for: .normal)
            sortStyleButton.setImage(UIImage(systemName: icon.rawValue), for: .normal)
            
            switch option {
            case .Name:
                switch icon {
                case .Ascending:
                    cards.sort(by: { $0.name ?? "" < $1.name ?? "" })
                case .Descending:
                    cards.sort(by: { $0.name ?? "" > $1.name ?? "" })
                case .CardsSmall, .CardsFull, .TextCard, .TextList:
                    break
                }
            case .ManaValue:
                switch icon {
                case .Ascending:
                    cards.sort(by: { $0.cmc ?? 0 < $1.cmc ?? 0 })
                case .Descending:
                    cards.sort(by: { $0.cmc ?? 0 > $1.cmc ?? 0 })
                case .CardsSmall, .CardsFull, .TextCard, .TextList:
                    break
                }
            case .Color:
                switch icon {
                case .Ascending:
                    cards.sort(by: { firstCard, secondCard in
                        guard let firstColor = firstCard.colorIdentity, let secondColor = secondCard.colorIdentity else { return true }
                        
                        if firstColor.isEmpty && !secondColor.isEmpty { return false }
                        if !firstColor.isEmpty && secondColor.isEmpty { return true }
                        if firstColor.isEmpty { return false }
                        if secondColor.isEmpty { return true }
                        
                        if firstColor.count == 1 && secondColor.count == 1 {
                            return firstColor.first! < secondColor.first!
                        }
                        else if firstColor.count == 1 && secondColor.count > 1 {
                            return true
                        }
                        else if firstColor.count > 1 && secondColor.count == 1 {
                            return false
                        }
                        else if firstColor.count > 1 && secondColor.count > 1 {
                            return firstColor.first! < secondColor.first!
                        }
                        else {
                            return false
                        }
                    })
                case .Descending:
                    cards.sort(by: { firstCard, secondCard in
                        guard let firstColor = firstCard.colorIdentity, let secondColor = secondCard.colorIdentity else { return true }
                        
                        if firstColor.isEmpty && !secondColor.isEmpty { return true }
                        if !firstColor.isEmpty && secondColor.isEmpty { return false }
                        if firstColor.isEmpty { return true }
                        if secondColor.isEmpty { return false }
                        
                        if firstColor.count == 1 && secondColor.count == 1 {
                            return firstColor.first! > secondColor.first!
                        }
                        else if firstColor.count == 1 && secondColor.count > 1 {
                            return false
                        }
                        else if firstColor.count > 1 && secondColor.count == 1 {
                            return true
                        }
                        else if firstColor.count > 1 && secondColor.count > 1 {
                            return firstColor.first! > secondColor.first!
                        }
                        else {
                            return true
                        }
                    })
                case .CardsSmall, .CardsFull, .TextCard, .TextList:
                    break
                }
            case .Power:
                switch icon {
                case .Ascending:
                    cards.sort(by: { $0.power ?? "" < $1.power ?? "" } )
                case .Descending:
                    cards.sort(by: { $0.power ?? "" > $1.power ?? "" })
                case .CardsSmall, .CardsFull, .TextCard, .TextList:
                    break
                }
            case .Toughness:
                switch icon {
                case .Ascending:
                    cards.sort(by: { $0.toughness ?? "" < $1.toughness ?? "" })
                case .Descending:
                    cards.sort(by: { $0.toughness ?? "" > $1.toughness ?? "" })
                case .CardsSmall, .CardsFull, .TextCard, .TextList:
                    break
                }
            case .CardsSmall, .CardsFull, .TextList, .TextCard, .Is, .Or, .Not:
                break
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        case .ViewStyle:
            viewStyleButton.setTitle(option.rawValue, for: .normal)
            viewStyleButton.setImage(UIImage(systemName: icon.rawValue), for: .normal)
        }
        
    }
}
