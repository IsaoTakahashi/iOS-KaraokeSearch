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

class SearchSongViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SortViewControllerDelegate, FilterViewControllerDelegate  {
    
    @IBOutlet weak var artistTextField: MKTextField!
    @IBOutlet weak var songTextField: MKTextField!
    @IBOutlet weak var searchButton: MKButton!
    @IBOutlet weak var resultCountLabel: MKLabel!
    @IBOutlet weak var sortButton: MKButton!
    @IBOutlet weak var filterButton: MKButton!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var songs = [Song]()
    
    func initializeOrder() {
        songs.sort {(lhs, rhs) in
            if lhs.artistName != rhs.artistName {
                return lhs.artistName < rhs.artistName
            } else {
                return lhs.songTitle < rhs.songTitle
            }
        }
    }

    func initializeSearchComponent() {
        artistTextField.textColor = UIColor.TextFieldTextColor()
        artistTextField.layer.borderColor = UIColor.MainLightColor().CGColor
        artistTextField.attributedPlaceholder = NSAttributedString(string: "Artist Name", attributes: [NSForegroundColorAttributeName : UIColor.MainLightColor()])
        artistTextField.delegate = self

        songTextField.textColor = UIColor.TextFieldTextColor()
        songTextField.layer.borderColor = UIColor.MainLightColor().CGColor
        songTextField.attributedPlaceholder = NSAttributedString(string: "Song Title", attributes: [NSForegroundColorAttributeName : UIColor.MainLightColor()])
        songTextField.delegate = self
        
        searchButton.maskEnabled = false
        searchButton.ripplePercent = 0.5
        searchButton.backgroundAniEnabled = false
        searchButton.rippleLocation = .Center
        searchButton.layer.shadowOpacity = 0.55
        searchButton.layer.shadowRadius = 5.0
        searchButton.layer.shadowColor = UIColor.grayColor().CGColor
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        searchButton.backgroundColor = UIColor.ButtonBKColor()
        searchButton.tintColor = UIColor.ButtonTextColor()
        resultCountLabel.textColor = UIColor.ButtonBKColor()
        
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
    
    func initializeResultTableComponent() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    func refreshSearchComponent() {
        self.resultCountLabel.text = "\(self.songs.count)"
        self.sortButton.enabled = self.songs.count > 1
        self.filterButton.enabled = self.sortButton.enabled
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
        
        artistTextField.resignFirstResponder()
        songTextField.resignFirstResponder()
        
        if (artistName.isEmpty && songTitle.isEmpty) {
            println("please input either artistName or songTitle")
            return
        }
        
        // clear result of search
        songs.removeAll(keepCapacity: false)
        JHProgressHUD.sharedHUD.showInView(self.view, withHeader: "", andFooter: "Searching...")
        
        
        
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
            self.initializeOrder()
            self.resultTableView.reloadData()
            JHProgressHUD.sharedHUD.hide()
            self.refreshSearchComponent()
        }
        
        
    }
    
    // MARK -- textField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK -- tableView
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
    
    // MARK -- sortView
    func sort(target: String, sortOrder order: String) {
        println("target: \(target), order: \(order)")
        
        initializeOrder()
        
        switch target {
        case "Artist Name":
            songs.sort {(lhs, rhs) in return lhs.artistName < rhs.artistName}
            break
        case "Song Title":
            songs.sort {(lhs, rhs) in return lhs.songTitle < rhs.songTitle}
            break
        case "Registered Date":
            songs.sort {(lhs, rhs) in return lhs.createdAt < rhs.createdAt}
            break
        case "Song ID":
            songs.sort {(lhs, rhs) in return lhs.songId < rhs.songId}
            break
        default:
            break
        }
        
        let asc: Bool = order == "ASC"
        if !asc {
            songs = songs.reverse()
        }
        
        resultTableView.reloadData()
    }
    
    // MARK -- filterView
    func filter(target: String, filterString string: String) {
        switch target {
        case "Artist Name":
            songs = songs.filter { $0.artistName == string }
            break
        case "Song Title":
            songs = songs.filter { $0.songTitle == string }
            break
        default:
            break
        }
        
        refreshSearchComponent()
        resultTableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        self.view.endEditing(true)
        
        if (segue.identifier == "showSongInfo") {
            let selectedCell = sender as! SongTableViewCell
            let nextViewController: SongInfoViewController = segue.destinationViewController as! SongInfoViewController
            nextViewController.song = songs[resultTableView.indexPathForCell(selectedCell)!.row ]
        } else if (segue.identifier == "showSortPicker") {
            let nextViewController: SortViewController = segue.destinationViewController as! SortViewController
            nextViewController.delegate = self
        } else if (segue.identifier == "showFilterPicker") {
            let nextViewController: FilterViewController = segue.destinationViewController as! FilterViewController
            nextViewController.delegate = self
            
            var artistNames: [String] = songs.reduce([String](), combine: {
                var temp = $0
                let artistName = $1.artistName
                let count:Int = temp.filter({
                    $0 == artistName
                }).count
                
                if count==0 { temp.append($1.artistName) }
                return temp
            })
            var songTitles: [String] = songs.reduce([String](), combine: {
                var temp = $0
                let artistName = $1.songTitle
                let count:Int = temp.filter({
                    $0 == artistName
                }).count
                
                if count==0 { temp.append($1.songTitle) }
                return temp
            })
            nextViewController.artistNames = artistNames.sorted { $0 < $1 }
            nextViewController.songTitles = songTitles.sorted { $0 < $1 }
        }
    }
    
}
