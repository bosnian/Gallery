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
    
    func GetAll<T>(type: T.Type) -> [T] where T: NSManagedObject {
        
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))

        do {
            return try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return [T]();
    }
    
    func GetRequest<T>(type: T.Type, id: Int) -> NSFetchRequest<T> where T: NSManagedObject {
        
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = NSPredicate(format: "id = \(id)")
        return request
    }
    
    func GetEntity<T>(type: T.Type) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: String(describing: T.self), in: context)!
    }
    
    func Save() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
