//
//  PodSongTableViewCell.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/21.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import MaterialKit

protocol PodSongTableViewCellDelegate{
    func selectSong(song: PodSong)
}

class PodSongTableViewCell: MKTableViewCell {

    @IBOutlet weak var artistLabel: MKLabel!
    @IBOutlet weak var songLabel: MKLabel!
    
    var song: PodSong! = nil
    var delegate: PodSongTableViewCellDelegate! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // UILabelとかを追加
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(song: PodSong, atIndexPath indexPath: NSIndexPath){
        
        self.song = song;
        
        artistLabel.textColor = UIColor.MainDarkColor()
        songLabel.textColor = UIColor.MainDarkColor()
        
        artistLabel.text = song.artistName
        songLabel.text = song.songTitle
        
        self.rippleLocation = .TapLocation
        self.rippleLayerColor = UIColor.MainLightColor()
        self.selectionStyle = .None
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        //delegate.selectSong(self.song)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //super.touchesBegan(touches, withEvent: event)
        delegate.selectSong(self.song)
        super.touchesEnded(touches, withEvent: event)
    }
    
}