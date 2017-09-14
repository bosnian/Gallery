//
//  AlbumStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//


import CoreData
import Swinject

class AlbumStorageService: DataStorageService, IAlbumStorageService {
    
    private let _userStorageService: IUserStorageService
    
    override init(ctx: NSManagedObjectContext, container: Container) {
        
        _userStorageService = container.resolve(IUserStorageService.self)!
        super.init(ctx: ctx, container: container)
    }
    
    func GetAll() -> [AlbumModelCD] {
        
        let request = NSFetchRequest<AlbumModelCD>(entityName: "AlbumModelCD")
        
        do {
            return try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return [AlbumModelCD]();
    }
    
    func Get(id: Int) -> AlbumModelCD? {
        let request = NSFetchRequest<AlbumModelCD>(entityName: "AlbumModelCD")
        request.predicate = NSPredicate(format: "id = \(id)")
        
        do {
            let users = try context.fetch(request)
            if let user = users.first {
                return user
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func Sync(albums: [AlbumModel]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AlbumModelCD", in: context)!
        
        var savedAlbums = GetAll()
        
        
        for album in albums {
            
            var a: AlbumModelCD?
            
            //Check if exists
            a = savedAlbums.first(where: {
                m in
                if m.id == Int64(album.id!){
                    return true
                }
                return false
            })
            
            if let a = a {
                savedAlbums.remove(at: savedAlbums.index(of: a)!)
            } else {
                a = AlbumModelCD(entity: entity, insertInto: context) //Create new one if does not exits
            }
            
            a?.id = Int64(album.id!)
            a?.title = album.title
            a?.userId = Int64(album.userId!)
            a?.user = _userStorageService.Get(id: album.userId!)
        }
        
        //Remove objects that were not updated
        for sa in savedAlbums {
            context.delete(sa)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
