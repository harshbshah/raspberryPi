//
//  Notes+CoreDataProperties.swift
//  note_CD
//
//  Created by Marcel Harvan on 2017-04-22.
//  Copyright © 2017 The Marcel's fake Company. All rights reserved.
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var note_content: NSObject?
    @NSManaged public var toImage: Image?

}
