//
//  CommunityPostViewController.swift
//  Reddit
//
//  Created by Angelo Acero on 5/9/21.
//

import UIKit
import WebKit

class CommunityPostViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    var redditPost: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadURLRequest()
        // Do any additional setup after loading the view.
    }
    
    private func loadURLRequest(){
        self.edgesForExtendedLayout = []
        self.navigationController?.view.backgroundColor = .white
        let redditString = "https://www.reddit.com/"
        guard let comminityLink = redditPost else {return}
        guard let url = URL(string: redditString + comminityLink) else {return}
        webView.load(URLRequest(url: url))
    }
    

}
