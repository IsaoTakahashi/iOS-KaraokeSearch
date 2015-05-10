//
//  SortViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/10.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit

protocol SortViewControllerDelegate{
    func sort(target: String, sortOrder order: String)
}

class SortViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIToolbar!
    
    let sortOptions: NSArray = ["Artist Name","Song Title","Registered Date","Song ID"]
    let sortOrderOptions: NSArray = ["ASC","DESC"]
    
    var delegate: SortViewControllerDelegate! = nil
    var sortTarget: String = ""
    var sortOrder: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.barTintColor = UIColor.NavBarColor()
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        sortTarget = sortOptions[0] as! String
        sortOrder = sortOrderOptions[0] as! String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickSort(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate.sort(sortTarget, sortOrder: sortOrder)
    }
    
    // MARK -- pickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var size : Int = 0
        
        switch component {
        case 0:
            size =  sortOptions.count
            break
        case 1:
            size =  sortOrderOptions.count
            break
        default:
            break
        }
        
        return size
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        var text : String = ""
        switch component {
        case 0:
            text =  sortOptions[row] as! String
            break
        case 1:
            text =  sortOrderOptions[row] as! String
            break
        default:
            break
        }
        
        return text
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var text : String = ""
        switch component {
        case 0:
            text =  sortOptions[row] as! String
            break
        case 1:
            text =  sortOrderOptions[row] as! String
            break
        default:
            break
        }
        
        return NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:UIColor.CellTextColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("row: \(row)")
        //println("value: \(myValues[row])")
        
        switch component {
        case 0:
            sortTarget =  sortOptions[row] as! String
            break
        case 1:
            sortOrder =  sortOrderOptions[row] as! String
            break
        default:
            break
        }
        
    }

}
