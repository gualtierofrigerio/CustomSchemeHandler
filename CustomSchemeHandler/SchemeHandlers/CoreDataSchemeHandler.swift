//
//  CoreDataSchemeHandler.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 30/12/21.
//

import CoreData
import Foundation
import WebKit

class CoreDataSchemeHandler: NSObject, SchemeHandler {
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        let (response, data) = responseAndData(fromRequest: urlSchemeTask.request)
        
        urlSchemeTask.didReceive(response)
        if let data = data {
            urlSchemeTask.didReceive(data)
        }
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
    // MARK: - Private
    
    private var managedContext: NSManagedObjectContext?
    
    private func dataForURL(_ url: URL) -> Data? {
        guard let managedContext = managedContext else { return nil }
        let request = NSFetchRequest<Product>(entityName: "Product")
        request.predicate = CoreDataHelper.predicate(fromURL: url)
        guard let products = try? managedContext.fetch(request) else {
            return nil
        }
        let productsArray: [[String:String]] = products.map { $0.toDictionary() }
        return try? JSONEncoder().encode(productsArray)
    }
    
    private func productFromData(_ data: Data, context: NSManagedObjectContext) -> Product? {
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context
        return try? decoder.decode(Product.self, from: data)
    }
    
    private func responseAndData(fromRequest request: URLRequest) -> (URLResponse, Data?) {
        guard let url = request.url,
              let method = request.httpMethod else {
                  return Self.responseError(forUrl: request.url,
                                               message: "Error while parsing request")
              }
        if method == "POST" {
            return responseFromPOST(url: url, data: request.httpBody)
        }
        else {
            let data = dataForURL(url)
            let response = HTTPURLResponse.jsonResponse(url: url, data: data)
            return (response, data)
        }
    }
    
    
    private func responseFromPOST(url: URL, data: Data?) -> (URLResponse, Data?) {
        guard let context = managedContext else {
            return Self.responseError(forUrl: url,
                                      message: "Unable to access CoreData")
        }
        guard let data = data,
              let product = productFromData(data, context: context) else {
            return Self.responseError(forUrl: url,
                                         message: "Error while parsing request")
        }
        
        context.insert(product)
        
        do {
          try context.save()
        }
        catch let error as NSError {
            return Self.responseError(forUrl: url,
                                      message: "\(error), \(error.userInfo)")
        }
        let returnData = "success".data(using: .utf8)
        let response = HTTPURLResponse.jsonResponse(url: url, data: data)
        return (response, returnData)
    }
}
