//
//  ListEntry.swift
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/02.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

import Foundation
struct ListEntry {
    var idnum : Int
    var title : String
    var watchedepisodes : Int
    var watchedstatus : String
    var score : Float?
    var entrynotes : String?
    var rewatching : Bool?
    var rewatchcount : Int?
    var entrytype : String
    
    init(idnumber:Int, showtitle: String, wepisodes: Int, wstatus: String, etype: String) {
        self.idnum = idnumber
        self.title = showtitle
        self.watchedepisodes = wepisodes
        self.watchedstatus = wstatus
        self.entrytype = etype
    }
}
