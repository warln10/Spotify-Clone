//
//  AlbumResponse.swift
//  SpotifyClone
//
//  Created by Warln on 24/04/22.
//

import Foundation

struct AlbumsDetailResponse: Decodable {
    let album_type: String
    let artists: [Artists]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [ApiImg]
    let name: String
    let total_tracks: Int
    let tracks: TrackResponse
}

struct TrackResponse: Decodable {
    let items: [AudioTrack]
}


