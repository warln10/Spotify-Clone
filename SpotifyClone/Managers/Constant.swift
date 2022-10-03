//
//  Constant.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import Foundation

struct Constant {
    static let BASE_URl                 = "https://accounts.spotify.com"
    static let Client_Id                = "936c990844cb4c5980a05f9cfad02bbb"
    static let Client_Secret            = "0a78269c5c3a444abd897d5f3c2be52e"
    static let redirect_uri             = "https://localhost:8888/callback"
    static let appToken                 = "/api/token"
    static let scope                    = "user-read-private%20ugc-image-upload%20user-read-playback-state%20user-modify-playback-state%20user-read-currently-playing%20user-follow-modify%20user-follow-read%20user-library-modify%20user-library-read%20streaming%20app-remote-control%20user-read-playback-position%20user-top-read%20user-read-recently-played%20playlist-modify-private%20playlist-read-collaborative%20playlist-read-private%20playlist-modify-public"
    static let BASE_URL2                = "https://api.spotify.com/v1/"
    static let profile                  = "me"
    static let NewRelease_Api           = "browse/new-releases?limit=50"
    static let FeaturePlay_Api          = "browse/featured-playlists?limit=20"
    static let Seed_Api                 = "recommendations/available-genre-seeds"
}
