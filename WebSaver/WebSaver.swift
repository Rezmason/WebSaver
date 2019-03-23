//
//  WebSaver.swift
//  WebSaver
//
//  Created by Jeremy Sachs on 3/20/19.
//  Copyright © 2019 Rezmason.net. All rights reserved.
//

import ScreenSaver
import WebKit

let ConfigChanged = Notification.Name.init("ConfigChanged")

class WebSaverView:ScreenSaverView, WKNavigationDelegate {
    
    var wkWebView:WKWebView!
    var configChangedObserver:NSObjectProtocol?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        self.addObserver()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    func addObserver() {
        configChangedObserver = NotificationCenter.default.addObserver(
            forName: ConfigChanged,
            object: nil,
            queue: nil,
            using: { [weak self] (notification) -> Void in
                self?.updateURL()
            }
        )
    }
    
    func removeObserver() {
        if let configChangedObserver = self.configChangedObserver {
            NotificationCenter.default.removeObserver(configChangedObserver)
        }
    }
    
    let configWindowController: ConfigWindowController = {
        let controller = ConfigWindowController()
        controller.loadWindow()
        return controller
    }()
    
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
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        return self.configWindowController.window
    }
}
