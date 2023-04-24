//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            
            guard layoutAttribute.representedElementCategory == .cell else { return }
            
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}

class RightAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        minimumInteritemSpacing = 2.0
        itemSize = CGSize(width: 26, height: 26)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        minimumInteritemSpacing = 2.0
        itemSize = CGSize(width: 26, height: 26)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        // Reverse the order of the attributes array
        let reversedAttributes = attributes?.reversed()

        var rightMargin = collectionViewContentSize.width - sectionInset.right
        var maxY: CGFloat = -1.0

        reversedAttributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else { return }

            if layoutAttribute.frame.origin.y >= maxY {
                rightMargin = collectionViewContentSize.width - sectionInset.right
            }

            rightMargin -= layoutAttribute.frame.width + minimumInteritemSpacing
            layoutAttribute.frame.origin.x = rightMargin
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return reversedAttributes?.reversed()
    }
}
