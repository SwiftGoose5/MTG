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
