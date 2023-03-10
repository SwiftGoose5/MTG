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

struct ScryfallInteractor {
    
    static func getOneCard(from searchText: String) async -> Card? {
        
        var card: Card?
        
        let result = await ScryfallAPI.getOneCard(from: searchText)
        
        switch result {
            case .success(let tempCard):
                card = tempCard
                
            case .failure(_):
                card = nil
        }
        
        if (card?.name) != nil {
            return card
        } else {
            return nil
        }
    }
    
    static func getCards(from searchText: String) async -> Card? {
        
        var card: Card?
        
        let result = await ScryfallAPI.getRandomCard()
        
        switch result {
            case .success(let tempCard):
                card = tempCard
                
            case .failure(_):
                card = nil
        }
        
        return card
    }
    
    static func getRandomCard() async -> Card? {
        
        var card: Card?
        
        let result = await ScryfallAPI.getRandomCard()
        
        switch result {
            case .success(let tempCard):
                card = tempCard
                
            case .failure(_):
                card = nil
        }
        
        return card
    }
    
    static func getCardManaSymbols(from card: Card) async -> [UIImage?] {
        
        var manaImages: [UIImage?] = []
        
        guard let manaCost = card.manaCost else { return manaImages }
        
        for manaSymbol in manaCost.parseManaSymbols() {
            let result = await ScryfallAPI.getOneSymbol(symbol: String(manaSymbol))
            
            switch result {
            case .success(let image):
                manaImages.append(image)
                
            case .failure(let error):
                print("Image Conversion Error: \(error.localizedDescription)")
            }
        }
        
        return manaImages
    }
}


// MARK: - Types Calls
extension ScryfallInteractor {
    static func getCreatureTypes() async -> [String] {
        let result = await ScryfallAPI.getCreatureTypes()
        
        switch result {
        case .success(let subtype):
            guard let subtypes = subtype.data else { return [] }
            return subtypes
            
        case .failure(let error):
            print("Creature Type Error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func getPlaneswalkerTypes() async -> [String] {
        let result = await ScryfallAPI.getPlaneswalkerTypes()
        
        switch result {
        case .success(let subtype):
            guard let subtypes = subtype.data else { return [] }
            return subtypes
            
        case .failure(let error):
            print("Creature Type Error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func getLandTypes() async -> [String] {
        let result = await ScryfallAPI.getLandTypes()
        
        switch result {
        case .success(let subtype):
            guard let subtypes = subtype.data else { return [] }
            return subtypes
            
        case .failure(let error):
            print("Creature Type Error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func getArtifactTypes() async -> [String] {
        let result = await ScryfallAPI.getArtifactTypes()
        
        switch result {
        case .success(let subtype):
            guard let subtypes = subtype.data else { return [] }
            return subtypes
            
        case .failure(let error):
            print("Creature Type Error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func getEnchantmentTypes() async -> [String] {
        let result = await ScryfallAPI.getEnchantmentTypes()
        
        switch result {
        case .success(let subtype):
            guard let subtypes = subtype.data else { return [] }
            return subtypes
            
        case .failure(let error):
            print("Creature Type Error: \(error.localizedDescription)")
            return []
        }
    }
    
    static func getSpellTypes() async -> [String] {
        let result = await ScryfallAPI.getSpellTypes()
        
        switch result {
        case .success(let subtype):
            guard let subtypes = subtype.data else { return [] }
            return subtypes
            
        case .failure(let error):
            print("Creature Type Error: \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - Sets Calls
extension ScryfallInteractor {
    static func getSets() async -> [String] {
        let result = await ScryfallAPI.getSets()
        
        switch result {
        case .success(let sets):
            guard let sets = sets.data else { return [] }
            
            var allSets: [String] = []
            
            for set in sets {
                allSets.append(set.name!)
            }
            return allSets
            
        case .failure(let error):
            print("Creature Type Error: \(error.localizedDescription)")
            return []
        }
    }
    static func getSetsWithSymbols() async -> [SetsTableViewModel] {
        let result = await ScryfallAPI.getSets()
        
        switch result {
        case .success(let sets):
            guard let sets = sets.data else { return [] }
            
            var allSets: [SetsTableViewModel] = []
            
//            for set in sets {
//                let result = await ScryfallAPI.getSetImage(of: set.iconSVGURI!)
//                var setImage: UIImage? = nil
//
//                switch result {
//                case .success(let image):
//                    setImage = image
//                case .failure(let error):
//                    setImage = nil
//                    print(error.localizedDescription)
//                }
//
//
//            }
            for oneSet in sets {
                allSets.append(SetsTableViewModel(setCode: oneSet.code!, setName: oneSet.name!))
            }
            
            return allSets
            
        case .failure(let error):
            print("Creature Type Error: \(error.localizedDescription)")
            return []
        }
    }
}
