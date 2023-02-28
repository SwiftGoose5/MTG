//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

// MARK: - Sets
struct Sets: Codable {
    let object: String?
    let hasMore: Bool?
    let data: [Datas]?

    enum CodingKeys: String, CodingKey {
        case object
        case hasMore = "has_more"
        case data
    }
}

// MARK: - Datum
struct Datas: Codable, Comparable {
    static func < (lhs: Datas, rhs: Datas) -> Bool { lhs.name! < rhs.name! }
    
    let object: Obj?
    let id, code, mtgoCode, arenaCode: String?
    let tcgplayerID: Int?
    let name: String?
    let uri, scryfallURI, searchURI: String?
    let releasedAt: String?
    let setType: SetType?
    let cardCount: Int?
    let digital, nonfoilOnly, foilOnly: Bool?
    let iconSVGURI: String?
    let parentSetCode, blockCode, block: String?
    let printedSize: Int?

    enum CodingKeys: String, CodingKey {
        case object, id, code
        case mtgoCode = "mtgo_code"
        case arenaCode = "arena_code"
        case tcgplayerID = "tcgplayer_id"
        case name, uri
        case scryfallURI = "scryfall_uri"
        case searchURI = "search_uri"
        case releasedAt = "released_at"
        case setType = "set_type"
        case cardCount = "card_count"
        case digital
        case nonfoilOnly = "nonfoil_only"
        case foilOnly = "foil_only"
        case iconSVGURI = "icon_svg_uri"
        case parentSetCode = "parent_set_code"
        case blockCode = "block_code"
        case block
        case printedSize = "printed_size"
    }
}

enum Obj: String, Codable {
    case objectSet = "set"
}

enum SetType: String, Codable {
    case alchemy = "alchemy"
    case archenemy = "archenemy"
    case arsenal = "arsenal"
    case box = "box"
    case commander = "commander"
    case core = "core"
    case draftInnovation = "draft_innovation"
    case duelDeck = "duel_deck"
    case expansion = "expansion"
    case fromTheVault = "from_the_vault"
    case funny = "funny"
    case masterpiece = "masterpiece"
    case masters = "masters"
    case memorabilia = "memorabilia"
    case planechase = "planechase"
    case premiumDeck = "premium_deck"
    case promo = "promo"
    case spellbook = "spellbook"
    case starter = "starter"
    case token = "token"
    case treasureChest = "treasure_chest"
    case vanguard = "vanguard"
}
