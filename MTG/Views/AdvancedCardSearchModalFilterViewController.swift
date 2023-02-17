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
    
    var cellViewModel: AdvancedCardSearchCardTypeTableViewCellViewModel!
    var termsFiltered: [String] = []
    var modalFilterDelegate: ModalFilterSelectionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        self.titleLabel.text = String("Card " + cellViewModel.titleText).uppercased()
        self.searchBar.placeholder = String("Filter " + cellViewModel.titleText)
    }
    

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func configure(with cellViewModel: AdvancedCardSearchCardTypeTableViewCellViewModel) {
        self.cellViewModel = cellViewModel
        self.termsFiltered = cellViewModel.terms
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension AdvancedCardSearchModalFilterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        termsFiltered = cellViewModel.terms.filter { $0.contains(searchText) }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension AdvancedCardSearchModalFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
        cell.textLabel?.text = termsFiltered[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modalFilterDelegate.filterTermSelected(term: termsFiltered[indexPath.row])
        self.dismiss(animated: true)
    }
}
