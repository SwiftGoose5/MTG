//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

struct AdvancedCardSearchCardTypeTableViewCellViewModel {
    var titleText: String
    var cellIdentifier: String
    var terms: [String]
}

class AdvancedCardSearchCardTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellViewModel: AdvancedCardSearchCardTypeTableViewCellViewModel!
    
    var searchViewModels: [AdvancedCardSearchCollectionViewModel] = [] {
        didSet {
            searchViewModels.isEmpty ? (clearButton.isHidden = true) : (clearButton.isHidden = false)
        }
    }
    
    static let identifier = "AdvancedCardSearchCardTypeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AdvancedCardSearchCardTypeTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearButton.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AdvancedCardSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: AdvancedCardSearchCollectionViewCell.identifier)
        
        configureFlowLayout()
        configureMenu()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with cellViewModel: AdvancedCardSearchCardTypeTableViewCellViewModel) {
        self.cellViewModel = cellViewModel
        
//        dropdownButton.titleLabel!.text = String("Enter " + cellViewModel.titleText)
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
        vc.configure(with: cellViewModel)
        vc.modalFilterDelegate = self
        vc.modalPresentationStyle = .popover
        window?.rootViewController!.present(vc, animated: true)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        searchViewModels.removeAll()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension AdvancedCardSearchCardTypeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
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

extension AdvancedCardSearchCardTypeTableViewCell: AdvancedCardSearchCollectionViewCellDelegate {
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

extension AdvancedCardSearchCardTypeTableViewCell: ModalFilterSelectionDelegate {
    func filterTermSelected(term: String) {
        searchViewModels.append(AdvancedCardSearchCollectionViewModel(tag: searchViewModels.count, searchFilter: filterButton.currentTitle, searchTerm: term))
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

