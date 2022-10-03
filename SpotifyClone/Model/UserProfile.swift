//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import Foundation

struct UserProfileResponse: Decodable {
    let country: String
    let display_name: String
    let explicit_content: ExplicitCont
    let external_urls: ExternalURL
    let followers: FollowersResp
    let href: String
    let id: String
    let images: [ApiImg]
    let product: String
    let type: String
    let uri: String
}

struct ExplicitCont: Decodable {
    let filter_enabled: Bool
    let filter_locked: Bool
}

struct ExternalURL: Decodable {
    let spotify: String
}

struct FollowersResp: Decodable {
    let total: Int
}

struct ApiImg: Decodable {
    let url: String
}




