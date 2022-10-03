//
//  AuthResponse.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import Foundation

struct AuthResponse : Decodable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
