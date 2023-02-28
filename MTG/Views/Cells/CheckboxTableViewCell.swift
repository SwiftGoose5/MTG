//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

struct CheckboxTableViewCellModel {
    var titleText: String
    var terms: [String]
}

class CheckboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellViewModel: CheckboxTableViewCellModel!
    
    static let identifier = "CheckboxTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CheckboxTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CheckboxCollectionViewCell.nib(), forCellWithReuseIdentifier: CheckboxCollectionViewCell.identifier)
    }

    func configure(with checkboxModel: CheckboxTableViewCellModel) {
        cellViewModel = checkboxModel
        
        titleLabel.text = cellViewModel.titleText.uppercased()
        
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
        cell.configure(with: cellViewModel.terms[indexPath.row])
        return cell
    }
}
