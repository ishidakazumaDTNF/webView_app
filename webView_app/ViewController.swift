//
//  ViewController.swift
//  webView_app
//
//  Created by 石田一馬 on 2017/07/14.
//  Copyright © 2017年 HAL. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIWebViewDelegate, UITabBarDelegate{

    @IBOutlet weak var myWebView: UIWebView!
    
    @IBOutlet weak var myTabBar: UITabBar!
    
    @IBOutlet weak var myIndicator: UIActivityIndicatorView!

    @IBOutlet weak var myNavigationBar: UINavigationBar!
    
    @IBOutlet weak var myNavigationBarItem: UINavigationItem!
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var audioPlayerInstance : AVAudioPlayer! = nil  // 再生するサウンドのインスタンス
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.delegate = self
        
        myTabBar.delegate = self
        
        mySearchBar.placeholder = "ここに入力してください"
        
        let path:String = Bundle.main.path(forResource: "top", ofType: "html")!
        let url = URL(string: path)
        let request = URLRequest(url: url!)
        self.myWebView.loadRequest(request)
        
        //アプリっぽく見せるセット
        myWebView.scalesPageToFit=true
        myWebView.scrollView.bounces=false
        myWebView.scrollView.showsHorizontalScrollIndicator=false
        myWebView.scrollView.showsVerticalScrollIndicator=false
        
        myTabBar.delegate = self
        
        myTabBar.tintColor=UIColor(red:255.0/255.0, green:255.0/255.0,
                                   blue:255.0/255.0, alpha:1)
        for item in (myTabBar.items!)
        {
            item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1)], for:UIControlState.normal)
            //クリックされた時のテキストの色:白
            item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:255.0/255.0, green: 0/0, blue: 0/0, alpha: 1)], for:UIControlState.selected)
        }
        
        // サウンドファイルのパスを生成
        let soundFilePath = Bundle.main.path(forResource: "SESound03", ofType: "wav")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        // AVAudioPlayerのインスタンスを作成
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成失敗")
        }
        // バッファに保持していつでも再生できるようにする
        audioPlayerInstance.prepareToPlay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 使わない
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            
        case 0:
            let url: URL = URL(string: "http://210.166.154.135/ip3ss72701/view1/index.html")!
            let request: URLRequest = URLRequest(url: url)
            self.myWebView.loadRequest(request)
            audioPlayerInstance.play()
            self.myNavigationBarItem.title = myWebView.stringByEvaluatingJavaScript(from: "document.title")
            
        case 1:
            let url: URL = URL(string: "http://210.166.154.135/ip3ss72701/view2/index.html")!
            let request: URLRequest = URLRequest(url: url)
            self.myWebView.loadRequest(request)
            audioPlayerInstance.play()
            self.myNavigationBarItem.title = myWebView.stringByEvaluatingJavaScript(from: "document.title")
            
        case 2:
            let url: URL = URL(string: "https://www.google.co.jp/")!
            let request: URLRequest = URLRequest(url: url)
            self.myWebView.loadRequest(request)
            audioPlayerInstance.play()
            self.myNavigationBarItem.title = myWebView.stringByEvaluatingJavaScript(from: "document.title")
            
        case 3:
            let path:String = Bundle.main.path(forResource: "top", ofType: "html")!
            let url = URL(string: path)
            let request = URLRequest(url: url!)
            self.myWebView.loadRequest(request)

        default: break
        }
    }
    
    // 読み込み前
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType:UIWebViewNavigationType) -> Bool{
        
        if(request.url?.absoluteString.range(of: "playsound=tap")
            != nil){
            audioPlayerInstance.play()
        }
        
        return true
        }
    
    //読み込み開始
    func webViewDidStartLoad(_ webView: UIWebView){
        myIndicator.startAnimating()
        myIndicator.isHidden = false
    }
    
    //エラー
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let path:String = Bundle.main.path(forResource: "error", ofType: "html")!
        let url = URL(string: path)
        let request = URLRequest(url: url!)
        self.myWebView.loadRequest(request)
    }
    
    
    //読み込み終了
    func webViewDidFinishLoad(_ webView: UIWebView){
        myIndicator.stopAnimating()
        myIndicator.isHidden=true
        self.myNavigationBarItem.title = myWebView.stringByEvaluatingJavaScript(from: "document.title")
    }
    
    //戻るボタンタップ制御
    @IBAction func myGoBack(_ sender: Any) {
        if(myWebView.canGoBack){
            self.myWebView.goBack()
            audioPlayerInstance.play()
        }
    }
    
    
    
    
}

