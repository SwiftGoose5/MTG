//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

protocol PickerDelegate {
    func pickerOptionSelected(option: PickerOptions,
                              icon: PickerIcons,
                              identifier: PickerIdentifier)
}

struct PickerModel {
    var options: [PickerOptions]
    var icons: [PickerIcons]
    
    init(options: [PickerOptions], icons: [PickerIcons] = []) {
        self.options = options
        self.icons = icons
    }
}

class CardListPickerViewController: UIViewController {

    var pickerView: UIPickerView!
    var containerView: UIView!
    
    var pickerModel: PickerModel!
    var pickerIdentifier: PickerIdentifier!
    var pickerDelegate: PickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: view.frame.height - 180, width: view.bounds.width, height: 180)
        
        // Create the container view for the picker
        containerView = UIView(frame: CGRect(x: 0, y: view.frame.height - 180, width: view.bounds.width, height: 180))
        containerView.backgroundColor = .clear
        
        // Add the blur effect and container view to the main view
        view.addSubview(blurEffectView)
        view.addSubview(containerView)
        
        // Create the picker view
        pickerView = UIPickerView(frame: containerView.bounds)
        pickerView.backgroundColor = .clear
        
        containerView.addSubview(pickerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    func configure(with pickerModel: PickerModel, identifier: PickerIdentifier) {
        self.pickerModel = pickerModel
        self.pickerIdentifier = identifier
    }
}

extension CardListPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerModel.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dismiss(animated: true) { [self] in
            pickerDelegate.pickerOptionSelected(option: self.pickerModel.options[row],
                                                icon: self.pickerModel.icons[row],
                                                identifier: pickerIdentifier)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerModel.options[row].rawValue
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: pickerModel.icons[row].rawValue)
        let imageString = NSAttributedString(attachment: imageAttachment)
        let titleWithImage = NSMutableAttributedString(string: "")
        titleWithImage.append(imageString)
        titleWithImage.append(NSAttributedString(string: "  "))
        titleWithImage.append(NSAttributedString(string: title))
        return titleWithImage
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
}
