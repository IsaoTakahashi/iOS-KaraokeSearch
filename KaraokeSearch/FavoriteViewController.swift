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
import MaterialKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SortViewControllerDelegate {
    
    @IBOutlet weak var favSongTableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: MKButton!
    @IBOutlet weak var sortButton: MKButton!
    
    var songs = [FavoredSong]()
    
    func initializeOrder() {
        songs.sort {(lhs, rhs) in
            if lhs.artistName != rhs.artistName {
                return lhs.artistName < rhs.artistName
            } else {
                return lhs.songTitle < lhs.songTitle
            }
        }
    }
    
    func reloadFavSongs() {
        songs.removeAll(keepCapacity: false)
        
        let results: SugarRecordResults = FavoredSong.all().sorted(by: "artistName", ascending: true).find()
        
        for result: AnyObject in results {
            let song = result as! FavoredSong
            songs.append(song)
        }
        
        sortButton.enabled = songs.count > 2
        filterButton.enabled = sortButton.enabled
        initializeOrder()
        favSongTableView.reloadData()
        
    }
    
    func initializeSearchComponent() {
        sortButton.maskEnabled = false
        sortButton.ripplePercent = 0.5
        sortButton.backgroundAniEnabled = false
        sortButton.rippleLocation = .Center
        sortButton.tintColor = UIColor.ButtonBKColor()
        sortButton.enabled = false
        
        filterButton.maskEnabled = false
        filterButton.ripplePercent = 0.5
        filterButton.backgroundAniEnabled = false
        filterButton.rippleLocation = .Center
        filterButton.tintColor = UIColor.ButtonBKColor()
        filterButton.enabled = false
    }
    
    func initializeFavSongTableComponent() {
        favSongTableView.delegate = self
        favSongTableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        initializeSearchComponent()
        initializeFavSongTableComponent()
        
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
    
    // MARK -- sortView
    func sort(target: String, sortOrder order: String) {
        println("target: \(target), order: \(order)")
        
        //first, reorder Artist Name, Song Title ASC
        initializeOrder()
        
        switch target {
        case "Artist Name":
            songs.sort {(lhs, rhs) in return lhs.artistName < rhs.artistName}
            break
        case "Song Title":
            songs.sort {(lhs, rhs) in return lhs.songTitle < rhs.songTitle}
            break
        case "Registered Date":
            songs.sort {(lhs, rhs) in return lhs.registeredAt < rhs.registeredAt}
            break
        case "Song ID":
            songs.sort {(lhs, rhs) in return lhs.songId.integerValue < rhs.songId.integerValue}
            break
        case "Favorite Date":
            songs.sort {(lhs, rhs) in return lhs.favoredAt.compare(rhs.favoredAt) == .OrderedAscending }
            break
        default:
            break
        }
        
        let asc: Bool = order == "ASC"
        if !asc {
            songs = songs.reverse()
        }
        
        favSongTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showSongInfo") {
            let selectedCell = sender as! FavSongTableViewCell
            let nextViewController: SongInfoViewController = segue.destinationViewController as! SongInfoViewController
            
            let targetFavSong = songs[favSongTableView.indexPathForCell(selectedCell)!.row]
            
            let song: Song = Song(id: targetFavSong.id.integerValue, artistId: targetFavSong.artistId.integerValue, artistName: targetFavSong.artistName, artistNameSearch: targetFavSong.artistName, songId: targetFavSong.songId.integerValue, songTitle: targetFavSong.songTitle, songTitleSearch: targetFavSong.songTitle, createdAt: targetFavSong.registeredAt, updatedAt: targetFavSong.registeredAt)
            
            nextViewController.song = song
        } else if (segue.identifier == "showSortPicker") {
            let nextViewController: SortViewController = segue.destinationViewController as! SortViewController
            nextViewController.delegate = self
            
            var sortOptions: NSArray = ["Artist Name","Song Title","Registered Date","Song ID", "Favorite Date"]
            nextViewController.sortOptions = sortOptions
        }
    }

}
