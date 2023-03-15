//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

enum PickerOptions: String {
    case ManaValue = "Mana Value"
    case Name = "Name"
    case Color = "Color"
    case Power = "Power"
    case Toughness = "Toughness"
    
    case CardSmall = "Cards - Small"
    case CardFull = "Cards - Full"
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