//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var dragLeftButton: UIButton!
    @IBOutlet weak var dragRightButton: UIButton!
    @IBOutlet weak var dragBackground: UIView!
    @IBOutlet weak var sliderBackground: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet var stackViewElements: [UIView]!
    
    
    static let identifier = "SliderTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SliderTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        let panLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPan(_:)))
        dragLeftButton.addGestureRecognizer(panLeftGesture)
        
        let panRightGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRightPan(_:)))
        dragRightButton.addGestureRecognizer(panRightGesture)
        
        sliderBackground.layer.cornerRadius = sliderBackground.frame.height / 2
        dragLeftButton.layer.cornerRadius = dragLeftButton.frame.height / 2
        dragRightButton.layer.cornerRadius = dragRightButton.frame.height / 2
        dragBackground.layer.cornerRadius = dragBackground.frame.height / 2
        
        dragLeftButton.layer.zPosition = 1
        dragLeftButton.tintColor = .orange
        
        dragRightButton.layer.zPosition = 1
        dragRightButton.tintColor = .black
        
        dragLeftButton.center.x = stackView.center.x
        dragRightButton.center.x = stackView.center.x
    }
    
    @objc func handleLeftPan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: superview)
//        let location = gesture.location(in: stackView)
//
//        print(location.x)
//
//        if let button = gesture.view as? UIButton, let buttonBackground = button.superview {
//
//            var newFrame = buttonBackground.frame
//            let originalX = buttonBackground.frame.origin.x + button.frame.origin.x
//
//            let newX = originalX + translation.x
//            let newWidth = buttonBackground.frame.width - (newX - originalX)
//
//            newFrame.origin.x = newX - button.frame.origin.x
//            newFrame.size.width = newWidth
//            buttonBackground.frame = newFrame
//            dragRightButton.frame.origin.x = newWidth - button.frame.width * 1.5
//
//            buttonBackground.backgroundColor = .cyan
//
//        }
//        gesture.setTranslation(CGPoint.zero, in: superview)
        
        
        let translation = gesture.translation(in: superview)
        let touchLocationInStackView = gesture.location(in: stackView)
        let touchLocationInSliderView = gesture.location(in: sliderBackground)
        
        if touchLocationInSliderView.x <= dragRightButton.center.x {
            
            if let button = gesture.view as? UIButton {
                dragLeftButton.center.x = button.center.x + translation.x
                
                let closestElement = getClosestView(near: touchLocationInStackView)
                
                let centerX = closestElement.center.x
                dragLeftButton.center.x = centerX + 19
                
                
                var newFrame = dragBackground.frame
                newFrame.origin.x = dragLeftButton.center.x - dragLeftButton.frame.width
                let newWidth = dragRightButton.center.x - dragLeftButton.center.x + (dragRightButton.frame.width * 2)
                newFrame.size.width = newWidth
                dragBackground.frame = newFrame
                dragBackground.backgroundColor = .white
            }
            
            gesture.setTranslation(CGPoint.zero, in: superview)
        }
    }
    
    @objc func handleRightPan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: superview)
//        let location = gesture.location(in: stackView)
//        print(location.x)
//
//        if let button = gesture.view as? UIButton, let buttonBackground = button.superview {
//            var newFrame = buttonBackground.frame
//            let newWidth = buttonBackground.frame.width + translation.x
//            button.center = CGPoint(x: newWidth - button.frame.width, y: button.center.y)
//            newFrame.size.width = newWidth
//            buttonBackground.frame = newFrame
//            buttonBackground.backgroundColor = .gray
//
//
//            // Find the closest stackViewElement
//            var minDistance = CGFloat.greatestFiniteMagnitude
//            var closestIndex = -1
//            for (index, element) in stackViewElements.enumerated() {
//                let centerX = element.center.x
//                let distance = abs(location.x - centerX)
//                print("tag: \(element.tag), x: \(centerX), dist: \(distance)")
//                if distance < minDistance {
//                    minDistance = distance
//                    closestIndex = index
//                }
//            }
//
//            // Snap the button to the x location of the closest stackViewElement
//            let closestElement = stackViewElements[closestIndex]
//            print(closestElement.tag)
////            let centerX = closestElement.center.x
////            button.center.x = centerX
////            buttonBackground.frame.origin.x = centerX - button.frame.origin.x
//
//        }
//        gesture.setTranslation(CGPoint.zero, in: superview)
        
//        if dragRightButton.center.x == dragLeftButton.center.x {
//            handleLeftPan(gesture)
//        } else {
            
            
            let translation = gesture.translation(in: superview)
            let touchLocationInStackView = gesture.location(in: stackView)
            let touchLocationInSliderView = gesture.location(in: sliderBackground)
            
            if touchLocationInSliderView.x >= dragLeftButton.center.x {
                
                if let button = gesture.view as? UIButton {
                    dragRightButton.center.x = button.center.x + translation.x
                    
                    let closestElement = getClosestView(near: touchLocationInStackView)
                    
                    let centerX = closestElement.center.x
                    dragRightButton.center.x = centerX + 19
                    
                    
                    var newFrame = dragBackground.frame
                    newFrame.origin.x = dragLeftButton.center.x - dragRightButton.frame.width
                    let newWidth = dragRightButton.center.x - dragLeftButton.center.x + (dragRightButton.frame.width * 2)
                    newFrame.size.width = newWidth
                    dragBackground.frame = newFrame
                    dragBackground.backgroundColor = .white
                }
                
                gesture.setTranslation(CGPoint.zero, in: superview)
            }
//        }
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: targetSize.width, height: 120)
    }
    
    func getClosestView(near point: CGPoint) -> UIView {
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestIndex = 0
        
        for (index, element) in stackViewElements.enumerated() {
            let centerX = element.center.x
            let distance = abs(point.x - centerX)
            if distance < minDistance {
                minDistance = distance
                closestIndex = index
            }
        }
        
        return stackViewElements[closestIndex]
    }
}
