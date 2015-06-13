//
//  SetListNavigationController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/20.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit

class SetListNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        println("SetListNavigationController")
        self.navigationBar.barTintColor = UIColor.NavBarColor()
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
