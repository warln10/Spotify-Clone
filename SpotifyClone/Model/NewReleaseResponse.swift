//
//  NewReleaseResponse.swift
//  SpotifyClone
//
//  Created by Warln on 31/03/22.
//

import Foundation

struct NewReleaseResponse: Decodable {
    let albums: AlbumResponse
}

struct AlbumResponse: Decodable {
    let href: String
    let items: [Albums]
}

struct Albums: Decodable {
    let album_type: String
    let artists: [Artists]
    let available_markets: [String]
    let id: String
    let images: [ApiImg]
    let name: String
    let release_date: String
    let total_tracks: Int
    let type: String
    let uri: String
}


