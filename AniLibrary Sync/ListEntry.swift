//
//  ListEntry.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/02.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Foundation
struct ListEntry {
    let idnum : Int
    let title : String
    let watchedepisodes : Int
    let score : Float?
    let entrynotes : String?
    let rewatching : Bool?
    let rewatchcount : Int?
    let entrytype : Int
}

enum entrytype {
    case MyAnimeList
    case Kitsu
    case AniList
}
