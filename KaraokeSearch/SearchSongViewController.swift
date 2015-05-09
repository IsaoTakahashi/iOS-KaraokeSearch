//
//  SearchSongViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/09.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import MaterialKit
import QuartzCore
import Alamofire

class SearchSongViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var artistTextField: MKTextField!
    @IBOutlet weak var songTextField: MKTextField!
    @IBOutlet weak var searchButton: MKButton!
    @IBOutlet weak var resultCountLabel: MKLabel!
    @IBOutlet weak var resultTableView: UITableView!
    
    var songs = [Song]()

    func initializeSearchComponent() {
        artistTextField.backgroundColor = UIColor.whiteColor()
        artistTextField.attributedPlaceholder = NSAttributedString(string: "Artist Name")
        songTextField.attributedPlaceholder = NSAttributedString(string: "Song Title")
        
        searchButton.maskEnabled = false
        searchButton.ripplePercent = 0.5
        searchButton.backgroundAniEnabled = false
        searchButton.rippleLocation = .Center
        searchButton.layer.shadowOpacity = 0.55
        searchButton.layer.shadowRadius = 5.0
        searchButton.layer.shadowColor = UIColor.grayColor().CGColor
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        searchButton.backgroundColor = UIColor.rgbhex("28AD74", alpha: 1.0)
        searchButton.tintColor = UIColor.whiteColor()
        resultCountLabel.textColor = UIColor.rgbhex("28AD74", alpha: 1.0)
    }
    
    func initializeResultTableComponent() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("SearchSongViewController")
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        initializeSearchComponent()
        initializeResultTableComponent()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSearch(sender: MKButton) {
        let baseURL : String = "http://ec2-54-92-60-143.ap-northeast-1.compute.amazonaws.com/search?";
        let artistName : String! = artistTextField.attributedText?.string
        let songTitle : String! = songTextField.attributedText?.string
        
        if (artistName.isEmpty && songTitle.isEmpty) {
            println("please input either artistName or songTitle")
            return
        }
        
        // clear result of search
        songs.removeAll(keepCapacity: false)
        
        let searchURL = baseURL + "artist=" + artistName + "&title=" + songTitle
        Alamofire.request(.GET, searchURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! ).progress { bytes, totalBytes, totalBytesExpected in
            println("bytes: \(bytes), totalBytes: \(totalBytes)") // レスポンスの取得状況監視
        }.responseJSON { request, response, data, error in
            if let songParamArray = data as? Array<Dictionary<String,AnyObject>> {
                for songParam in songParamArray {
                    let song = Song(id: songParam["id"] as! Int , artistId: (songParam["artist_id"] as! String).toInt()!, artistName: songParam["artist_name"] as! String, artistNameSearch: songParam["artist_name_search"] as! String, songId: (songParam["song_id"] as! String).toInt()!, songTitle: songParam["song_title"] as! String, songTitleSearch: songParam["song_title_search"] as! String, createdAt: songParam["created_at"] as! String, updatedAt: songParam["updated_at"] as! String)
                    self.songs.append(song)
                }
                
            }
            self.resultCountLabel.text = "\(self.songs.count)"
            self.resultTableView.reloadData()
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as! SongTableViewCell
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
    
}
