//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

struct CustomDropdownTableViewCellViewModel {
    var titleText: String
    var cellIdentifier: String
    var models: [SetsTableViewModel]
}

struct SetsTableViewModel {
    var setCode: String
    var setName: String
}

class CustomDropdownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var setCodeLabel: UILabel!
    @IBOutlet weak var setNameLabel: UILabel!
    
    var viewModel: SetsTableViewModel!
    
    static let identifier = "CustomDropdownTableViewCells"
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomDropdownTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: SetsTableViewModel) {
        self.viewModel = viewModel
        setCodeLabel.text = viewModel.setCode.uppercased()
        setNameLabel.text = viewModel.setName
    }
    
}
