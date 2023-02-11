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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cards"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AdvancedCardSearchTableViewCell.nib(), forCellReuseIdentifier: AdvancedCardSearchTableViewCell.identifier)
        
        configureSearchBar()
        showSimpleSearchView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: AdvancedCardSearchTableViewCell.identifier, for: indexPath) as! AdvancedCardSearchTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
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
