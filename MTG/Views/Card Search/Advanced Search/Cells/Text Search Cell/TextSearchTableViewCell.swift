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

protocol TextSearchModelDelegate {
    func updateTextSearchModel(models: [AdvancedCardSearchCollectionViewModel])
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

protocol TableViewDelegate {
    func reload()
}

class TextSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchViewModels: [AdvancedCardSearchCollectionViewModel] = [] {
        didSet {
            searchViewModels.isEmpty ? (clearButton.isHidden = true) : (clearButton.isHidden = false)
            textSearchModelDelegate.updateTextSearchModel(models: searchViewModels)
        }
    }
    
    var tableViewDelegate: TableViewDelegate!
    var textSearchModelDelegate: TextSearchModelDelegate!
    
    static let identifier = "TextSearchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TextSearchTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        clearButton.isHidden = true
        
        addNotificationObserver()
        
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

    @IBAction func clearButtonPressed(_ sender: Any) {
        searchViewModels.removeAll()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableViewDelegate.reload()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addSearchQuery()
    }
    
}

extension TextSearchTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        addSearchQuery()
        
        return true
    }
    
    func addSearchQuery() {
        guard let searchTerm = textField.text, !searchTerm.isEmpty else { return }
        
        let searchModel = AdvancedCardSearchCollectionViewModel(tag: searchViewModels.count, searchFilter: filterButton.currentTitle, searchTerm: searchTerm)
        
        searchViewModels.append(searchModel)
        
        textField.text = ""
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableViewDelegate.reload()
        }
    }
}

extension TextSearchTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
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

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let collectionViewHeight = collectionView.collectionViewLayout.collectionViewContentSize.height

        let titleLabelHeight = titleLabel.frame.height
        let filterButtonHeight = filterButton.frame.height
        let padding: CGFloat = 16
        let totalPadding: CGFloat = padding * 4

        let totalHeight = collectionViewHeight + titleLabelHeight + filterButtonHeight + totalPadding
        return CGSize(width: targetSize.width, height: totalHeight)
    }
}

extension TextSearchTableViewCell: AdvancedCardSearchCollectionViewCellDelegate {
    func collectionViewCellCloseButtonPressed(from index: Int) {
        searchViewModels.remove(at: index)
        
        for (i, model) in searchViewModels.enumerated() {
            model.adjustTag(to: i)
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableViewDelegate.reload()
        }
    }
}

extension TextSearchTableViewCell {
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: clearAllNotification, object: nil, queue: .main) { [weak self] _ in
            self?.searchViewModels.removeAll()
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.tableViewDelegate.reload()
            }
        }
    }
}
