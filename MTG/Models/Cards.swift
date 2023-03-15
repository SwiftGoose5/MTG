//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

// MARK: - Cards
struct Cards: Codable {
    let object: String?
    let totalCards: Int?
    let hasMore: Bool?
    let data: [Card]?

    enum CodingKeys: String, CodingKey {
        case object
        case totalCards = "total_cards"
        case hasMore = "has_more"
        case data
    }
}

enum Alchemy: String, Codable {
    case legal = "legal"
    case notLegal = "not_legal"
}

enum Paupercommander: String, Codable {
    case notLegal = "not_legal"
    case restricted = "restricted"
}

// MARK: - Preview
struct Preview: Codable {
    let source: String?
    let sourceURI: String?
    let previewedAt: String?

    enum CodingKeys: String, CodingKey {
        case source
        case sourceURI = "source_uri"
        case previewedAt = "previewed_at"
    }
}
