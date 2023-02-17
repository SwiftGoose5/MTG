//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class CardSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var cards: [Card?] = []
    
    var superTypesModel: AdvancedCardSearchCardTypeTableViewCellViewModel!
    var subTypesModel: AdvancedCardSearchCardTypeTableViewCellViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        superTypesModel = AdvancedCardSearchCardTypeTableViewCellViewModel(titleText: "Super Types", cellIdentifier: "ModalCell", terms: Types.allCases.map { $0.rawValue })
        subTypesModel = AdvancedCardSearchCardTypeTableViewCellViewModel(titleText: "", cellIdentifier: "", terms: [])
        
        navigationItem.title = "Cards"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 200
        
        tableView.register(AdvancedCardSearchTableViewCell.nib(), forCellReuseIdentifier: AdvancedCardSearchTableViewCell.identifier)
        tableView.register(AdvancedCardSearchCardTypeTableViewCell.nib(), forCellReuseIdentifier: AdvancedCardSearchCardTypeTableViewCell.identifier)
        tableView.register(AdvancedCardSearchColorTableViewCell.nib(), forCellReuseIdentifier: AdvancedCardSearchColorTableViewCell.identifier)
        
        configureSearchBar()
        showSimpleSearchView()
        
        fetchSubTypes()
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            showSimpleSearchView()
            
        default:
            showAdvancedSearchView()
        }
    }
    
    @IBAction func clearAllButtonPressed(_ sender: Any) {
        
    }
    
}

extension CardSearchViewController {
    func fetchSubTypes() {
        Task {
            var subTypes: [String] = []
            
            let creatureTypes = await ScryfallInteractor.getCreatureTypes()
            let planeswalkerTypes = await ScryfallInteractor.getPlaneswalkerTypes()
            let landTypes = await ScryfallInteractor.getLandTypes()
            let artifactTypes = await ScryfallInteractor.getArtifactTypes()
            let enchantmentTypes = await ScryfallInteractor.getEnchantmentTypes()
            let spellTypes = await ScryfallInteractor.getSpellTypes()
            
            subTypes.append(contentsOf: creatureTypes)
            subTypes.append(contentsOf: planeswalkerTypes)
            subTypes.append(contentsOf: landTypes)
            subTypes.append(contentsOf: artifactTypes)
            subTypes.append(contentsOf: enchantmentTypes)
            subTypes.append(contentsOf: spellTypes)
            
            subTypes.sort()
            
            subTypesModel = AdvancedCardSearchCardTypeTableViewCellViewModel(titleText: "Subtypes", cellIdentifier: "ModalCell", terms: subTypes)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension CardSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)

        Task {
            let card = await ScryfallInteractor.getOneCard(from: trimmed)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let card = card {
                let cardManaSymbols = await ScryfallInteractor.getCardManaSymbols(from: card)
                let cardViewModel = OneCardSearchViewModel(card: card, cardManaCost: card.manaCost, cardManaCostSymbols: cardManaSymbols)
                let vc = storyboard.instantiateViewController(withIdentifier: "CardListViewController") as! CardListViewController
                vc.cardViewModel = cardViewModel
                
                navigationController?.pushViewController(vc, animated: true)
                
            } else {
                
                let vc = storyboard.instantiateViewController(withIdentifier: "NoCardsFoundSearchViewController") as! NoCardsFoundSearchViewController
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true)
            }
        }
    }
    
    
}

extension CardSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdvancedCardSearchTableViewCell.identifier, for: indexPath) as! AdvancedCardSearchTableViewCell
            cell.titleLabel.text = "Card Name".uppercased()
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdvancedCardSearchCardTypeTableViewCell.identifier, for: indexPath) as! AdvancedCardSearchCardTypeTableViewCell
            cell.titleLabel.text = "Card Type".uppercased()
            cell.configure(with: superTypesModel)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdvancedCardSearchCardTypeTableViewCell.identifier, for: indexPath) as! AdvancedCardSearchCardTypeTableViewCell
            cell.titleLabel.text = "Card Subtype".uppercased()
            cell.configure(with: subTypesModel)
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdvancedCardSearchColorTableViewCell.identifier, for: indexPath) as! AdvancedCardSearchColorTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return 300
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CardSearchViewController {
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search card names..."
    }
    
    @objc func showSimpleSearchView() {
        searchBar.isHidden = false
        stackView.isHidden = true
        clearAllButton.isHidden = true
    }
    
    @objc func showAdvancedSearchView() {
        searchBar.isHidden = true
        stackView.isHidden = false
        clearAllButton.isHidden = false
    }
}
