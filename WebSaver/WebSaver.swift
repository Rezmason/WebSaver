//
//  WebSaver.swift
//  WebSaver
//
//  Created by Jeremy Sachs on 3/20/19.
//  Copyright © 2019 Rezmason.net. All rights reserved.
//

import ScreenSaver
import WebKit

class WebSaverView:ScreenSaverView, WKNavigationDelegate {
    
    var wkWebView:WKWebView!
    
    override func startAnimation() {
        super.startAnimation()
        wkWebView = WKWebView.init(frame: self.bounds)
        wkWebView.navigationDelegate = self
        updateURL()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
        wkWebView.stopLoading()
        wkWebView.removeFromSuperview()
        wkWebView.navigationDelegate = nil
        wkWebView = nil
    }
    
    func updateURL() {
        wkWebView.stopLoading()
        
        let urlString = "https://rezmason.github.io/matrix"
        
        let url = URL(string: urlString)!
        if (url.scheme == "http" || url.scheme == "https") {
            wkWebView.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.addSubview(webView)
    }
}
