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
    
    var wkWebView:WKWebView?
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
        let webViewConfiguration = WKWebViewConfiguration.init()
        //webViewConfiguration.suppressesIncrementalRendering = true
        //webViewConfiguration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let wkWebView = WKWebView.init(frame: self.bounds, configuration: webViewConfiguration)
        wkWebView.navigationDelegate = self
        self.wkWebView = wkWebView
        updateURL()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
        if let wkWebView = self.wkWebView {
            wkWebView.stopLoading()
            wkWebView.removeFromSuperview()
            wkWebView.navigationDelegate = nil
            self.wkWebView = nil
        }
    }
    
    func updateURL() {
        if let wkWebView = self.wkWebView {
            wkWebView.stopLoading()
            
            let urlString = configWindowController.webAddress
            
            let url = URL(string: urlString)!
            if (url.scheme == "http" || url.scheme == "https") {
                wkWebView.load(URLRequest(url: url))
            }
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
