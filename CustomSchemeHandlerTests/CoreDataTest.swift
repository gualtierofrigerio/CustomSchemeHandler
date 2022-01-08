//
//  CoreDataTest.swift
//  CustomSchemeHandlerTests
//
//  Created by Gualtiero Frigerio on 06/01/22.
//

import CoreData
import Foundation
import UIKit

class CoreDataTest {
    private (set) var container: NSPersistentContainer
    private (set) var context: NSManagedObjectContext
    
    init() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        container = NSPersistentContainer(name: "CustomSchemeHandler")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { description, error in
            assert(error == nil, "Count not load persistent store")
        }
        
        context = container.newBackgroundContext()
    }
    
    func loadTestData() throws {
        let product1 = try product(withName: "Name1")
        container.viewContext.insert(product1)
        try container.viewContext.save()
    }
    
    func data(forProductName name: String) -> Data? {
        let product = try? product(withName: name)
        return try? JSONEncoder().encode(product)
    }
    
    func dataArray(forProductName name: String) -> Data? {
        let product = try? product(withName: name)
        return try? JSONEncoder().encode([product])
    }
    
    func product(withName name: String) throws -> Product {
        let dictionary = ["name" : name, "price" : "1234"]
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed)
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context
        return try decoder.decode(Product.self, from: data)
    }
}

