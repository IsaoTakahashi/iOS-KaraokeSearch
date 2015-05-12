//
//  BookmarkWebViewController.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/12.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit
import WebKit
import MaterialKit

protocol BookmarkWebViewControllerDelegate{
    func bookmark(urlString: String, service: String)
}

class BookmarkWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var pageTitleLabel: MKLabel!
    
    var urlString: String = "http://google.co.jp/"
    var service = "blank"
    var isBookmarked: Bool = false
    var song: Song! = nil
    var favSong: FavoredSong? = nil
    var delegate: BookmarkWebViewControllerDelegate! = nil
    
    func initializeParameter() {
        isBookmarked = !urlString.isEmpty
        
        if !isBookmarked {
            let searchString: String = "\(song.artistName) \(song.songTitle)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            switch service {
            case "info":
                break
            case "media":
                urlString = "https://www.youtube.com/results?search_query=" + searchString
                break
            case "lyrics":
                urlString = "http://google.co.jp/search?q=" + searchString + " 歌詞".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                break
            default:
                break
            }
        }
    }
    
    func refreshBookmarkButton() {
        
        bookmarkButton.enabled = favSong != nil

        if service == "info" {
            bookmarkButton.tintColor = UIColor.clearColor()
        } else {
            if isBookmarked {
                bookmarkButton.tintColor = UIColor.SubMidLightColor()
            } else {
                bookmarkButton.tintColor = UIColor.whiteColor()
            }
        }
    }
    
    func refreshGuideButton() {
        backButton.enabled = self.webView.canGoBack
        forwardButton.enabled = self.webView.canGoForward
    }
    
    func initializeToolBar() {
        toolBar.barTintColor = UIColor.MainColor()
        backButton.tintColor = UIColor.whiteColor()
        forwardButton.tintColor = UIColor.whiteColor()
        pageTitleLabel.textColor = UIColor.whiteColor()
        
        refreshGuideButton()
        refreshBookmarkButton()
    }
    
    func setupSwipeGestures() {
        // 右方向へのスワイプ
        let gestureToRight = UISwipeGestureRecognizer(target: self.webView, action: "goBack")
        gestureToRight.direction = UISwipeGestureRecognizerDirection.Right
        self.webView.addGestureRecognizer(gestureToRight)
        
        // 左方向へのスワイプ
        let gestureToLeft = UISwipeGestureRecognizer(target: self.webView, action: "goForward")
        gestureToLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.webView.addGestureRecognizer(gestureToLeft)
    }
    
    func goBack() {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        } else {
            // canGoBack == false の処理
        }
        refreshGuideButton()
    }
    
    func goForward() {
        if (self.webView.canGoForward) {
            self.webView.goForward()
        } else {
            // canGoForward == false の処理
        }
        refreshGuideButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.delegate = self
        
        initializeParameter()
        initializeToolBar()
        self.setupSwipeGestures()
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.webView.stopLoading()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickBack(sender: AnyObject) {
        goBack()
    }
    
    @IBAction func clickForward(sender: AnyObject) {
        goForward()
    }
    
    @IBAction func clickBookmark(sender: AnyObject) {
        if isBookmarked {
            urlString = ""
        } else {
            urlString = webView.stringByEvaluatingJavaScriptFromString("document.URL")!
        }
        
        isBookmarked = !isBookmarked
        refreshBookmarkButton()
        
        self.delegate.bookmark(urlString, service: service)
    }
    
    
    // MARK -- webView
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        return true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        refreshGuideButton()
        pageTitleLabel.text = webView.stringByEvaluatingJavaScriptFromString("document.title")
    println(webView.stringByEvaluatingJavaScriptFromString("document.URL")!)
    }
    
}
