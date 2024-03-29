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
    case CardsSearch = "/cards/search?"
    
    case Symbols = "/symbology/"
    case CardSymbols = "/card-symbols/"
    
    case Catalog = "/catalog"
    case CreatureTypes = "/creature-types"
    case PlaneswalkerTypes = "/planeswalker-types"
    case LandTypes = "/land-types"
    case ArtifactTypes = "/artifact-types"
    case EnchantmentTypes = "/enchantment-types"
    case SpellTypes = "/spell-types"
    
    case Sets = "/sets"
    
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
    
    static func getManyCards(from query: String) async -> Result<Cards, Error> {
        
        let queryProcessed = query.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "+")
        let fullQuery = "order=name&q=\(queryProcessed)&unique=art"
        
        guard let url = URL(string: BASE_URL + CardPaths.CardsSearch.rawValue + fullQuery) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let card = try JSONDecoder().decode(Cards.self, from: data)
            return .success(card)
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getManyCards(from searchModels: AdvancedCardSearchModel) async -> Result<Cards, Error> {
        
        var firstParameter = true
        var query = "order=name&q="
        
        // MARK: - Card name
        if !searchModels.cardNameSearchModel.isEmpty {
            for model in searchModels.cardNameSearchModel {
                if query.last != "+" && !firstParameter {
                    query.append(contentsOf: "+")
                }
                
                switch model.searchFilter {
                case "IS", "OR":
                    query.append(contentsOf: model.searchTerm.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "+"))
                    
                case "NOT":
                    query.append(contentsOf: String("-" + model.searchTerm.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "+-")))
                    
                default:
                    break
                }
            }
            firstParameter = false
        }
        // MARK: - Super types
        if !searchModels.superTypesSearchModel.isEmpty {
            for model in searchModels.superTypesSearchModel {
                if query.last != "+" && !firstParameter {
                    query.append(contentsOf: "+")
                }
                
                switch model.searchFilter {
                case "IS", "OR":
                    query.append(contentsOf: String("type:" + model.searchTerm))
                    
                case "NOT":
                    query.append(contentsOf: String("-type:" + model.searchTerm))
                    
                default:
                    break
                }
            }
            firstParameter = false
        }
        // MARK: - Subtypes
        if !searchModels.subTypesSearchModel.isEmpty {
            for model in searchModels.subTypesSearchModel {
                if query.last != "+" && !firstParameter {
                    query.append(contentsOf: "+")
                }
                
                switch model.searchFilter {
                case "IS", "OR":
                    query.append(contentsOf: String("type:" + model.searchTerm))
                    
                case "NOT":
                    query.append(contentsOf: String("-type:" + model.searchTerm))
                    
                default:
                    break
                }
            }
            firstParameter = false
        }
        // MARK: - Color
        if !searchModels.colorSearchModel.isEmpty {
            for model in searchModels.colorSearchModel {
                if query.last != "+" && !firstParameter {
                    query.append(contentsOf: "+")
                }
                
                let searchTerm = model.searchTerm
                    .replacingOccurrences(of: "White", with: "W")
                    .replacingOccurrences(of: "Blue", with: "U")
                    .replacingOccurrences(of: "Black", with: "B")
                    .replacingOccurrences(of: "Red", with: "R")
                    .replacingOccurrences(of: "Green", with: "G")
                    .replacingOccurrences(of: "Colorless", with: "C")
                    .replacingOccurrences(of: ", ", with: "")
                
                switch model.searchFilter {
                case "INCLUDES":
                    query.append(contentsOf: String("color%3E%3D" + searchTerm))
                    
                case "EXCLUDES":
                    query.append(contentsOf: String("-color=" + searchTerm))
                    
                case "EXACTLY":
                    query.append(contentsOf: String("color=" + searchTerm))
                    
                default:
                    break
                }
            }
            firstParameter = false
        }
        // MARK: - Mana
        if !searchModels.manaValueSearchModel.isEmpty {
            if query.last != "+" && !firstParameter {
                query.append(contentsOf: "+")
            }
            
            let leftSide = searchModels.manaValueSearchModel[0].replacingOccurrences(of: "+", with: "")
            let rightSide = searchModels.manaValueSearchModel[1].replacingOccurrences(of: "+", with: "")
            
            if leftSide == rightSide {
                query.append(contentsOf: String("cmc%3D" + leftSide))
            } else {
                query.append(contentsOf: String("cmc%3E%3D" + leftSide + "+"))
                query.append(contentsOf: String("cmc%3C%3D" + rightSide))
            }

            firstParameter = false
        }
        // MARK: - Power
        if !searchModels.powerSearchModel.isEmpty {
            if query.last != "+" && !firstParameter {
                query.append(contentsOf: "+")
            }
            
            let leftSide = searchModels.powerSearchModel[0].replacingOccurrences(of: "+", with: "")
            let rightSide = searchModels.powerSearchModel[1].replacingOccurrences(of: "+", with: "")
            
            if leftSide == rightSide {
                query.append(contentsOf: String("pow%3D" + leftSide))
            } else {
                query.append(contentsOf: String("pow%3E%3D" + leftSide + "+"))
                query.append(contentsOf: String("pow%3C%3D" + rightSide))
            }

            firstParameter = false
        }
        // MARK: - Toughness
        if !searchModels.toughnessSearchModel.isEmpty {
            if query.last != "+" && !firstParameter {
                query.append(contentsOf: "+")
            }
            
            let leftSide = searchModels.toughnessSearchModel[0].replacingOccurrences(of: "+", with: "")
            let rightSide = searchModels.toughnessSearchModel[1].replacingOccurrences(of: "+", with: "")
            
            if leftSide == rightSide {
                query.append(contentsOf: String("tou%3D" + leftSide))
            } else {
                query.append(contentsOf: String("tou%3E%3D" + leftSide + "+"))
                query.append(contentsOf: String("tou%3C%3D" + rightSide))
            }

            firstParameter = false
        }
        // MARK: - Sets
        if !searchModels.setsSearchModel.isEmpty {
            for model in searchModels.setsSearchModel {
                if query.last != "+" && !firstParameter {
                    query.append(contentsOf: "+")
                }
                
                let setCode = model.searchTerm.components(separatedBy: ": ")[0]
                
                switch model.searchFilter {
                case "IS", "OR":
                    query.append(contentsOf: String("set:" + setCode))
                    
                case "NOT":
                    query.append(contentsOf: String("-set:" + setCode))
                    
                default:
                    break
                }
            }
            firstParameter = false
        }
        // MARK: - Format
        if !searchModels.formatsSearchModel.isEmpty {
            for model in searchModels.formatsSearchModel {
                if query.last != "+" && !firstParameter {
                    query.append(contentsOf: "+")
                }
                
                query.append(contentsOf: String("legal:" + model))
            }
            firstParameter = false
        }
        // MARK: - Rarity
        if !searchModels.raritySearchModel.isEmpty {
            for model in searchModels.raritySearchModel {
                if query.last != "+" && !firstParameter {
                    query.append(contentsOf: "+")
                }
                
                query.append(contentsOf: String("rarity:" + model))
            }
            firstParameter = false
        }
        query.append(contentsOf: String("&unique=art"))
        
        guard let url = URL(string: BASE_URL + CardPaths.CardsSearch.rawValue + query) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let cards = try JSONDecoder().decode(Cards.self, from: data)
            return .success(cards)
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
}

