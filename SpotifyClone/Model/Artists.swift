//
//  Artists.swift
//  SpotifyClone
//
//  Created by Warln on 10/04/22.
//

import Foundation

struct Artists: Decodable {
    let external_urls: [String:String]
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
}
