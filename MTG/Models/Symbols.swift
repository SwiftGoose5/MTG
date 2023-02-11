//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

// MARK: - Symbols
struct Symbols: Codable {
    let object: String?
    let hasMore: Bool?
    let data: [Datum]?

    enum CodingKeys: String, CodingKey {
        case object
        case hasMore = "has_more"
        case data
    }
}

// MARK: - Datum
struct Datum: Codable {
    let object: Object?
    let symbol: String?
    let svgURI: String?
    let looseVariant: String?
    let english: String?
    let transposable, representsMana, appearsInManaCosts: Bool?
    let cmc: Double?
    let funny: Bool?
    let colors: [Color]?
    let gathererAlternates: [String]?

    enum CodingKeys: String, CodingKey {
        case object, symbol
        case svgURI = "svg_uri"
        case looseVariant = "loose_variant"
        case english, transposable
        case representsMana = "represents_mana"
        case appearsInManaCosts = "appears_in_mana_costs"
        case cmc, funny, colors
        case gathererAlternates = "gatherer_alternates"
    }
}

enum Color: String, Codable {
    case b = "B"
    case g = "G"
    case r = "R"
    case u = "U"
    case w = "W"
}

enum Object: String, Codable {
    case cardSymbol = "card_symbol"
}
