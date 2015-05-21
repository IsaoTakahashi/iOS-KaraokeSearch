//
//  PodSongViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/21.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

//
//  SetListViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/20.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import Foundation
import MaterialKit
import MediaPlayer
import AVFoundation

class PodSongViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PodSongTableViewCellDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var playTimeSlider: UISlider!
    
    @IBOutlet weak var podSongTableView: UITableView!
    
    var podSongs = [PodSong]()
    var isSong: Bool = true
    var searchWord: String = ""
    
    var audio: AVAudioPlayer! = nil
    
    var playingTimeTimer: NSTimer! = nil
    
    func reloadPodSongs() {
        podSongs.removeAll(keepCapacity: false)
        
        var songItems: [MPMediaItem]
        
        if isSong {
            let songQuery: MPMediaQuery = MPMediaQuery.songsQuery()
            songQuery.addFilterPredicate(MPMediaPropertyPredicate(value: searchWord, forProperty: MPMediaItemPropertyTitle))
            
            songItems = songQuery.items as! [MPMediaItem]
            println(songItems.count)
        } else {
            let artistQuery: MPMediaQuery = MPMediaQuery.artistsQuery()
            artistQuery.addFilterPredicate(MPMediaPropertyPredicate(value: searchWord, forProperty: MPMediaItemPropertyArtist))
            
            songItems = artistQuery.items as! [MPMediaItem]
        }
        
        println(songItems.count)
        for songItem in songItems {
            let podSong = PodSong(songId: (songItem.valueForProperty(MPMediaItemPropertyPersistentID) as! NSNumber).integerValue, artistName: songItem.valueForProperty(MPMediaItemPropertyArtist) as! String, songTitle: songItem.valueForProperty(MPMediaItemPropertyTitle) as! String, albumTitle: songItem.valueForProperty(MPMediaItemPropertyAlbumTitle) as! String)
            println(songItem.valueForProperty(MPMediaItemPropertyTitle))
            
            podSongs.append(podSong)
        }
        
        podSongs.sort({ $0.songTitle < $1.songTitle })
        podSongTableView.reloadData()
    }
    
    func initializePodSongTableComponent() {
        podSongTableView.delegate = self
        podSongTableView.dataSource = self
    }
    
    func initializeToolBar() {
        toolBar.barTintColor = UIColor.MainColor()
        //stopButton.tintColor = UIColor.cyanColor()
        
        refreshMusicButton()
    }
    
    func refreshMusicButton() {
        stopButton.enabled = audio != nil
        if !stopButton.enabled {
            self.navigationItem.title = ""
            playTimeSlider.value = 0.0;
        }
        
        pauseButton.enabled = audio != nil && audio.playing
        
        playButton.enabled = audio != nil && !audio.playing
        playTimeSlider.enabled = audio != nil
    }
    
    func refreshSearchComponent() {
        //self.resultCountLabel.text = "\(self.songs.count)"
        //self.sortButton.enabled = self.songs.count > 1
        //self.filterButton.enabled = self.sortButton.enabled
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if podSongs.count > 0 {
            refreshSearchComponent()
            reloadPodSongs()
        }
        
        playingTimeTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updatePlayingTime", userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initializePodSongTableComponent()
        initializeToolBar()
        
        reloadPodSongs()
        refreshSearchComponent()
    }
    
    override func viewDidDisappear(animated: Bool) {
        stopSong()
        
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePlayingTime() {
        if audio != nil && audio.playing {
            playTimeSlider.value = Float(audio.currentTime)
        }
    }
    
    func setPlayingTime(pos: Double) {
        audio.currentTime = pos
    }
    
    func stopSong() {
        if audio != nil {
            audio.stop()
            audio = nil
        }
        
        refreshMusicButton()
    }
    
    func getSongItem( songId: NSNumber ) -> MPMediaItem {
        
        var property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        var query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        
        var items: [MPMediaItem] = query.items as! [MPMediaItem]
        
        return items[0]
    }
    
    @IBAction func clickStop(sender: AnyObject) {
        stopSong()
    }

    @IBAction func clickPause(sender: AnyObject) {
        if audio.playing {
            audio.pause()
        }
        
        refreshMusicButton()
    }
    
    @IBAction func clickPlay(sender: AnyObject) {
        if !audio.playing {
            audio.play()
        }
        
        refreshMusicButton()
    }

    @IBAction func changePlayTimeSliderValue(sender: AnyObject) {
        setPlayingTime(Double(playTimeSlider!.value))
        updatePlayingTime()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK -- tableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PodSongCell", forIndexPath: indexPath) as! PodSongTableViewCell
        let song = podSongs[indexPath.row]
        cell.delegate = self
        cell.configureCell(song, atIndexPath: indexPath)
        //cell.textLabel?.text = podSongs[indexPath.row].songTitle
        //cell.textLabel?.textColor = UIColor.CellTextColor()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podSongs.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func selectSong(song: PodSong) {
        stopSong()
        
        self.navigationItem.title = song.songTitle
        let songItem: MPMediaItem = getSongItem(NSNumber(integer: song.songId))
        let url: NSURL = songItem.valueForProperty( MPMediaItemPropertyAssetURL ) as! NSURL
        audio = AVAudioPlayer( contentsOfURL: url, error: nil )
        audio.play()
        audio.delegate = self
        
        playTimeSlider.maximumValue = Float(audio.duration)
        
        refreshMusicButton()
    }
    
}
