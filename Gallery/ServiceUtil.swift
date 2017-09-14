//
//  ServiceUtil.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import Swinject
import UIKit
import CoreData

let DI = Container()

class ServiceUtil {
    static func RegisterServices() {
        let ctx = getPersistedContext()
        
        DI.register(IUserStorageService.self, factory: { _ in UserStorageService(ctx: ctx, container: DI) })
        DI.register(IPostStorageService.self, factory: { _ in PostStorageService(ctx: ctx, container: DI) })
        DI.register(IAlbumStorageService.self, factory: { _ in AlbumStorageService(ctx: ctx, container: DI) })
        DI.register(IPhotoStorageService.self, factory: { _ in PhotoStorageService(ctx: ctx, container: DI) })
        DI.register(INetworkService.self, factory: { _ in NetworkService() })
    
    }
    
    static func RegisterServicesInMemory(container: Container)->Container {
        let ctx = GetInMemoryContext()
        
        container.register(IUserStorageService.self, factory: { _ in UserStorageService(ctx: ctx, container: container) })
        container.register(IPostStorageService.self, factory: { _ in PostStorageService(ctx: ctx, container: container) })
        container.register(IAlbumStorageService.self, factory: { _ in AlbumStorageService(ctx: ctx, container: container) })
        container.register(IPhotoStorageService.self, factory: { _ in PhotoStorageService(ctx: ctx, container: container) })
        container.register(INetworkService.self, factory: { _ in NetworkService() })
        
        return container
    }
    
    static func RemoveAll(container: Container) {
        container.removeAll()
    }
    
    private static func getPersistedContext() -> NSManagedObjectContext {
        let del = UIApplication.shared.delegate as! AppDelegate
        return del.persistentContainer.viewContext
    }
    
    static func GetInMemoryContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
