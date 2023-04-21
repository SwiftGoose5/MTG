//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

protocol SliderSearchModelDelegate {
    func updateSliderSearchModel(for titleText: String, model: [String])
}

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var dragLeftButton: UIButton!
    @IBOutlet weak var dragRightButton: UIButton!
    @IBOutlet weak var dragBackground: UIView!
    @IBOutlet weak var buttonsBackground: UIView!
    @IBOutlet weak var sliderBackground: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var stackViewElements: [UIView]!
    
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let stackViewLeftPadding = CGFloat(19)

    private var previousLeftTag = 6
    private var previousRightTag = 6

    private var overlapShouldPanLeft = false
    
    private var animationDuration: TimeInterval = 0.05

    private var leftSliderTagValue: Int = 6 {
        didSet {
            updateLabel()
        }
    }
    private var rightSliderTagValue: Int = 6 {
        didSet {
            updateLabel()
        }
    }
    
    var sliderTableViewModel: [String] = [] {
        didSet {
            sliderSearchModelDelegate.updateSliderSearchModel(for: titleLabel.text!.capitalized, model: sliderTableViewModel)
        }
    }
    var sliderSearchModelDelegate: SliderSearchModelDelegate!
    
    static let identifier = "SliderTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SliderTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        addNotificationObserver()
        
        let panLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPan(_:)))
        dragLeftButton.addGestureRecognizer(panLeftGesture)
        
        let panRightGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRightPan(_:)))
        dragRightButton.addGestureRecognizer(panRightGesture)
        
        impactFeedbackGenerator.prepare()
        
        sliderBackground.layer.cornerRadius = sliderBackground.frame.height / 2
        dragLeftButton.layer.cornerRadius = dragLeftButton.frame.height / 2
        dragRightButton.layer.cornerRadius = dragRightButton.frame.height / 2
        dragBackground.layer.cornerRadius = dragBackground.frame.height / 2
        buttonsBackground.layer.cornerRadius = buttonsBackground.frame.height / 2
        
        let leftGradientLayer = CAGradientLayer()
        leftGradientLayer.type = .radial
        leftGradientLayer.frame = dragLeftButton.bounds
        leftGradientLayer.colors = [UIColor.yellow.cgColor, UIColor.orange.cgColor]
        leftGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        leftGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        let rightGradientLayer = CAGradientLayer()
        rightGradientLayer.type = .radial
        rightGradientLayer.frame = dragRightButton.bounds
        rightGradientLayer.colors = [UIColor.yellow.cgColor, UIColor.orange.cgColor]
        rightGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        rightGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        dragLeftButton.layer.insertSublayer(leftGradientLayer, at: 1)
        dragRightButton.layer.insertSublayer(rightGradientLayer, at: 1)
        
        dragBackground.backgroundColor = .white
        buttonsBackground.backgroundColor = .blue
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.resetSliders()
        }
    }
    
    @objc func handleLeftPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began && clearButton.isHidden {
            clearButton.isHidden = false
        }
        
        let touchLocationInStackView = gesture.location(in: stackView)
        let touchLocationInSliderBackgroundView = gesture.location(in: sliderBackground)
        
        if gesture.state == .ended {
            overlapShouldPanLeft = false
        }
        
        if touchLocationInSliderBackgroundView.x >= dragRightButton.center.x {
            return
        }

        let closestElement = getClosestView(near: touchLocationInStackView)
        
        if previousLeftTag != closestElement.tag {
            impactFeedbackGenerator.impactOccurred()
        }
        
        leftSliderTagValue = closestElement.tag
        previousLeftTag = closestElement.tag
        
        let centerX = closestElement.center.x
        
        UIView.animate(withDuration: animationDuration) {
            self.dragLeftButton.center.x = centerX + self.stackViewLeftPadding
        }
        
        regenerateBackgroundFrames()
        
        gesture.setTranslation(CGPoint.zero, in: superview)
    }
    
    @objc func handleRightPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began && clearButton.isHidden {
            clearButton.isHidden = false
        }
        
        let translation = gesture.translation(in: superview)
        let touchLocationInStackView = gesture.location(in: stackView)
        let touchLocationInSliderBackgroundView = gesture.location(in: sliderBackground)
        
        if gesture.state == .began && dragLeftButton.center.x == dragRightButton.center.x && translation.x < 0 {
            overlapShouldPanLeft = true
            handleLeftPan(gesture)
        }
        
        else {
            if overlapShouldPanLeft {
                handleLeftPan(gesture)
                return
            }
            if touchLocationInSliderBackgroundView.x <= dragLeftButton.center.x { return }

            let closestElement = getClosestView(near: touchLocationInStackView)
            
            if previousRightTag != closestElement.tag {
                impactFeedbackGenerator.impactOccurred()
            }
            
            rightSliderTagValue = closestElement.tag
            previousRightTag = closestElement.tag
            
            let centerX = closestElement.center.x
            
            UIView.animate(withDuration: animationDuration) {
                self.dragRightButton.center.x = centerX + self.stackViewLeftPadding
            }
            
            regenerateBackgroundFrames()
        }
        
        gesture.setTranslation(CGPoint.zero, in: superview)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        resetSliders()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: targetSize.width, height: 120)
    }
    
    private func getClosestView(near point: CGPoint) -> UIView {
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
    
    private func getClosestView(by tag: Int) -> CGPoint {
        let element = stackViewElements[tag]
        return element.center
    }
    
    private func updateLabel() {
        
        var leftSide = ""
        var rightSide = ""
        
        switch leftSliderTagValue {
        case 0:
            leftSide = "X"
        case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11:
            leftSide = String(leftSliderTagValue - 1)
        default:
            leftSide = "10+"
        }
        
        switch rightSliderTagValue {
        case 0:
            rightSide = "X"
        case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11:
            rightSide = String(rightSliderTagValue - 1)
        default:
            rightSide = "10+"
        }
        
        if leftSliderTagValue == rightSliderTagValue {
            filterLabel.text = "= \(rightSide)"
        } else {
            filterLabel.text = String(leftSide + " - " + rightSide)
        }
        
        sliderTableViewModel = [leftSide, rightSide]
    }
    
    private func resetSliders() {
        leftSliderTagValue = 6
        rightSliderTagValue = 6
        resetLabel()
        
        sliderTableViewModel = []
        
        dragLeftButton.center.x = getClosestView(by: leftSliderTagValue).x + stackViewLeftPadding
        dragRightButton.center.x = getClosestView(by: rightSliderTagValue).x + stackViewLeftPadding
        
        clearButton.isHidden = true
        
        regenerateBackgroundFrames(reset: true)
    }
    
    private func resetLabel() {
        filterLabel.text = ""
    }
    
    private func regenerateBackgroundFrames(reset: Bool = false) {
        var newFrame = dragBackground.frame
        newFrame.origin.x = dragLeftButton.center.x - dragLeftButton.frame.width
        let newWidth = dragRightButton.center.x - dragLeftButton.center.x + (dragRightButton.frame.width * 2)
        newFrame.size.width = newWidth
        
        if reset {
            dragBackground.frame = newFrame
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.dragBackground.frame = newFrame
            }
        }
        
        var newButtonsBackgroundFrame = buttonsBackground.frame
        newButtonsBackgroundFrame.origin.x = dragLeftButton.center.x - dragLeftButton.frame.width / 2
        let newButtonsBackgroundWidth = dragRightButton.center.x - dragLeftButton.center.x + dragRightButton.frame.width
        newButtonsBackgroundFrame.size.width = newButtonsBackgroundWidth
        
        if reset {
            buttonsBackground.frame = newButtonsBackgroundFrame
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.buttonsBackground.frame = newButtonsBackgroundFrame
            }
        }

        if reset {
            dragBackground.center.x = getClosestView(by: leftSliderTagValue).x + stackViewLeftPadding
            buttonsBackground.center.x = getClosestView(by: leftSliderTagValue).x + stackViewLeftPadding
        }
    }
}

extension SliderTableViewCell {
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: clearAllNotification, object: nil, queue: .main) { [weak self] _ in
            DispatchQueue.main.async {
                self?.resetSliders()
            }
        }
    }
}

