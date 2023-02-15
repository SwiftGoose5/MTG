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
import SVGKit

let BASE_URL = "https://api.scryfall.com"
let SVG_URL = "https://svgs.scryfall.io"

enum CardPaths: String {
    case RandomCard = "/cards/random"
    case CardsNamed = "/cards/named?fuzzy="
    
    case Symbols = "/symbology/"
    case CardSymbols = "/card-symbols/"
    
    case Catalog = "/catalog"
    case CreatureTypes = "/creature-types"
    case PlaneswalkerTypes = "/planeswalker-types"
    case LandTypes = "/land-types"
    case ArtifactTypes = "/artifact-types"
    case EnchantmentTypes = "/enchantment-types"
    case SpellTypes = "/spell-types"
    
}

enum APIError: Error {
    case failedToCreateURL
    case failedToCreateData
    case failedToGenerateImage
    case failedToCreateCardFromData
}

public struct ScryfallAPI {
    
    static func getRandomCard() async -> Result<Card, Error> {
        
        guard let url = URL(string: BASE_URL + CardPaths.RandomCard.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let card = try JSONDecoder().decode(Card.self, from: data)
            return .success(card)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getOneCard(from query: String) async -> Result<Card, Error> {
        
        guard let url = URL(string: BASE_URL + CardPaths.CardsNamed.rawValue + query) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let card = try JSONDecoder().decode(Card.self, from: data)
            return .success(card)
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getCardsNamed(_ name: String) async -> Result<Card, Error> {
        
        guard let url = URL(string: BASE_URL + CardPaths.CardsNamed.rawValue + name) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let card = try JSONDecoder().decode(Card.self, from: data)
            return .success(card)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getCardImage(from url: String) async -> Result<UIImage, Error> {
        
        guard let url = URL(string: url) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else { return .failure(APIError.failedToGenerateImage) }
            return .success(image)
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getOneSymbol(symbol: String) async -> Result<UIImage, Error> {
        
        let symbolBase = symbol.parseManaSymbols()
        
        guard let url = URL(string: SVG_URL + CardPaths.CardSymbols.rawValue + symbolBase + ".svg") else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let receivedImage: SVGKImage = SVGKImage(data: data) else { return .failure(APIError.failedToGenerateImage) }
            
//            guard let image = UIImage(data: data) else { return .failure(APIError.failedToGenerateImage) }
            
            return .success(receivedImage.uiImage)
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getAllSymbols() async -> Result<Symbols, Error> {
        
        guard let url = URL(string: BASE_URL + CardPaths.Symbols.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let symbols = try JSONDecoder().decode(Symbols.self, from: data)
            return .success(symbols)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
}


// MARK: - Types API Calls
extension ScryfallAPI {
    static func getCreatureTypes() async -> Result<Subtype, Error> {
        guard let url = URL(string: BASE_URL + CardPaths.Catalog.rawValue + CardPaths.CreatureTypes.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let symbols = try JSONDecoder().decode(Subtype.self, from: data)
            return .success(symbols)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getPlaneswalkerTypes() async -> Result<Subtype, Error> {
        guard let url = URL(string: BASE_URL + CardPaths.Catalog.rawValue + CardPaths.PlaneswalkerTypes.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let symbols = try JSONDecoder().decode(Subtype.self, from: data)
            return .success(symbols)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getLandTypes() async -> Result<Subtype, Error> {
        guard let url = URL(string: BASE_URL + CardPaths.Catalog.rawValue + CardPaths.LandTypes.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let symbols = try JSONDecoder().decode(Subtype.self, from: data)
            return .success(symbols)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getArtifactTypes() async -> Result<Subtype, Error> {
        guard let url = URL(string: BASE_URL + CardPaths.Catalog.rawValue + CardPaths.ArtifactTypes.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let symbols = try JSONDecoder().decode(Subtype.self, from: data)
            return .success(symbols)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getEnchantmentTypes() async -> Result<Subtype, Error> {
        guard let url = URL(string: BASE_URL + CardPaths.Catalog.rawValue + CardPaths.EnchantmentTypes.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let symbols = try JSONDecoder().decode(Subtype.self, from: data)
            return .success(symbols)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getSpellTypes() async -> Result<Subtype, Error> {
        guard let url = URL(string: BASE_URL + CardPaths.Catalog.rawValue + CardPaths.SpellTypes.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let symbols = try JSONDecoder().decode(Subtype.self, from: data)
            return .success(symbols)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
}
