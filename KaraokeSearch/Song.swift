//
//  Song.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/09.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import Foundation

class Song: NSObject {
    var id: Int, artistId: Int, artistName: String, artistNameSearch: String, songId: Int, songTitle: String, songTitleSearch: String, createdAt: String, updatedAt: String
    
    init(id: Int, artistId: Int, artistName: String, artistNameSearch: String, songId: Int, songTitle: String, songTitleSearch: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.artistId = artistId
        self.artistName = artistName
        self.artistNameSearch = artistNameSearch
        self.songId = songId
        self.songTitle = songTitle
        self.songTitleSearch = songTitleSearch
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}