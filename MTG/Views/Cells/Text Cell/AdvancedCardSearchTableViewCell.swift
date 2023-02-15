//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

enum SearchFilters: String {
    case IS = "IS"
    case OR = "OR"
    case NOT = "NOT"
}

class AdvancedCardSearchCollectionViewModel {
    var tag: Int!
    var searchFilter: String!
    var searchTerm: String!
    
    init(tag: Int!, searchFilter: String!, searchTerm: String!) {
        self.tag = tag
        self.searchFilter = searchFilter
        self.searchTerm = searchTerm
    }
    
    func adjustTag(to index: Int) {
        tag = index
    }
}

class AdvancedCardSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchTerms: [String] = []
    var searchFilters: [SearchFilters] = []
    var searchViewModels: [AdvancedCardSearchCollectionViewModel] = [] {
        didSet {
            searchViewModels.isEmpty ? (clearButton.isHidden = true) : (clearButton.isHidden = false)
        }
    }
    
    static let identifier = "AdvancedCardSearchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AdvancedCardSearchTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        clearButton.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        textField.delegate = self
        
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(AdvancedCardSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: AdvancedCardSearchCollectionViewCell.identifier)
        
        let menu = UIMenu(title: "", options: [.displayInline, .destructive], children: [
            UIAction(title: "IS", image: nil, identifier: nil, discoverabilityTitle: nil, state: .on) { _ in
            },
            UIAction(title: "OR", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
            },
            UIAction(title: "NOT", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
            }
        ])
        
        filterButton.menu = menu
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        searchViewModels.removeAll()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addSearchQuery()
    }
    
}

extension AdvancedCardSearchTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        addSearchQuery()
        
        return true
    }
    
    func addSearchQuery() {
        guard let searchTerm = textField.text else { return }
        
        let searchModel = AdvancedCardSearchCollectionViewModel(tag: searchViewModels.count, searchFilter: filterButton.currentTitle, searchTerm: searchTerm)
        
        searchViewModels.append(searchModel)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension AdvancedCardSearchTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvancedCardSearchCollectionViewCell.identifier, for: indexPath) as! AdvancedCardSearchCollectionViewCell
        cell.viewModel = searchViewModels[indexPath.row]
        cell.configure()
        cell.delegate = self
        
        return cell
    }
}

extension AdvancedCardSearchTableViewCell: AdvancedCardSearchCollectionViewCellDelegate {
    func collectionViewCellCloseButtonPressed(from index: Int) {
        searchViewModels.remove(at: index)
        
        for (i, model) in searchViewModels.enumerated() {
            model.adjustTag(to: i)
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
