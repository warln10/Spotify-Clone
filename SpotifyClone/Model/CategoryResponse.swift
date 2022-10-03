//
//  CategoryResponse.swift
//  SpotifyClone
//
//  Created by Warln on 23/05/22.
//

import Foundation

struct CategoryResponse: Decodable {
    let categories : Categories
}

struct Categories: Decodable {
    let items: [Category]
}

struct Category: Decodable {
    let icons: [ApiImg]
    let id: String
    let name: String
}

