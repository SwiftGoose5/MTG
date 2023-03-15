//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let card = try? JSONDecoder().decode(Card.self, from: jsonData)

import Foundation

// MARK: - Card
struct Card: Codable {
    let object, id, oracleID: String?
    let multiverseIDS: [Int]?
    let mtgoID, arenaID, tcgplayerID, cardmarketID: Int?
    let name, lang, releasedAt: String?
    let uri, scryfallURI: String?
    let layout: String?
    let highresImage: Bool?
    let imageStatus: String?
    let imageUris: ImageUris?
    let manaCost: String?
    let cmc: Int?
    let typeLine, oracleText: String?
    let power, toughness: String?
    let colors, colorIdentity: [String]?
    let keywords, producedMana: [String]?
    let allParts: [AllPart]?
    let legalities: Legalities?
    let games: [String]?
    let reserved, foil, nonfoil: Bool?
    let finishes: [String]?
    let oversized, promo, reprint, variation: Bool?
    let setID, cardSet, setName, setType: String?
    let setURI, setSearchURI, scryfallSetURI, rulingsURI: String?
    let printsSearchURI: String?
    let collectorNumber: String?
    let digital: Bool?
    let rarity, cardBackID, artist: String?
    let artistIDS: [String]?
    let illustrationID, borderColor, frame: String?
    let fullArt, textless, booster, storySpotlight: Bool?
    let edhrecRank, pennyRank: Int?
    let prices: Prices?
    let relatedUris: RelatedUris?
    let purchaseUris: PurchaseUris?

    enum CodingKeys: String, CodingKey {
        case object, id
        case oracleID = "oracle_id"
        case multiverseIDS = "multiverse_ids"
        case mtgoID = "mtgo_id"
        case arenaID = "arena_id"
        case tcgplayerID = "tcgplayer_id"
        case cardmarketID = "cardmarket_id"
        case name, lang
        case releasedAt = "released_at"
        case uri
        case scryfallURI = "scryfall_uri"
        case layout
        case power, toughness
        case highresImage = "highres_image"
        case imageStatus = "image_status"
        case imageUris = "image_uris"
        case manaCost = "mana_cost"
        case cmc
        case typeLine = "type_line"
        case oracleText = "oracle_text"
        case colors
        case colorIdentity = "color_identity"
        case keywords
        case producedMana = "produced_mana"
        case allParts = "all_parts"
        case legalities, games, reserved, foil, nonfoil, finishes, oversized, promo, reprint, variation
        case setID = "set_id"
        case cardSet = "set"
        case setName = "set_name"
        case setType = "set_type"
        case setURI = "set_uri"
        case setSearchURI = "set_search_uri"
        case scryfallSetURI = "scryfall_set_uri"
        case rulingsURI = "rulings_uri"
        case printsSearchURI = "prints_search_uri"
        case collectorNumber = "collector_number"
        case digital, rarity
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
    }
}

// MARK: - AllPart
struct AllPart: Codable {
    let object, id, component, name: String?
    let typeLine: String?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case object, id, component, name
        case typeLine = "type_line"
        case uri
    }
}

// MARK: - ImageUris
struct ImageUris: Codable {
    let small, normal, large: String?
    let png: String?
    let artCrop, borderCrop: String?

    enum CodingKeys: String, CodingKey {
        case small, normal, large, png
        case artCrop = "art_crop"
        case borderCrop = "border_crop"
    }
}

// MARK: - Legalities
struct Legalities: Codable {
    let standard, future, historic, gladiator: String?
    let pioneer, explorer, modern, legacy: String?
    let pauper, vintage, penny, commander: String?
    let brawl, historicbrawl, alchemy, paupercommander: String?
    let duel, oldschool, premodern: String?
}

// MARK: - Prices
struct Prices: Codable {
    let usd, usdFoil, usdEtched: String?
    let eur, eurFoil, tix: String?

    enum CodingKeys: String, CodingKey {
        case usd
        case usdFoil = "usd_foil"
        case usdEtched = "usd_etched"
        case eur
        case eurFoil = "eur_foil"
        case tix
    }
}

// MARK: - PurchaseUris
struct PurchaseUris: Codable {
    let tcgplayer, cardmarket, cardhoarder: String?
}

// MARK: - RelatedUris
struct RelatedUris: Codable {
    let gatherer: String?
    let tcgplayerInfiniteArticles, tcgplayerInfiniteDecks, edhrec: String?

    enum CodingKeys: String, CodingKey {
        case gatherer
        case tcgplayerInfiniteArticles = "tcgplayer_infinite_articles"
        case tcgplayerInfiniteDecks = "tcgplayer_infinite_decks"
        case edhrec
    }
}

