//
//  ViewController.swift
//  Simple_Browser
//
//  Created by 王晨羽 on 2018/8/2.
//  Copyright © 2018 王晨羽. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,UITextFieldDelegate,WKUIDelegate,WKNavigationDelegate{
    @IBOutlet weak var ForwardBtn: UIButton!
    @IBOutlet weak var TitleContent: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var ProgressView: UIProgressView!
    @IBOutlet weak var WebView: WKWebView!
    @IBOutlet weak var AddressInput: UITextField!
    @IBAction func Go(_ sender: UIButton) {
        ProgressView.setProgress(0.0, animated: false)
        loadAuthPage()
        AddressInput.resignFirstResponder()
    }
    @IBOutlet weak var Refresh: UIButton!
    @IBAction func Refreash(_ sender: Any) {
        WebView.reload()
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        WebView.goBack()
        BtnIsAbled()
    }
    
    @IBAction func ForwardBtn(_ sender: Any) {
        WebView.goForward()
    }
    
    
    func loadAuthPage(){
        self.WebView.navigationDelegate = self
        self.WebView.uiDelegate = self
        var urlString = ""
        var FinalUrl = ""
        urlString = self.AddressInput.text!
        print(urlString)
        let defultHeader = "https://"
        if((urlString.range(of: "https://")) != nil){
            FinalUrl = urlString
        }
        else{
            FinalUrl = defultHeader + urlString
        }
        //self.AddressInput.text = FinalUrl
        let url = URL(string:FinalUrl)
        let request = URLRequest(url: url!)
        WebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        WebView.load(request)
        BtnIsAbled()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            ProgressView.alpha = 1.0
            ProgressView.setProgress(Float(WebView.estimatedProgress), animated: true)
            if WebView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.ProgressView.alpha = 0
                }, completion: { (finish) in
                    self.ProgressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.AddressInput.text = webView.url?.absoluteString
        print("开始加载")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("开始获取网页内容")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
        BtnIsAbled()
        let Title = self.WebView.title
        print(Title)
        self.TitleContent.text = Title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
    }
//    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        let url = navigationAction.request.url
//        let StringUrl = url?.absoluteString
//        AddressInput.text = StringUrl
//        print(url)
//
//    }
    

    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ProgressView.setProgress(0.0, animated: false)
        ProgressView.trackTintColor = UIColor.white
        ProgressView.progressTintColor = UIColor.blue
        BtnIsAbled()
        WebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        WebView.removeObserver(self, forKeyPath: "estimatedProgress")
        WebView.uiDelegate = nil
        WebView.navigationDelegate = nil
    }

    
    func BtnIsAbled(){
        if (WebView.canGoBack == true) {
            self.backBtn.isEnabled = true
            self.backBtn.setTitleColor(self.backBtn.tintColor, for: UIControlState.normal)
        }else{
            print(WebView.canGoBack)
            self.backBtn.isEnabled = false
            self.backBtn.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        }
        if (WebView.canGoForward == true){
            self.ForwardBtn.isEnabled = true
            self.ForwardBtn.setTitleColor(self.backBtn.tintColor, for: UIControlState.normal)
        }else{
            print(WebView.canGoForward)
            self.ForwardBtn.isEnabled = false
            self.ForwardBtn.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        }
    }
    

}

