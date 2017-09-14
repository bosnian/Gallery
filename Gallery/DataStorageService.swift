//
//  DataStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import CoreData
import UIKit
import Swinject

class DataStorageService {
    
    let context: NSManagedObjectContext
    let DI: Container
    
    init(ctx: NSManagedObjectContext, container: Container) {
        context = ctx
        DI = container
    }
}
