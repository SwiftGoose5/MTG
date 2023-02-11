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
    case IS = "Is"
    case OR = "Or"
    case NOT = "Not"
}

struct AdvancedCardSearchCollectionViewModel {
    var tag: Int!
    var searchFilter: String!
    var searchTerm: String!
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
        // Initialization code
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView.register(AdvancedCardSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: AdvancedCardSearchCollectionViewCell.identifier)
        
        let menu = UIMenu(title: "", options: [.displayInline, .destructive], children: [
            UIAction(title: "IS", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
            },
            UIAction(title: "OR", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
            },
            UIAction(title: "NOT", image: nil, identifier: nil, discoverabilityTitle: nil, state: .on) { _ in
            }
        ])
        
        filterButton.menu = menu
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        searchTerms.removeAll()
    }
    
    @IBAction func textFieldSearchPressed(_ sender: Any) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
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

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = AdvancedCardSearchCollectionViewCell()
//
//        let desiredWidth = cell.contentView.frame.width
//        let size = cell.contentView.systemLayoutSizeFitting(CGSize(width: desiredWidth, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//        return CGSize(width: ceil(size.width), height: 22)
//    }

}

extension AdvancedCardSearchTableViewCell: AdvancedCardSearchCollectionViewCellDelegate {
    func collectionViewCellCloseButtonPressed(from index: Int) {
        searchViewModels.remove(at: index)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
