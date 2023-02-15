//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

enum CardColors: String, CaseIterable {
    case White = "White"
    case Blue = "Blue"
    case Black = "Black"
    case Red = "Red"
    case Green = "Green"
    case Colorless = "Colorless"
}

class AdvancedCardSearchColorTableViewCell: UITableViewCell {

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var termCollectionView: UICollectionView!
    
    var searchViewModels: [AdvancedCardSearchCollectionViewModel] = [] {
        didSet {
            searchViewModels.isEmpty ? (clearButton.isHidden = true) : (clearButton.isHidden = false)
        }
    }
    
    var selectedColors: [String] = []
    
    static let identifier = "AdvancedCardSearchColorTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AdvancedCardSearchColorTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearButton.isHidden = true
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.allowsMultipleSelection = true
        colorCollectionView.register(ColorCollectionViewCell.nib(), forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        
        termCollectionView.delegate = self
        termCollectionView.dataSource = self
        
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        termCollectionView.collectionViewLayout = flowLayout
        
        termCollectionView.register(AdvancedCardSearchCollectionViewCell.nib(), forCellWithReuseIdentifier: AdvancedCardSearchCollectionViewCell.identifier)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        searchViewModels.removeAll()
        
        DispatchQueue.main.async {
            self.termCollectionView.reloadData()
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addSearchQuery()
    }
    
    func addSearchQuery() {
        guard let searchTerm = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else { return }
        
        var colors: String = ""
        
        for color in selectedColors {
            colors.append(String(color + " "))
        }
        
        let searchModel = AdvancedCardSearchCollectionViewModel(tag: searchViewModels.count, searchFilter: searchTerm, searchTerm: colors)
        
        searchViewModels.append(searchModel)
        
        DispatchQueue.main.async {
            self.termCollectionView.reloadData()
        }
    }
}

extension AdvancedCardSearchColorTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == colorCollectionView {
            return 6
        } else {
            return searchViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colorCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
            
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
            cell!.contentView.backgroundColor = .systemBlue
            
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
}

extension AdvancedCardSearchColorTableViewCell: AdvancedCardSearchCollectionViewCellDelegate {
    func collectionViewCellCloseButtonPressed(from index: Int) {
        searchViewModels.remove(at: index)
        
        for (i, model) in searchViewModels.enumerated() {
            model.adjustTag(to: i)
        }
        
        DispatchQueue.main.async {
            self.termCollectionView.reloadData()
        }
    }
}
