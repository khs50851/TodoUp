//
//  Item+CoreDataProperties.swift
//  TodoUp
//
//  Created by user on 2023/04/10.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var checkdone: Bool
    @NSManaged public var content: String?
    @NSManaged public var createdate: Date?
    @NSManaged public var itemid: Int64
    @NSManaged public var color: Int64
    
    var dateString: String? {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        guard let date = self.createdate else {return ""}
        let dateToString = formater.string(from: date)
        return dateToString
    }
}

extension Item : Identifiable {

}
