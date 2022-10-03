//
//  RecommendedResponse.swift
//  SpotifyClone
//
//  Created by Warln on 31/03/22.
//

import Foundation

struct RecommendedResponse: Decodable {
    let tracks: [AudioTrack]
}

struct AudioTrack: Decodable {
    let album: Albums?
    let artists: [Artists]
    let available_markets: [String]?
    let disc_number: Int
    let duration_ms: Double
    let explicit: Bool
    let href: String
    let id: String
    let is_local: Bool
    let name: String
    let track_number: Int
    let type: String
    let uri: String
}

