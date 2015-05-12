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

class SongInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookmarkWebViewControllerDelegate {
    
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
    @IBOutlet weak var infoButton: MKButton!
    @IBOutlet weak var youtubeButton: MKButton!
    @IBOutlet weak var lyricsButton: MKButton!
    
    @IBOutlet weak var historyTableView: UITableView!
    
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
    
    func setButtonStyle(button: MKButton!, isActive: Bool) {
        button.maskEnabled = false
        button.ripplePercent = 0.5
        button.backgroundAniEnabled = false
        button.rippleLocation = .Center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ButtonBKColor().CGColor
        
        if isActive {
            button.backgroundColor = UIColor.ButtonBKColor()
            button.tintColor = UIColor.ButtonTextColor()
        } else {
            button.backgroundColor = UIColor.ButtonTextColor()
            button.tintColor = UIColor.ButtonBKColor()
        }
        
    }
    
    func refreshSubInfoButton() {
        if favSong != nil {
            println(favSong!.description)
            setButtonStyle(youtubeButton, isActive: !favSong!.mediaURL.isEmpty)
            setButtonStyle(lyricsButton, isActive: !favSong!.lyricsURL.isEmpty)
        } else {
            setButtonStyle(youtubeButton, isActive: false)
            setButtonStyle(lyricsButton, isActive: false)
        }
        
        setButtonStyle(infoButton, isActive: true)
    }
    
    func initializeSubInfo() {
        youtubeButton.enabled = true
        lyricsButton.enabled = true
        infoButton.enabled = true
        
        refreshSubInfoButton()
    }
    
    func initializeHistoryTable() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = song?.songTitle
        
        initializeSubjectLabel()
        initializeInfoLabel()
        initializeFavInfo()
        initializeSubInfo()
        initializeHistoryTable()
        
        historyTableView.reloadData()
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
        favoriteSong.mediaURL = ""
        favoriteSong.lyricsURL = ""
        
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
    
    // MARK -- tableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as! UITableViewCell
        
        var cellText: String = ""
        switch indexPath.row {
        case 0:
            cell.textLabel?.textColor = UIColor.grayColor()
            cellText = "History (UnderConstruction)"
            break
        case 1:
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            cellText = "Sung at 2015-04-01 18:00:00"
            break
        case 2:
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            cellText = "Faved at 2015-01-23 00:00:00"
        default:
            break
        }
        cell.textLabel?.text = cellText
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    // MARK -- bookmarkWebView
    func bookmark(urlString: String, service: String) {
        
        favSong?.beginWriting()
        
        switch service {
        case "media":
            favSong?.mediaURL = urlString
            break
        case "lyrics":
            favSong?.lyricsURL = urlString
            break
        default:
            break
        }
        
        favSong?.endWriting()
        favSong?.save()
        
        refreshSubInfoButton()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showInfoWebView") {
            let nextViewController: BookmarkWebViewController = segue.destinationViewController as! BookmarkWebViewController
            nextViewController.delegate = self
            //nextViewController.favSong = favSong
            
            nextViewController.urlString = "http://joysound.com/ex/search/song.htm?gakkyokuId=\(song!.songId)"
            nextViewController.song = song
            nextViewController.service = "info"
            nextViewController.navigationItem.title = "Info"
        } else if (segue.identifier == "showMediaWebView") {
            let nextViewController: BookmarkWebViewController = segue.destinationViewController as! BookmarkWebViewController
            nextViewController.delegate = self
            if favSong != nil {
                nextViewController.urlString = favSong!.mediaURL
                nextViewController.favSong = favSong
            } else {
                nextViewController.urlString = ""
            }
            
            nextViewController.song = song
            nextViewController.service = "media"
            nextViewController.navigationItem.title = "Media"
        } else if (segue.identifier == "showLyricsWebView") {
            let nextViewController: BookmarkWebViewController = segue.destinationViewController as! BookmarkWebViewController
            nextViewController.delegate = self
            if favSong != nil {
                nextViewController.urlString = favSong!.lyricsURL
                nextViewController.favSong = favSong
            } else {
                nextViewController.urlString = ""
            }
            nextViewController.song = song
            nextViewController.service = "lyrics"
            nextViewController.navigationItem.title = "Lyrics"
        }

    }
}
