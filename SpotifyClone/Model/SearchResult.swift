//
//  SearchResult.swift
//  SpotifyClone
//
//  Created by Warln on 29/05/22.
//

import Foundation

enum SearchResult {
    case Album(model: Albums)
    case Playlist(model: Playlist)
    case track(model: AudioTrack)
    case artist(model: Artists)
}
