//
//  AssetsSchemeHandler.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

import Foundation
import UniformTypeIdentifiers
import WebKit

class AssetsSchemeHandler: NSObject, SchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url,
              let fileUrl = fileUrlFromUrl(url),
              let mimeType = mimeType(ofFileAtUrl: fileUrl),
              let data = try? Data(contentsOf: fileUrl) else { return }
       
        let response = HTTPURLResponse(url: url,
                                       mimeType: mimeType,
                                       expectedContentLength: data.count, textEncodingName: nil)
        
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
    // MARK: - Private
    
    private func fileUrlFromUrl(_ url: URL) -> URL? {
        guard let assetName = url.host else { return nil }
        return Bundle.main.url(forResource: assetName,
                               withExtension: "",
                               subdirectory: "assets")
    }
    
    private func mimeType(ofFileAtUrl url: URL) -> String? {
        guard let type = UTType(filenameExtension: url.pathExtension) else {
            return nil
        }
        return type.preferredMIMEType
    }
}
