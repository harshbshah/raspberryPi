//
//  Notes+CoreDataClass.swift
//  note_CD
//
//  Created by Marcel Harvan on 2017-04-22.
//  Copyright © 2017 The Marcel's fake Company. All rights reserved.
//

import Foundation
import CoreData


public class Notes: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
