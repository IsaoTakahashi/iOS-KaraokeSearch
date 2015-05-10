//
//  SongInfoViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/10.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import MaterialKit

class SongInfoViewController: UIViewController {
    
    var song : Song? = nil

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: MKLabel!
    @IBOutlet weak var songTitleLabel: MKLabel!
    @IBOutlet weak var descriptionLabel: MKLabel!
    
    @IBOutlet weak var songFavButton: MKButton!
    
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
    
    func initializeFavInfo() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = song?.songTitle
        
        initializeSubjectLabel()
        initializeInfoLabel()
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

}
