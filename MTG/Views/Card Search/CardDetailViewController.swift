//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class CardDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var card: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        label.text = card.name
        
        getImageResource()
    }
}

extension CardDetailViewController {
    func getImageResource() {
        Task {
            guard let largeURI = card.imageUris?.large else { return }
            
            let result = await ScryfallAPI.getCardImage(from: largeURI)
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
