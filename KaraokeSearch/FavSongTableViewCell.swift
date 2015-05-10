//
//  FavSongTableViewCell.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/10.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import MaterialKit

class FavSongTableViewCell: MKTableViewCell {
    
    @IBOutlet weak var artistLabel: MKLabel!
    @IBOutlet weak var songLabel: MKLabel!
    @IBOutlet weak var registeredLabel: MKLabel!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // UILabelとかを追加
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(song: Song, atIndexPath indexPath: NSIndexPath){
        
        artistLabel.textColor = UIColor.MainDarkColor()
        songLabel.textColor = UIColor.MainDarkColor()
        
        artistLabel.text = song.artistName
        songLabel.text = song.songTitle
        registeredLabel.text = song.createdAt.componentsSeparatedByString("T")[0]
        registeredLabel.textColor = UIColor.SubDarkColor()
        
        self.rippleLocation = .TapLocation
        self.rippleLayerColor = UIColor.MainLightColor()
        self.selectionStyle = .None
    }
    
}