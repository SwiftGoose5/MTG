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
    func pickerOptionSelected(option: PickerOptions, identifier: PickerIdentifier)
}

struct PickerModel {
    var terms: [PickerOptions]
    var icons: [PickerIcons]
}

class CardListPickerViewController: UIViewController {

    var pickerView: UIPickerView!
    var containerView: UIView!
    
    var pickerModel: PickerModel!
    var pickerIdentifier: PickerIdentifier!
    var pickerDelegate: PickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: view.frame.height - 180, width: view.bounds.width, height: 180))
        pickerView.backgroundColor = .darkGray
        
        view.addSubview(pickerView)
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
        return pickerModel.terms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // TODO: - Set up the picker icon
        
        
        let title = pickerModel.terms[row].rawValue
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "yourImageNameHere")
        let imageString = NSAttributedString(attachment: imageAttachment)
        let titleWithImage = NSMutableAttributedString(string: title)
        titleWithImage.append(imageString)
        return titleWithImage.string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dismiss(animated: true) { [self] in
            pickerDelegate.pickerOptionSelected(option: self.pickerModel.terms[row], identifier: pickerIdentifier)
        }
    }
}
