//
//  PostStorageServiceTests.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import XCTest

@testable import Gallery

class PostStorageServiceTests: BaseTestCase {
    
    var postStorageService: IPostStorageService?
    
    override func setUp() {
        super.setUp()
        postStorageService = DI.resolve(IPostStorageService.self)
        
        let userStorageService = DI.resolve(IUserStorageService.self)
        userStorageService!.Sync(users: DataGenerator.GenerateUsers())
        
        XCTWaiter().wait(for: [], timeout: 5, enforceOrder: false)
        
    }
    
    func testGetAll() {
        
        let posts = DataGenerator.GeneratePosts()
        postStorageService!.Sync(posts: posts)
        
        let storedPosts = postStorageService!.GetAll()
        
        XCTAssertEqual(posts.count, storedPosts.count)
    }
    
    func testGetId() {
        
        let posts = DataGenerator.GeneratePosts()
        postStorageService!.Sync(posts: posts)
        let post = posts.first!
        
        let storedPost = postStorageService!.Get(id: post.id!)
        
        XCTAssertNotNil(storedPost)
        XCTAssertEqual(Int64(post.id!), storedPost!.id)
    }
    
    func testGetIdUnknown() {
        
        let posts = DataGenerator.GeneratePosts()
        postStorageService!.Sync(posts: posts)
        
        let storedPost = postStorageService!.Get(id: 12345)
        
        XCTAssertNil(storedPost)
    }
    
    func testSyncBasic() {
        let posts = DataGenerator.GeneratePosts()
        postStorageService!.Sync(posts: posts)
        
        let storedPosts = postStorageService!.GetAll()
        
        XCTAssertEqual(posts.count, storedPosts.count)
        
        for sp in storedPosts {
            
            let p = posts.first(where: {
                post in
                
                if Int64(post.id!) == sp.id {
                    return true
                }
                return false
            })
            XCTAssertNotNil(p)
            XCTAssertEqual(Int64(p!.id!), sp.id)
            XCTAssertEqual(p!.title, sp.title)
            XCTAssertEqual(p!.body, sp.body)
            if sp.user == nil {
                
            }
            XCTAssertNotNil(sp.user)
        }
    }
    
    func testSyncRemove() {
        var posts = DataGenerator.GeneratePosts()
        postStorageService!.Sync(posts: posts)
        
        
        posts.removeLast()
        postStorageService!.Sync(posts: posts)
        let storedPosts = postStorageService!.GetAll()
        
        
        XCTAssertEqual(posts.count, storedPosts.count)
    }
    
    func testSyncUpdate() {
        var posts = DataGenerator.GeneratePosts()
        postStorageService!.Sync(posts: posts)
        
        let post = posts[0]
        post.title = "DEMO"
        post.body = "DEMO DEMO"
        posts[0] = post
        
        postStorageService!.Sync(posts: posts)
        let storedPost = postStorageService!.Get(id: post.id!)
        let storedPosts = postStorageService!.GetAll()
        
        XCTAssertNotNil(storedPost)
        XCTAssertNotNil(storedPosts)
        XCTAssertEqual(posts.count, storedPosts.count)
        XCTAssertEqual(post.title, storedPost!.title)
        XCTAssertEqual(post.body, storedPost!.body)
    }
    
    func testSyncAdd() {
        var posts = DataGenerator.GeneratePosts()
        postStorageService!.Sync(posts: posts)
        
        let post = PostModel()
        post.id = 4321
        post.title = "DEMO"
        post.body = "DEMO DEMO"
        post.userId = 1
        
        posts.append(post)
        
        postStorageService!.Sync(posts: posts)
        let storedPost = postStorageService!.Get(id: post.id!)
        let storedPosts = postStorageService!.GetAll()
        
        XCTAssertNotNil(storedPost)
        XCTAssertNotNil(storedPosts)
        XCTAssertEqual(posts.count, storedPosts.count)
        XCTAssertEqual(post.title, storedPost!.title)
        XCTAssertEqual(post.body, storedPost!.body)
        XCTAssertNotNil(storedPost!.user)
    }
}
