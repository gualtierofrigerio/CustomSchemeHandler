//
//  ViewController.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHandlers()
        createWebView()
    }
    
    private var handlers: [SchemeHandlerEntry] = []

    private func createWebView() {
        let handler = WebViewHandler(withSchemeHandlers: handlers)
        view.addSubview(handler.webView)
        handler.webView.frame = view.frame
        
        guard let testURL = Bundle.main.url(forResource: "test",
                                            withExtension: "html",
                                            subdirectory: "assets") else { return }
        handler.loadRequest(URLRequest(url: testURL))
    }
    
    private func setupHandlers() {
        if let databasePath = Bundle.main.path(forResource: "db",
                                               ofType: "sqlite",
                                               inDirectory: "assets") {
            let schemeHandler = SchemeHandlerFactory.createWithType(.sqlite(databasePath: databasePath))
            let entry = SchemeHandlerEntry(schemeHandler: schemeHandler,
                                           urlScheme: "sqlite")
            handlers.append(entry)
        }
        
        let assetsHandler = AssetsSchemeHandler()
        let entry = SchemeHandlerEntry(schemeHandler: assetsHandler, urlScheme: "assets")
        handlers.append(entry)
        
        let coreDataHandler = CoreDataSchemeHandler()
        let coreDataEntry = SchemeHandlerEntry(schemeHandler: coreDataHandler,
                                               urlScheme: "coredata")
        handlers.append(coreDataEntry)
    }
}

