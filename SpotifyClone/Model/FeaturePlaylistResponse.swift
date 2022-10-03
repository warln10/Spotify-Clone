//
//  FeaturePlaylistResponse.swift
//  SpotifyClone
//
//  Created by Warln on 31/03/22.
//

import Foundation

struct FeaturePlaylistResponse: Decodable {
    let message: String?
    let playlists: FeaturePlaylist
    
}

struct FeaturePlaylist: Decodable {
    let items: [Playlist]
}

struct Playlist: Decodable {
    let description: String
    let external_urls: [String:String]
    let href: String
    let id: String
    let images: [ApiImg]
    let name: String
    let snapshot_id: String
    let tracks: FeatureTracks
    let type: String
    let owner: Owner
    let uri: String
}

struct FeatureTracks: Decodable {
    let href: String
    let total: Int
}

struct Owner: Decodable {
    let display_name: String
}

