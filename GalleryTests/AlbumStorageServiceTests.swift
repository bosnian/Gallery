//
//  AlbumStorageServiceTests.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//


import XCTest

@testable import Gallery

class AlbumStorageServiceTests: BaseTestCase {
    
    var albumStorageService: IAlbumStorageService?
    
    override func setUp() {
        super.setUp()
        albumStorageService = DI.resolve(IAlbumStorageService.self)
        
        let userStorageService = DI.resolve(IUserStorageService.self)
        userStorageService!.Sync(users: DataGenerator.GenerateUsers())
    }
    
    func testGetAll() {
        
        let albums = DataGenerator.GenerateAlbums()
        albumStorageService!.Sync(albums: albums)
        
        let storedAlbums = albumStorageService!.GetAll()
        
        XCTAssertEqual(albums.count, storedAlbums.count)
    }
    
    func testGetId() {
        
        let albums = DataGenerator.GenerateAlbums()
        albumStorageService!.Sync(albums: albums)
        let album = albums.first!
        
        let storedAlbum = albumStorageService!.Get(id: album.id!)
        
        XCTAssertNotNil(storedAlbum)
        XCTAssertEqual(Int64(album.id!), storedAlbum!.id)
    }
    
    func testGetIdUnknown() {
        
        let albums = DataGenerator.GenerateAlbums()
        albumStorageService!.Sync(albums: albums)
        
        let storedAlbum = albumStorageService!.Get(id: 12345)
        
        XCTAssertNil(storedAlbum)
    }
    
    func testSyncBasic() {
        let albums = DataGenerator.GenerateAlbums()
        albumStorageService!.Sync(albums: albums)
        
        let storedAlbums = albumStorageService!.GetAll()
        
        XCTAssertEqual(albums.count, storedAlbums.count)
        
        for sa in storedAlbums {
            
            let a = albums.first(where: {
                album in
                
                if Int64(album.id!) == sa.id {
                    return true
                }
                return false
            })
            XCTAssertNotNil(a)
            XCTAssertEqual(Int64(a!.id!), sa.id)
            XCTAssertEqual(a!.title, sa.title)
        }
    }
    
    func testSyncRemove() {
        var albums = DataGenerator.GenerateAlbums()
        albumStorageService!.Sync(albums: albums)
        
        
        albums.removeLast()
        albumStorageService!.Sync(albums: albums)
        let storedAlbums = albumStorageService!.GetAll()
        
        
        XCTAssertEqual(albums.count, storedAlbums.count)
    }
    
    func testSyncUpdate() {
        var albums = DataGenerator.GenerateAlbums()
        albumStorageService!.Sync(albums: albums)
        
        let album = albums[0]
        album.title = "DEMO"
        albums[0] = album
        
        albumStorageService!.Sync(albums: albums)
        let storedAlbum = albumStorageService!.Get(id: album.id!)
        let storedAlbums = albumStorageService!.GetAll()
        
        XCTAssertNotNil(storedAlbum)
        XCTAssertNotNil(storedAlbums)
        XCTAssertEqual(albums.count, storedAlbums.count)
        XCTAssertEqual(album.title, storedAlbum!.title)
    }
    
    func testSyncAdd() {
        var albums = DataGenerator.GenerateAlbums()
        albumStorageService!.Sync(albums: albums)
        
        let album = AlbumModel()
        album.id = 4321
        album.title = "DEMO"
        album.userId = 1
        
        albums.append(album)
        
        albumStorageService!.Sync(albums: albums)
        let storedAlbum = albumStorageService!.Get(id: album.id!)
        let storedAlbums = albumStorageService!.GetAll()
        
        XCTAssertNotNil(storedAlbum)
        XCTAssertNotNil(storedAlbums)
        XCTAssertEqual(albums.count, storedAlbums.count)
        XCTAssertEqual(album.title, storedAlbum!.title)
        XCTAssertNotNil(storedAlbum!.user)
    }
}
