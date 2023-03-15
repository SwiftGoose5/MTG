//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

protocol ColorSearchModelDelegate {
    func updateColorSearchModel(models: [AdvancedCardSearchCollectionViewModel])
}

class ColorSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var termCollectionView: UICollectionView!
    
    var searchViewModels: [AdvancedCardSearchCollectionViewModel] = [] {
        didSet {
            searchViewModels.isEmpty ? (clearButton.isHidden = true) : (clearButton.isHidden = false)
            colorSearchModelDelegate.updateColorSearchModel(models: searchViewModels)
        }
    }
    
    var selectedColors: [String] = []
    var tableViewDelegate: TableViewDelegate!
    var colorSearchModelDelegate: ColorSearchModelDelegate!
    
    static let identifier = "ColorSearchTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ColorSearchTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        clearButton.isHidden = true
        
        addNotificationObserver()
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.allowsMultipleSelection = true
        colorCollectionView.register(ColorSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: ColorSearchCollectionViewCell.identifier)
        
        termCollectionView.delegate = self
        termCollectionView.dataSource = self
        
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        termCollectionView.collectionViewLayout = flowLayout
        
        termCollectionView.register(AdvancedCardSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: AdvancedCardSearchCollectionViewCell.identifier)
        
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        searchViewModels.removeAll()
        for cell in self.colorCollectionView.visibleCells {
            if cell.isSelected {
                cell.isSelected = false
                cell.contentView.backgroundColor = .none
            }
        }
        
        DispatchQueue.main.async {
            self.termCollectionView.reloadData()
            self.tableViewDelegate.reload()
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addSearchQuery()
    }
    
    func addSearchQuery() {
        guard let searchTerm = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else { return }
        var searchTermModified = ""
        
        switch searchTerm {
        case "Include", "Exclude":
            searchTermModified = searchTerm + "s"
            
        default:
            break
        }
        
        searchTermModified = searchTermModified.uppercased()
        
        var colors: String = ""
        
        if selectedColors.count > 1 {
            for (index, color) in selectedColors.enumerated() {
                if index != selectedColors.count - 1 {
                    colors.append(String(color + ", "))
                } else {
                    colors.append(color)
                }
            }
        } else {
            colors.append(selectedColors.first ?? "")
        }
        
        let searchModel = AdvancedCardSearchCollectionViewModel(tag: searchViewModels.count, searchFilter: searchTermModified, searchTerm: colors)
        
        searchViewModels.append(searchModel)
        
        DispatchQueue.main.async {
            self.termCollectionView.reloadData()
            self.tableViewDelegate.reload()
        }
    }
}

extension ColorSearchTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == colorCollectionView {
            return CardColors.allCases.count
        } else {
            return searchViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colorCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSearchCollectionViewCell.identifier, for: indexPath) as! ColorSearchCollectionViewCell
            
            var imageForCell: UIImage!
            
            switch indexPath.row {
            case 0:
                imageForCell = UIImage(named: "W")
            case 1:
                imageForCell = UIImage(named: "U")
            case 2:
                imageForCell = UIImage(named: "B")
            case 3:
                imageForCell = UIImage(named: "R")
            case 4:
                imageForCell = UIImage(named: "G")
            default:
                imageForCell = UIImage(named: "C")
            }
            
            let colorViewModel = ColorCollectionViewCellViewModel(image: imageForCell)
            
            cell.configure(with: colorViewModel)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvancedCardSearchCollectionViewCell.identifier, for: indexPath) as! AdvancedCardSearchCollectionViewCell
            cell.viewModel = searchViewModels[indexPath.row]
            cell.configure()
            cell.delegate = self
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            
            cell!.contentView.layer.cornerRadius = cell!.frame.width / 2
            
            UIView.animate(withDuration: 0.2) {
                cell!.contentView.backgroundColor = .systemBlue
            }
            
            
            switch indexPath.row {
            case 0:
                selectedColors.append(CardColors.White.rawValue)
            case 1:
                selectedColors.append(CardColors.Blue.rawValue)
            case 2:
                selectedColors.append(CardColors.Black.rawValue)
            case 3:
                selectedColors.append(CardColors.Red.rawValue)
            case 4:
                selectedColors.append(CardColors.Green.rawValue)
            default:
                selectedColors.append(CardColors.Colorless.rawValue)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            
            cell!.contentView.backgroundColor = .none
            
            switch indexPath.row {
            case 0:
                selectedColors.removeAll(where: { $0.elementsEqual(CardColors.White.rawValue) })
            case 1:
                selectedColors.removeAll(where: { $0.elementsEqual(CardColors.Blue.rawValue) })
            case 2:
                selectedColors.removeAll(where: { $0.elementsEqual(CardColors.Black.rawValue) })
            case 3:
                selectedColors.removeAll(where: { $0.elementsEqual(CardColors.Red.rawValue) })
            case 4:
                selectedColors.removeAll(where: { $0.elementsEqual(CardColors.Green.rawValue) })
            default:
                selectedColors.removeAll(where: { $0.elementsEqual(CardColors.Colorless.rawValue) })
            }
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let collectionViewHeight = termCollectionView.collectionViewLayout.collectionViewContentSize.height

        let titleLabelHeight = titleLabel.frame.height
        let segmentedControlHeight = segmentedControl.frame.height
        let colorCollectionViewHeight = colorCollectionView.frame.height
        let padding: CGFloat = 16
        let totalPadding: CGFloat = padding * 4

        let totalHeight = collectionViewHeight + titleLabelHeight + segmentedControlHeight + colorCollectionViewHeight + totalPadding
        return CGSize(width: targetSize.width, height: totalHeight)
    }
}

extension ColorSearchTableViewCell: AdvancedCardSearchCollectionViewCellDelegate {
    func collectionViewCellCloseButtonPressed(from index: Int) {
        searchViewModels.remove(at: index)
        
        for (i, model) in searchViewModels.enumerated() {
            model.adjustTag(to: i)
        }
        
        DispatchQueue.main.async {
            self.termCollectionView.reloadData()
            self.tableViewDelegate.reload()
        }
    }
}

extension ColorSearchTableViewCell {
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: clearAllNotification, object: nil, queue: .main) { [weak self] _ in
            self?.searchViewModels.removeAll()
            for cell in self!.colorCollectionView.visibleCells {
                if cell.isSelected {
                    cell.isSelected = false
                    cell.contentView.backgroundColor = .none
                }
            }
            
            DispatchQueue.main.async {
                self?.termCollectionView.reloadData()
                self?.tableViewDelegate.reload()
            }
        }
    }
}
