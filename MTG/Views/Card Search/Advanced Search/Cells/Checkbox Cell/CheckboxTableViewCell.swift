//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

protocol CheckboxSearchModelDelegate {
    func updateCheckboxSearchModel(for titleText: String, models: [String])
}

struct CheckboxTableViewCellModel {
    var titleText: String
    var terms: [String]
}

class CheckboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var clearButton: UIButton!
    
    var cellViewModel: CheckboxTableViewCellModel!
    var tableViewDelegate: TableViewDelegate!
    var checkboxSearchModelDelegate: CheckboxSearchModelDelegate!
    
    var searchViewModels: [String] = [] {
        didSet {
            searchViewModels.isEmpty ? (clearButton.isHidden = true) : (clearButton.isHidden = false)
            checkboxSearchModelDelegate.updateCheckboxSearchModel(for: cellViewModel.titleText, models: searchViewModels)
        }
    }
    
    static let identifier = "CheckboxTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CheckboxTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        addNotificationObserver()
        
        clearButton.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CheckboxCollectionViewCell.nib(), forCellWithReuseIdentifier: CheckboxCollectionViewCell.identifier)
    }

    @IBAction func clearButtonPressed(_ sender: Any) {
        searchViewModels.removeAll()
        
        for cell in collectionView.visibleCells as! [CheckboxCollectionViewCell] {
            cell.checkboxButton.isSelected = false
        }
    }
    
    func configure(with checkboxModel: CheckboxTableViewCellModel) {
        cellViewModel = checkboxModel
        titleLabel.text = cellViewModel.titleText.uppercased()
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .vertical
//        flowLayout.minimumLineSpacing = 8
//        flowLayout.minimumInteritemSpacing = 8
//
//        let columns: CGFloat = cellViewModel.terms.count > 4 ? 3 : 2
//
//        let width = (collectionView.frame.width - (8 * 2)) / columns
//        flowLayout.itemSize = CGSize(width: width, height: 22)
//
//        collectionView.collectionViewLayout = flowLayout
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

extension CheckboxTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModel.terms.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckboxCollectionViewCell.identifier, for: indexPath) as! CheckboxCollectionViewCell
        cell.checkboxDelegate = self
        cell.configure(with: cellViewModel.terms[indexPath.row])
        return cell
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let collectionViewHeight = collectionView.collectionViewLayout.collectionViewContentSize.height

        let titleLabelHeight = titleLabel.frame.height
        let padding: CGFloat = 16
        let totalPadding: CGFloat = padding * 3

        let totalHeight = collectionViewHeight + titleLabelHeight + totalPadding
        return CGSize(width: targetSize.width, height: totalHeight)
    }
}

extension CheckboxTableViewCell: CheckboxDelegate {
    func checkboxTapped(title: String, state: Bool) {
        if searchViewModels.contains(title) {
            searchViewModels.removeAll(where: { $0.contains(title) })
        } else {
            searchViewModels.append(title)
        }
    }
}

extension CheckboxTableViewCell {
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: clearAllNotification, object: nil, queue: .main) { [weak self] _ in
            self?.searchViewModels.removeAll()
            
            for cell in self?.collectionView.visibleCells as! [CheckboxCollectionViewCell] {
                cell.checkboxButton.isSelected = false
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.tableViewDelegate.reload()
            }
        }
    }
}
