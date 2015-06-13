//
//  SetList.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/20.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import Foundation
import CoreData

class SetList: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var createdAt: NSDate
    @NSManaged var updatedAt: NSDate

}
