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

struct OneCardSearchViewModel {
    
    var card: Card?
    var cardManaCost: String?
    var cardManaCostSymbols: [UIImage?]
    
    init(card: Card?, cardManaCost: String?, cardManaCostSymbols: [UIImage?]) {
        self.card = card
        self.cardManaCost = cardManaCost
        self.cardManaCostSymbols = cardManaCostSymbols
    }
    
}

struct ManyCardSearchViewModel {
    
    var cards: [Card?]
    var cardManaCost: String?
    var cardManaCostSymbols: [UIImage?]
    
    init(cards: [Card?], cardManaCost: String?, cardManaCostSymbols: [UIImage?]) {
        self.cards = cards
        self.cardManaCost = cardManaCost
        self.cardManaCostSymbols = cardManaCostSymbols
    }
    
}
