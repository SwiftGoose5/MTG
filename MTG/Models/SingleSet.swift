//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

// MARK: - Set
struct SingleSet: Codable {
    let object, id, code, mtgoCode: String?
    let arenaCode: String?
    let tcgplayerID: Int?
    let name: String?
    let uri, scryfallURI, searchURI: String?
    let releasedAt, setType: String?
    let cardCount, printedSize: Int?
    let digital, nonfoilOnly, foilOnly: Bool?
    let blockCode, block: String?
    let iconSVGURI: String?

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
        case printedSize = "printed_size"
        case digital
        case nonfoilOnly = "nonfoil_only"
        case foilOnly = "foil_only"
        case blockCode = "block_code"
        case block
        case iconSVGURI = "icon_svg_uri"
    }
}
