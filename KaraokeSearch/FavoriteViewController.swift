//
//  FavoriteViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/10.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SugarRecord

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favSongTableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var songs = [FavoredSong]()
    
    func reloadFavSongs() {
        songs.removeAll(keepCapacity: false)
        
        let results: SugarRecordResults = FavoredSong.all().sorted(by: "favoredAt", ascending: true).find()
        
        for result: AnyObject in results {
            let song = result as! FavoredSong
            songs.append(song)
        }
        
        favSongTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favSongTableView.delegate = self
        favSongTableView.dataSource = self
        
        refreshButton.tintColor = UIColor.whiteColor()
        
        reloadFavSongs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func clickRefresh(sender: AnyObject) {
        reloadFavSongs()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavSongCell", forIndexPath: indexPath) as! FavSongTableViewCell
        let song = songs[indexPath.row]
        cell.configureCell(song, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showSongInfo") {
            let selectedCell = sender as! FavSongTableViewCell
            let nextViewController: SongInfoViewController = segue.destinationViewController as! SongInfoViewController
            
            let targetFavSong = songs[favSongTableView.indexPathForCell(selectedCell)!.row]
            
            let song: Song = Song(id: targetFavSong.id.integerValue, artistId: targetFavSong.artistId.integerValue, artistName: targetFavSong.artistName, artistNameSearch: targetFavSong.artistName, songId: targetFavSong.songId.integerValue, songTitle: targetFavSong.songTitle, songTitleSearch: targetFavSong.songTitle, createdAt: targetFavSong.registeredAt, updatedAt: targetFavSong.registeredAt)
            
            nextViewController.song = song
        }
    }

}
