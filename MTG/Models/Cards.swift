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
    let data: [Datum]?

    enum CodingKeys: String, CodingKey {
        case object
        case totalCards = "total_cards"
        case hasMore = "has_more"
        case data
    }
}

// MARK: - Datum
struct Datum: Codable {
    let object, id, oracleID: String?
    let multiverseIDS: [Int]?
    let mtgoID, mtgoFoilID, tcgplayerID, cardmarketID: Int?
    let name, lang: String?
    let releasedAt: String?
    let uri, scryfallURI: String?
    let layout: String?
    let highresImage: Bool?
    let imageStatus: String?
    let imageUris: ImageUris?
    let manaCost: String?
    let cmc: Int?
    let typeLine, oracleText, power, toughness: String?
    let colors, colorIdentity, keywords, producedMana: [String]?
    let legalities: Legalities?
    let games: [Game]?
    let reserved, foil, nonfoil: Bool?
    let finishes: [Finish]?
    let oversized, promo, reprint, variation: Bool?
    let setID, datumSet, setName, setType: String?
    let setURI, setSearchURI, scryfallSetURI, rulingsURI: String?
    let printsSearchURI: String?
    let collectorNumber: String?
    let digital: Bool?
    let rarity: Rarity?
    let flavorText, cardBackID, artist: String?
    let artistIDS: [String]?
    let illustrationID: String?
    let borderColor: BorderColor?
    let frame: String?
    let fullArt, textless, booster, storySpotlight: Bool?
    let edhrecRank, pennyRank: Int?
    let prices: [String: String?]?
    let relatedUris: RelatedUris?
    let purchaseUris: PurchaseUris?
    let watermark, securityStamp: String?
    let arenaID: Int?
    let preview: Preview?
    let frameEffects: [String]?
    let allParts: [AllPart]?

    enum CodingKeys: String, CodingKey {
        case object, id
        case oracleID = "oracle_id"
        case multiverseIDS = "multiverse_ids"
        case mtgoID = "mtgo_id"
        case mtgoFoilID = "mtgo_foil_id"
        case tcgplayerID = "tcgplayer_id"
        case cardmarketID = "cardmarket_id"
        case name, lang
        case releasedAt = "released_at"
        case uri
        case scryfallURI = "scryfall_uri"
        case layout
        case highresImage = "highres_image"
        case imageStatus = "image_status"
        case imageUris = "image_uris"
        case manaCost = "mana_cost"
        case cmc
        case typeLine = "type_line"
        case oracleText = "oracle_text"
        case power, toughness, colors
        case colorIdentity = "color_identity"
        case keywords, legalities, games, reserved, foil, nonfoil, finishes, oversized, promo, reprint, variation
        case producedMana = "produced_mana"
        case setID = "set_id"
        case datumSet = "set"
        case setName = "set_name"
        case setType = "set_type"
        case setURI = "set_uri"
        case setSearchURI = "set_search_uri"
        case scryfallSetURI = "scryfall_set_uri"
        case rulingsURI = "rulings_uri"
        case printsSearchURI = "prints_search_uri"
        case collectorNumber = "collector_number"
        case digital, rarity
        case flavorText = "flavor_text"
        case cardBackID = "card_back_id"
        case artist
        case artistIDS = "artist_ids"
        case illustrationID = "illustration_id"
        case borderColor = "border_color"
        case frame
        case fullArt = "full_art"
        case textless, booster
        case storySpotlight = "story_spotlight"
        case edhrecRank = "edhrec_rank"
        case pennyRank = "penny_rank"
        case prices
        case relatedUris = "related_uris"
        case purchaseUris = "purchase_uris"
        case watermark
        case securityStamp = "security_stamp"
        case arenaID = "arena_id"
        case preview
        case frameEffects = "frame_effects"
        case allParts = "all_parts"
    }
}

enum BorderColor: String, Codable {
    case black = "black"
}

enum Finish: String, Codable {
    case foil = "foil"
    case nonfoil = "nonfoil"
}

enum Game: String, Codable {
    case arena = "arena"
    case mtgo = "mtgo"
    case paper = "paper"
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
