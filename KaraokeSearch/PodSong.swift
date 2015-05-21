//
//  PodSong.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/21.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import Foundation

class PodSong: NSObject {
    var songId: Int, artistName: String, songTitle: String, albumTitle: String
    init(songId: Int, artistName: String, songTitle: String, albumTitle: String) {
        self.songId = songId
        self.artistName = artistName
        self.songTitle = songTitle
        self.albumTitle = albumTitle
    }
}