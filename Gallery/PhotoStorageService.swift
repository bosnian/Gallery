//
//  PhotoStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import CoreData
import Swinject

class PhotoStorageService: DataStorageService, IPhotoStorageService {

    private let _albumStorageService: IAlbumStorageService
    
    override init(ctx: NSManagedObjectContext, container: Container) {
        _albumStorageService = container.resolve(IAlbumStorageService.self)!
        super.init(ctx: ctx, container: container)
    }
    
    
    func GetAll() -> [PhotoModelCD] {
        return GetAll(type: PhotoModelCD.self)
    }
    
    func Get(id: Int) -> PhotoModelCD? {
        let request = GetRequest(type: PhotoModelCD.self,id: id)
        
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
    
    func Sync(photos: [PhotoModel]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "PhotoModelCD", in: context)!
        
        var savedPhotos = GetAll()
        
        
        for photo in photos {
            
            var p: PhotoModelCD?
            
            //Check if exists
            p = savedPhotos.first(where: {
                m in
                if m.id == Int64(photo.id!){
                    return true
                }
                return false
            })
            
            if let p = p {
                savedPhotos.remove(at: savedPhotos.index(of: p)!)
            } else {
                p = PhotoModelCD(entity: entity, insertInto: context) //Create new one if does not exits
            }
            
            p?.id = Int64(photo.id!)
            p?.albumId = Int64(photo.albumId!)
            p?.title = photo.title
            p?.url = photo.url
            p?.thumbnailUrl = photo.thumbnailUrl
            p?.album = _albumStorageService.Get(id: photo.albumId!)
        }
        
        //Remove objects that were not updated
        for sp in savedPhotos {
            context.delete(sp)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
