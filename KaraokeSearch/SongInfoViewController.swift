//
//  SongInfoViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/10.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import MaterialKit
import CoreData

class SongInfoViewController: UIViewController {
    
    var song : Song? = nil
    var favSong : FavoredSong? = nil
    var isFavored : Bool = false

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: MKLabel!
    @IBOutlet weak var songTitleLabel: MKLabel!
    @IBOutlet weak var descriptionLabel: MKLabel!
    
    @IBOutlet weak var songFavButton: MKButton!
    @IBOutlet weak var youtubeButton: MKButton!
    @IBOutlet weak var lyricsButton: MKButton!
    
    
    func initializeSubjectLabel() {
        artistLabel.textColor = UIColor.StaticLabelTextColor()
        songLabel.textColor = UIColor.StaticLabelTextColor()
        descLabel.textColor = UIColor.StaticLabelTextColor()
        
        artistLabel.text = "Artist (ID: \(song!.artistId))"
        songLabel.text = "Title (ID: \(song!.songId))"
    }
    
    func initializeInfoLabel() {
        artistNameLabel.textColor = UIColor.LabelTextColor()
        songTitleLabel.textColor = UIColor.LabelTextColor()
        descriptionLabel.textColor = UIColor.LabelTextColor()
        
        artistNameLabel.text = song?.artistName
        songTitleLabel.text = song?.songTitle
        descriptionLabel.text = song?.createdAt.componentsSeparatedByString("T")[0]
    }
    
    func setFavButton(isFavored: Bool) {
        //songFavButton.tintColor = UIColor.yellowColor()
        
        if isFavored {
            songFavButton.setAttributedTitle(NSAttributedString(string: "★", attributes: [NSForegroundColorAttributeName : UIColor.orangeColor()]) , forState: .Normal)
        } else {
            songFavButton.setAttributedTitle(NSAttributedString(string: "☆", attributes: [NSStrokeColorAttributeName : UIColor.orangeColor(), NSStrokeWidthAttributeName : 2]) , forState: .Normal)
        }
    }
    
    func initializeFavInfo() {
        
        let predicate = NSPredicate(format: "songId = %d", song!.songId)
        favSong = FavoredSong.by(predicate).find().firstObject() as? FavoredSong
        isFavored = favSong != nil
        
        println("\(favSong?.songId) : \(song?.songId)")
        setFavButton(favSong != nil)
    }
    
    func initializeSubInfo() {
        youtubeButton.enabled = false
        lyricsButton.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = song?.songTitle
        
        initializeSubjectLabel()
        initializeInfoLabel()
        initializeFavInfo()
        initializeSubInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertFavoredSong(song: Song!) -> FavoredSong{
        
        var favoriteSong: FavoredSong = FavoredSong.create() as! FavoredSong
        favoriteSong.id = song.id
        favoriteSong.artistId = song.artistId
        favoriteSong.artistName = song.artistName
        favoriteSong.songId = song.songId
        favoriteSong.songTitle = song.songTitle
        favoriteSong.registeredAt = song.createdAt
        favoriteSong.favoredAt = NSDate()
        favoriteSong.favoredFlg = 1
        
        let saved: Bool = favoriteSong.save()
        
        return favoriteSong
    }
    
    func deleteFavoredSong(fSong: FavoredSong!) {
        fSong.beginWriting().delete().endWriting()
    }
    
    @IBAction func clickFavorite(sender: AnyObject) {
        if (favSong != nil) {
            deleteFavoredSong(favSong)
            favSong = nil
        } else {
            //favSong = FavoredSong()
            favSong = insertFavoredSong(song!)
        }
        
        isFavored = !isFavored
        setFavButton(isFavored)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
