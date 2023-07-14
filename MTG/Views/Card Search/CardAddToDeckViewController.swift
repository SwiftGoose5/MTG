//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class CardAddToDeckViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    var card: Card!
    var quantityToAdd: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func configure(with card: Card) {
        self.card = card
        
        titleLabel.text = String("Add " + card.name! + " to deck")
        quantityLabel.text = String(quantityToAdd)
    }
    
    @IBAction func decreaseButtonTapped(_ sender: Any) {
        quantityToAdd -= 1
        
        quantityToAdd == 0 ? (quantityLabel.isEnabled = false) : (quantityLabel.isEnabled = true)
    }
    
    @IBAction func increaseButtonTapped(_ sender: Any) {
        quantityToAdd += 1
        
        quantityToAdd >= 1 ? (quantityLabel.isEnabled = false) : (quantityLabel.isEnabled = true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    
}
