//
//  PhotoStore.swift
//  Moestagram
//
//  Created by Shohei Sasamoto on 2015/03/23.
//  Copyright (c) 2015年 saxsir. All rights reserved.
//

import Foundation
import CoreData

class PhotoStore: NSManagedObject {

    @NSManaged var local_identifier: String
    @NSManaged var comment: String

}