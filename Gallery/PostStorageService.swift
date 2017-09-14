//
//  PostStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import CoreData
import Swinject

class PostStorageService: DataStorageService, IPostStorageService {
    
    private let _userStorageService: IUserStorageService
    
    override init(ctx: NSManagedObjectContext, container: Container) {
        _userStorageService = container.resolve(IUserStorageService.self)!
        super.init(ctx: ctx, container: container)
    }
    
    func GetAll() -> [PostModelCD] {
        return GetAll(type: PostModelCD.self)
    }
    
    func Get(id: Int) -> PostModelCD? {
        let request = GetRequest(type: PostModelCD.self,id: id)
       
        do {
            let posts = try context.fetch(request)
            if let post = posts.first {
                return post
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func Sync(posts: [PostModel]) {
        
        let entity = GetEntity(type: PostModelCD.self)
        
        var savedPosts = GetAll()
        
        for post in posts {
            
            var p: PostModelCD?
            
            //Check if exists
            p = savedPosts.first(where: {
                m in
                if m.id == Int64(post.id!){
                    return true
                }
                return false
            })
            
            if let p = p {
                savedPosts.remove(at: savedPosts.index(of: p)!)
            } else {
                p = PostModelCD(entity: entity, insertInto: context) //Create new one if does not exits
            }

            
            p?.id = Int64(post.id!)
            p?.title = post.title
            p?.body = post.body
            p?.userId = Int64(post.userId!)
            p?.user = _userStorageService.Get(id: post.userId!)
        }
        
        //Remove objects that were not updated
        for sp in savedPosts {
            context.delete(sp)
        }
        Save()
    }
    
    func Remove(id: Int) {
        let request = NSFetchRequest<PostModelCD>(entityName: "PostModelCD")
        request.predicate = NSPredicate(format: "id = \(id)")
        
        do {
            let posts = try context.fetch(request)
            if let post = posts.first {
                context.delete(post)
                Save()
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
