//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class NoCardsFoundSearchViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var sorryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sorryLabel.numberOfLines = -1
        okButton.layer.cornerRadius = 12
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    @IBAction func okButtonPressed(_ sender: Any) {
//        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }

}
