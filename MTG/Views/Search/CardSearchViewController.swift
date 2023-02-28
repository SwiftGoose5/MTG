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
    
    var superTypesModel: DropdownTableViewCellViewModel!
    var subTypesModel: DropdownTableViewCellViewModel!
    var setsModel: CustomDropdownTableViewCellViewModel!
    var formatsModel: CheckboxTableViewCellModel!
    var rarityModel: CheckboxTableViewCellModel!
    
//    var setsModels: [SetsTableViewModel]!
    
    var advancedSearchQueryModels: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        superTypesModel = DropdownTableViewCellViewModel(titleText: "Super Types", cellIdentifier: "ModalCell", terms: Types.allCases.map { $0.rawValue })
        subTypesModel = DropdownTableViewCellViewModel(titleText: "", cellIdentifier: "", terms: [])
        formatsModel = CheckboxTableViewCellModel(titleText: "Formats", terms: Format.allCases.map { $0.rawValue })
        rarityModel = CheckboxTableViewCellModel(titleText: "Rarity", terms: Rarity.allCases.map { $0.rawValue })
        
        navigationItem.title = "Cards"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.register(AdvancedCardSearchTableViewCell.nib(), forCellReuseIdentifier: AdvancedCardSearchTableViewCell.identifier)
        tableView.register(DropdownTableViewCell.nib(), forCellReuseIdentifier: DropdownTableViewCell.identifier + "SuperType")
        tableView.register(DropdownTableViewCell.nib(), forCellReuseIdentifier: DropdownTableViewCell.identifier + "SubType")
        tableView.register(DropdownTableViewCell.nib(), forCellReuseIdentifier: DropdownTableViewCell.identifier + "Set")
        tableView.register(ColorSearchTableViewCell.nib(), forCellReuseIdentifier: ColorSearchTableViewCell.identifier)
        tableView.register(SliderTableViewCell.nib(), forCellReuseIdentifier: SliderTableViewCell.identifier)
        tableView.register(CheckboxTableViewCell.nib(), forCellReuseIdentifier: CheckboxTableViewCell.identifier)
        
        configureSearchBar()
        showSimpleSearchView()
        
        fetchSubTypes()
        fetchSets()
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
            
            subTypesModel = DropdownTableViewCellViewModel(titleText: "Subtypes", cellIdentifier: "ModalCell", terms: subTypes)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchSets() {
        Task {
            var sets: [SetsTableViewModel] = []
            
            let getSets = await ScryfallInteractor.getSetsWithSymbols()
            
            sets.append(contentsOf: getSets)
            sets.sort(by: { $0.setName < $1.setName })
            
            setsModel = CustomDropdownTableViewCellViewModel(titleText: "Sets", cellIdentifier: CustomDropdownTableViewCell.identifier, models: sets)
            
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

extension CardSearchViewController: TableViewDelegate {
    func reload() {
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
}

extension CardSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdvancedCardSearchTableViewCell.identifier, for: indexPath) as! AdvancedCardSearchTableViewCell
            cell.titleLabel.text = "Card Name".uppercased()
            cell.tableViewDelegate = self
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DropdownTableViewCell.identifier + "SuperType", for: indexPath) as! DropdownTableViewCell
            cell.titleLabel.text = "Card Type".uppercased()
            cell.dropdownButton.setTitle("Enter Type, Supertype", for: .normal)
            cell.tableViewDelegate = self
            cell.configure(with: superTypesModel)
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DropdownTableViewCell.identifier + "SubType", for: indexPath) as! DropdownTableViewCell
            cell.titleLabel.text = "Card Subtype".uppercased()
            cell.dropdownButton.setTitle("Enter Subtype", for: .normal)
            cell.tableViewDelegate = self
            cell.configure(with: subTypesModel)
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorSearchTableViewCell.identifier, for: indexPath) as! ColorSearchTableViewCell
            cell.tableDelegate = self
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier, for: indexPath) as! SliderTableViewCell
            cell.titleLabel.text = "Mana Value".uppercased()
            return cell
        }
        else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier, for: indexPath) as! SliderTableViewCell
            cell.titleLabel.text = "Power".uppercased()
            return cell
        }
        else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier, for: indexPath) as! SliderTableViewCell
            cell.titleLabel.text = "Toughness".uppercased()
            return cell
        }
        else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DropdownTableViewCell.identifier + "Set", for: indexPath) as! DropdownTableViewCell
            cell.configure(with: setsModel)
            cell.titleLabel.text = "Sets".uppercased()
            cell.dropdownButton.setTitle("Enter Set", for: .normal)
            cell.tableViewDelegate = self
            return cell
        }
        else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckboxTableViewCell.identifier, for: indexPath) as! CheckboxTableViewCell
            cell.configure(with: formatsModel)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckboxTableViewCell.identifier, for: indexPath) as! CheckboxTableViewCell
            cell.configure(with: rarityModel)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
