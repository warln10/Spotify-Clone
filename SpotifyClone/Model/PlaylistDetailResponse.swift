//
//  PlaylistDetailResponse.swift
//  SpotifyClone
//
//  Created by Warln on 24/04/22.
//

import Foundation

struct PlaylistDetailResponse: Decodable {
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [ApiImg]
    let name: String
    let tracks: TracksItem
    let type: String
    let uri: String
}


struct TracksItem: Decodable {
    let items: [TracksList]
}

struct TracksList: Decodable {
    let track: AudioTrack
}


