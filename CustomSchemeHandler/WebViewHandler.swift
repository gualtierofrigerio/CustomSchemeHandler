//
//  WebViewHandler.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

import Foundation
import WebKit

class WebViewHandler: NSObject {
    let webView: WKWebView
    
    override init() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        
        configuration.preferences = preferences
        configuration.setURLSchemeHandler(SchemeHandler(), forURLScheme: "asset")
        
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.bounces = false
        
        super.init()
        webView.navigationDelegate = self
    }
}

extension WebViewHandler: WKNavigationDelegate {
    
}
