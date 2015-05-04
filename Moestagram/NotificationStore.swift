//
//  NotificationStore.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/04/18.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import Foundation
import CoreData

@objc(NotificationStore)
class NotificationStore: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var body: String
    @NSManaged var fire_date: NSDate
    @NSManaged var is_checked: Bool
    @NSManaged var image_file: String

}