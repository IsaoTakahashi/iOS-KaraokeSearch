//
//  FilterViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/10.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate{
    func filter(target: String, filterString string: String)
}

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIToolbar!
    @IBOutlet weak var filterButton: UIToolbar!
    
    var filterOptions: [String] = ["Artist Name","Song Title"]
    var artistNames: [String] = [""]
    var songTitles: [String] = [""]
    
    var delegate: FilterViewControllerDelegate! = nil
    var filterTarget: String = ""
    var filterString: String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.barTintColor = UIColor.NavBarColor()
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        filterTarget = filterOptions[0]
        filterString = artistNames[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickFilter(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate.filter(filterTarget, filterString: filterString)
    }
    
    // MARK -- pickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var size : Int = 0
        
        switch component {
        case 0:
            size =  filterOptions.count
            break
        case 1:
            if filterTarget == filterOptions[0] {
                size = artistNames.count
            } else {
                size = songTitles.count
            }
            break
        default:
            break
        }
        
        return size
    }
    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
//        var text : String = ""
//        switch component {
//        case 0:
//            text =  filterOptions[row] as! String
//            break
//        case 1:
//            text =  filterStrings[row] as! String
//            break
//        default:
//            break
//        }
//        
//        return text
//    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var text : String = ""
        switch component {
        case 0:
            text =  filterOptions[row]
            break
        case 1:
            if filterTarget == filterOptions[0] {
                text = artistNames[row]
            } else {
                text = songTitles[row]
            }
            
            break
        default:
            break
        }
        
        return NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:UIColor.CellTextColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            filterTarget =  filterOptions[row]
            self.pickerView.reloadComponent(1)
            break
        case 1:
            if filterTarget == filterOptions[0] {
                filterString =  artistNames[row]
            } else {
                filterString =  songTitles[row]
            }
            break
        default:
            break
        }
    }
    
}
