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
    
    init(withSchemeHandlers handlers: [SchemeHandlerEntry]) {
        let preferences = WKPreferences()
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        for entry in handlers {
            configuration.setURLSchemeHandler(entry.schemeHandler,
                                              forURLScheme: entry.urlScheme)
        }
        
        webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.bounces = false
        
        super.init()
        webView.navigationDelegate = self
    }
    
    func loadRequest(_ request: URLRequest) {
        webView.load(request)
    }
}

extension WebViewHandler: WKNavigationDelegate {
    
}
