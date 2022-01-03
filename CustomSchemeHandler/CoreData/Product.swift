//
//  Product.swift
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 02/01/22.
//

import CoreData
import Foundation

public class Product: NSManagedObject, Decodable {
    @NSManaged public var name: String
    @NSManaged public var price: String
    
    public required convenience init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
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

extension Product: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.price, forKey: .price)
    }
}

extension Product {
    func toDictionary() -> [String:String] {
        ["name" : name, "price" : price]
    }
}

fileprivate enum CodingKeys: String, CodingKey {
    case name
    case price
}
