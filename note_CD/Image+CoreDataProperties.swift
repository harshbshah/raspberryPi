//
//  Image+CoreDataProperties.swift
//  note_CD
//
//  Created by Marcel Harvan on 2017-04-22.
//  Copyright © 2017 The Marcel's fake Company. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var toNotes: Notes?

}
