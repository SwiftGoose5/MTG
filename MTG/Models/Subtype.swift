//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import Foundation

// MARK: - Subtypes
struct Subtype: Codable {
    let object: String?
    let uri: String?
    let totalValues: Int?
    let data: [String]?

    enum CodingKeys: String, CodingKey {
        case object, uri
        case totalValues = "total_values"
        case data
    }
}
