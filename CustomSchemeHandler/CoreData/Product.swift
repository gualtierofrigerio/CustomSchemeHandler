//
//  Product.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 02/01/22.
//

import CoreData
import Foundation

class Product: NSManagedObject, Decodable {
    @NSManaged public var name: String
    @NSManaged public var price: String
    
    required convenience init(from decoder: Decoder) throws {
        guard let managedObjectContextKey = CodingUserInfoKey(rawValue: "managedObjectContext") else {
            fatalError("cannot find manageObjectContext in info key")
        }
        guard let managedObjectContext = decoder.userInfo[managedObjectContextKey] as? NSManagedObjectContext else {
            fatalError("cannot Retrieve context")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "Product",
                                                      in: managedObjectContext) else {
            fatalError("cannot retrieve entity")
        }
        self.init(entity: entity, insertInto: nil)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let nameString = try values.decodeIfPresent(String.self, forKey: .name) {
            self.name = nameString
        }
        if let priceString = try values.decodeIfPresent(String.self, forKey: .price) {
            self.price = priceString
        }
        
    }
}

fileprivate enum CodingKeys: String, CodingKey {
    case name
    case price
}
