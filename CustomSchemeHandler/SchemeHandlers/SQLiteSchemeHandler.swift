//
//  SchemeHandler.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

import Foundation

import WebKit

class SQLiteSchemeHandler: NSObject, WKURLSchemeHandler {
    override init() {
        if let databasePath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
            sqlWrapper = SQLiteWrapper(path: databasePath)
        }
    }
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else { return }
        let data = dataForURL(url)
        let response = HTTPURLResponse(url: url,
                                       mimeType: "application/json",
                                       expectedContentLength: data?.count ?? 0,
                                       textEncodingName: "utf-8")
        
        urlSchemeTask.didReceive(response)
        if let data = data {
            urlSchemeTask.didReceive(data)
        }
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
}

// MARK: - Private

private var sqlWrapper: SQLiteWrapper?

private func dataForURL(_ url: URL) -> Data? {
    var data: Data?
    guard let wrapper = sqlWrapper,
          let urlValue = url.host,
          let jsonObject = wrapper.performQuery("select * from \(urlValue)") else { return nil }
    if JSONSerialization.isValidJSONObject(jsonObject) {
        data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
    }
    return data
}
