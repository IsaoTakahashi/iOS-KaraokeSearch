//
//  ViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/09.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit

class BaseViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("Hello")
        
        self.tabBar.tintColor = UIColor.whiteColor()
        self.tabBar.barTintColor = UIColor.NavBarColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