// MARK: - Images API Calls
extension ScryfallAPI {
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
    
    static func getOneManaSymbol(symbol: String) async -> Result<UIImage, Error> {
        
        let symbolBase = symbol.parseManaSymbols()
        
        guard let url = URL(string: SVG_URL + CardPaths.CardSymbols.rawValue + symbolBase + ".svg") else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let receivedImage: SVGKImage = SVGKImage(data: data) else { return .failure(APIError.failedToGenerateImage) }
            return .success(receivedImage.uiImage)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getAllManaSymbols() async -> Result<Symbols, Error> {
        
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

// MARK: - Sets API Calls
extension ScryfallAPI {
    static func getSets() async -> Result<Sets, Error> {
        guard let url = URL(string: BASE_URL + CardPaths.Sets.rawValue) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let sets = try JSONDecoder().decode(Sets.self, from: data)
            return .success(sets)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
    
    static func getSetImage(of setImageUrl: String) async -> Result<UIImage, Error> {
        
        guard let url = URL(string: setImageUrl) else { return .failure(APIError.failedToCreateURL) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let receivedImage: SVGKImage = SVGKImage(data: data) else { return .failure(APIError.failedToGenerateImage) }
            
            print("getting set image")
            
            return .success(receivedImage.uiImage)
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return .failure(APIError.failedToCreateData)
        }
    }
}
