//
//  SearchResultResponse.swift
//  SpotifyClone
//
//  Created by Warln on 29/05/22.
//

import Foundation

struct SearchResultResponse: Decodable {
    let albums: SearchResultAlbum
    let artists: SearchResultArtists
    let playlists: SearchResultPlaylists
    let tracks: SearchResultTracks
}

struct SearchResultAlbum: Decodable {
    let items: [Albums]
}

struct SearchResultArtists: Decodable {
    let items: [Artists]
}

struct SearchResultPlaylists: Decodable {
    let items: [Playlist]
}

struct SearchResultTracks: Decodable {
    let items: [AudioTrack]
}




