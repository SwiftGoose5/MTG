//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

protocol ModalFilterSelectionDelegate {
    func filterTermSelected(term: String)
}

class AdvancedCardSearchModalFilterViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var cellViewModel: DropdownTableViewCellViewModel!
    var customCellViewModel: CustomDropdownTableViewCellViewModel!
    
    var isCustom: Bool = false
    
    var termsFiltered: [String] = []
    var setsFiltered: [SetsTableViewModel] = []
    
    var modalFilterDelegate: ModalFilterSelectionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(CustomDropdownTableViewCell.nib(), forCellReuseIdentifier: CustomDropdownTableViewCell.identifier)
        tableView.separatorStyle = .none

        if isCustom {
            self.titleLabel.text = String("Card " + customCellViewModel.titleText).uppercased()
            self.searchBar.placeholder = String("Filter " + customCellViewModel.titleText)
        } else {
            self.titleLabel.text = String("Card " + cellViewModel.titleText).uppercased()
            self.searchBar.placeholder = String("Filter " + cellViewModel.titleText)
        }
    }
    

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func configure(with cellViewModel: DropdownTableViewCellViewModel, isCustom: Bool = false) {
        self.cellViewModel = cellViewModel
        self.termsFiltered = cellViewModel.terms
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func configure(with customCellViewModel: CustomDropdownTableViewCellViewModel, isCustom: Bool = true) {
        self.customCellViewModel = customCellViewModel
        self.setsFiltered = customCellViewModel.models
        self.isCustom = true
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension AdvancedCardSearchModalFilterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if isCustom {
            setsFiltered = customCellViewModel.models.filter { $0.setCode.contains(searchText) || $0.setName.contains(searchText) }
        } else {
            termsFiltered = cellViewModel.terms.filter { $0.contains(searchText) }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension AdvancedCardSearchModalFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCustom {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDropdownTableViewCell", for: indexPath)
            cell.textLabel?.text = setsFiltered[indexPath.row].setCode.uppercased()
            cell.detailTextLabel?.text = setsFiltered[indexPath.row].setName
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
            cell.textLabel?.text = termsFiltered[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCustom {
            return setsFiltered.count
        } else {
            return termsFiltered.count
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCustom {
            modalFilterDelegate.filterTermSelected(term: setsFiltered[indexPath.row].setName)
        } else {
            modalFilterDelegate.filterTermSelected(term: termsFiltered[indexPath.row])
        }
        
        self.dismiss(animated: true)
    }
}
