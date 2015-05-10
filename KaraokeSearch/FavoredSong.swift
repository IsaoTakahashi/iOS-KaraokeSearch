//
//  FavoredSong.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/10.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import Foundation
import CoreData

class FavoredSong: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var artistId: NSNumber
    @NSManaged var songId: NSNumber
    @NSManaged var artistName: String
    @NSManaged var songTitle: String
    @NSManaged var registeredAt: String
    @NSManaged var favoredAt: NSDate
    @NSManaged var favoredFlg: NSNumber

}
