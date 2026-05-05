//
//  VideoStruct.swift
//  Blacksburg
//
//  Created by Osman Balci on 1/20/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI

struct Video: Decodable, Hashable {
    
    var title: String
    var youTubeId: String
    var releaseDate: String
    var duration: String        // hh:mm:ss
}

/*
 {
     "title": "6 Best Things to Do Near Blacksburg, VA",
     "youTubeId": "2pupdssiACs",
     "releaseDate": "2020-11-05",
     "duration": "2:49"
 }
 */
