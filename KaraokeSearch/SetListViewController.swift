//
//  SetListViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/20.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import SugarRecord
import MaterialKit

class SetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //@IBOutlet weak var favSongTableView: UITableView!
    @IBOutlet weak var setListTableView: UITableView!
    @IBOutlet weak var filterButton: MKButton!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var setLists = [SetList]()

    
    func reloadSetLists() {
        setLists.removeAll(keepCapacity: false)
        
        let results: SugarRecordResults = SetList.all().sorted(by: "createdAt", ascending: false).find()
        
        for result: AnyObject in results {
            let setList = result as! SetList
            setLists.append(setList)
        }

        setListTableView.reloadData()
    }
    
    func initializeSearchComponent() {
        
        filterButton.maskEnabled = false
        filterButton.ripplePercent = 0.5
        filterButton.backgroundAniEnabled = false
        filterButton.rippleLocation = .Center
        filterButton.tintColor = UIColor.ButtonBKColor()
        filterButton.enabled = false
    }
    
    func initializeFavSongTableComponent() {
        setListTableView.delegate = self
        setListTableView.dataSource = self
    }
    
    func refreshSearchComponent() {
        //self.resultCountLabel.text = "\(self.songs.count)"
        //self.sortButton.enabled = self.songs.count > 1
        //self.filterButton.enabled = self.sortButton.enabled
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if setLists.count > 0 {
            reloadSetLists()
            refreshSearchComponent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        initializeSearchComponent()
        initializeFavSongTableComponent()
        
        addButton.tintColor = UIColor.whiteColor()
        
        reloadSetLists()
        refreshSearchComponent()
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
    
    func insertSetList(title: String) {
        var setList: SetList = SetList.create() as! SetList
        setList.id = setLists.count;
        setList.title = title
        setList.createdAt = NSDate()
        setList.updatedAt = NSDate()
        
        let saved: Bool = setList.save()
        
        if saved {
            setLists.append(setList)
            reloadSetLists()
        }
    }
    
    func deleteSetList(setList: SetList!) {
        setList.beginWriting().delete().endWriting()
    }
    
    func openCreateSetListAlert() {
        let alert:UIAlertController = UIAlertController(title:"New Set List",
            message: "",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("Cancel")
        })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("OK")
                let textFields:Array<UITextField>? =  alert.textFields as! Array<UITextField>?
                if textFields != nil {
                    for textField:UITextField in textFields! {
                        //各textにアクセス
                        println(textField.text)
                        if !textField.text.isEmpty {
                            self.insertSetList(textField.text)
                        }
                        
                    }
                }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        //textfiledの追加
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "SetList Title"
        })
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickAdd(sender: AnyObject) {
        openCreateSetListAlert()
    }
    
    
    // MARK -- tableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SetListCell", forIndexPath: indexPath) as! UITableViewCell
        //let song = songs[indexPath.row]
        //cell.configureCell(song, atIndexPath: indexPath)
        cell.textLabel?.text = setLists[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setLists.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
//        // 編集
//        let edit = UITableViewRowAction(style: .Normal, title: "Edit") {
//            (action, indexPath) in
//            
//            self.itemArray[indexPath.row] += "!!"
//            self.swipeTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        }
//        
//        edit.backgroundColor = UIColor.greenColor()
        
        // 削除
        let del = UITableViewRowAction(style: .Default, title: "Delete") {
            (action, indexPath) in
            var setList: SetList = self.setLists[indexPath.row]
            self.deleteSetList(setList)
            
            self.setLists.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        del.backgroundColor = UIColor.redColor()
        
//        return [edit, del]
        return [del]
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showSongInfo") {
        }
    }
    
}
