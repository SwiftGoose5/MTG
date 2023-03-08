//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

struct DropdownTableViewCellViewModel {
    var titleText: String
    var cellIdentifier: String
    var terms: [String]
}

protocol DropdownSearchModelDelegate {
    func updateDropdownSearchModel(for titleText: String, models: [AdvancedCardSearchCollectionViewModel])
}

class DropdownTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellViewModel: DropdownTableViewCellViewModel!
    var customCellViewModel: CustomDropdownTableViewCellViewModel!
    
    var custom: Bool = false
    
    var searchViewModels: [AdvancedCardSearchCollectionViewModel] = [] {
        didSet {
            searchViewModels.isEmpty ? (clearButton.isHidden = true) : (clearButton.isHidden = false)
            dropdownSearchModelDelegate.updateDropdownSearchModel(for: cellViewModel != nil ? (cellViewModel.titleText) : (customCellViewModel.titleText), models: searchViewModels)
        }
    }
    
    var tableViewDelegate: TableViewDelegate!
    var dropdownSearchModelDelegate: DropdownSearchModelDelegate!
    
    static let identifier = "DropdownTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DropdownTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        addNotificationObserver()
        clearButton.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AdvancedCardSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: AdvancedCardSearchCollectionViewCell.identifier)
        
        configureFlowLayout()
        configureMenu()
    }
    
    func configure(with cellViewModel: DropdownTableViewCellViewModel) {
        self.cellViewModel = cellViewModel
        self.titleLabel.text = cellViewModel.titleText.uppercased()
        self.dropdownButton.setTitle("Enter " + cellViewModel.titleText, for: .normal)
        self.custom = false
    }
    
    func configure(with customCellViewModel: CustomDropdownTableViewCellViewModel) {
        self.customCellViewModel = customCellViewModel
        self.titleLabel.text = customCellViewModel.titleText.uppercased()
        self.dropdownButton.setTitle("Enter " + customCellViewModel.titleText, for: .normal)
        self.custom = true
    }
    
    func configureFlowLayout() {
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = flowLayout
    }
    
    func configureMenu() {
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
    
    @IBAction func dropdownButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdvancedCardSearchModalFilterViewController") as! AdvancedCardSearchModalFilterViewController
        
        if custom {
            vc.configure(with: customCellViewModel)
        } else {
            vc.configure(with: cellViewModel)
        }
        
        vc.modalFilterDelegate = self
        vc.modalPresentationStyle = .popover
        window?.rootViewController!.present(vc, animated: true)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        searchViewModels.removeAll()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableViewDelegate.reload()
        }
    }
}

extension DropdownTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
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

extension DropdownTableViewCell: AdvancedCardSearchCollectionViewCellDelegate {
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

extension DropdownTableViewCell: ModalFilterSelectionDelegate {
    func filterTermSelected(term: String) {
        searchViewModels.append(AdvancedCardSearchCollectionViewModel(tag: searchViewModels.count, searchFilter: filterButton.currentTitle, searchTerm: term))
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableViewDelegate.reload()
        }
    }
}

extension DropdownTableViewCell {
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
