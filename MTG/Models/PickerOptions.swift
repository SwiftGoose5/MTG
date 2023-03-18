//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation
import UIKit

enum PickerOptions: String {
    case ManaValue = "Mana Value"
    case Name = "Name"
    case Color = "Color"
    case Power = "Power"
    case Toughness = "Toughness"
    
    case CardsSmall = "Cards - Small"
    case CardsFull = "Cards - Full"
    case TextCard = "Text - Card"
    case TextList = "Text - List"
    
    case Is = "IS"
    case Or = "OR"
    case Not = "NOT"
}

enum PickerIcons: String {
    case Ascending = "text.line.first.and.arrowtriangle.forward"
    case Descending = "text.line.last.and.arrowtriangle.forward"
    
    case CardsSmall = "rectangle.split.2x2"
    case CardsFull = "rectangle.portrait"
    case TextCard = "square.fill.text.grid.1x2"
    case TextList = "list.bullet"
}

enum PickerIdentifier {
    case SortStyle
    case ViewStyle
}


enum PickerNames: String {
    case ManaValue = "Mana Value"
    case Name = "Name"
    case Color = "Color"
    case Power = "Power"
    case Toughness = "Toughness"
    
    case CardsSmall = "Cards - Small"
    case CardsFull = "Cards - Full"
    case TextCard = "Text - Card"
    case TextList = "Text - List"
}

enum AttributedPickerOptions {
    case NameAscending(NSAttributedString)
    case NameDescending(NSAttributedString)
    case ColorAscending(NSAttributedString)
    case ColorDescending(NSAttributedString)
    case ManaValueAscending(NSAttributedString)
    case ManaValueDescending(NSAttributedString)
    case PowerAscending(NSAttributedString)
    case PowerDescending(NSAttributedString)
    case ToughnessAscending(NSAttributedString)
    case ToughnessDescending(NSAttributedString)
    
    var attributedString: NSAttributedString {
        switch self {
        case .NameAscending:
            return generateAttributedString(icon: .Ascending, name: .Name)
        case .NameDescending:
            return generateAttributedString(icon: .Descending, name: .Name)
        case .ColorAscending:
            return generateAttributedString(icon: .Ascending, name: .Color)
        case .ColorDescending:
            return generateAttributedString(icon: .Descending, name: .Color)
        case .ManaValueAscending:
            return generateAttributedString(icon: .Ascending, name: .ManaValue)
        case .ManaValueDescending:
            return generateAttributedString(icon: .Descending, name: .ManaValue)
        case .PowerAscending:
            return generateAttributedString(icon: .Ascending, name: .Power)
        case .PowerDescending:
            return generateAttributedString(icon: .Descending, name: .Power)
        case .ToughnessAscending:
            return generateAttributedString(icon: .Ascending, name: .Toughness)
        case .ToughnessDescending:
            return generateAttributedString(icon: .Descending, name: .Toughness)
        }
    }
    
    func generateAttributedString(icon: PickerIcons, name: PickerNames) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: icon.rawValue)
        let imageString = NSAttributedString(attachment: imageAttachment)
        let titleWithImage = NSMutableAttributedString(string: "")
        titleWithImage.append(imageString)
        titleWithImage.append(NSAttributedString(string: "  "))
        titleWithImage.append(NSAttributedString(string: name.rawValue))
        return titleWithImage
    }
}
