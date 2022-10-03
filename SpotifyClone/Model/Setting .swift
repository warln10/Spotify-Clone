//
//  Setting .swift
//  SpotifyClone
//
//  Created by Warln on 29/03/22.
//

import Foundation

struct Setting {
    let titles: String
    let options: [Options]
}

struct Options {
    let titles: String
    let handler: () -> Void
}
