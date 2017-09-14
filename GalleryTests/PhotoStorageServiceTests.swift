//
//  PhotoStorageServiceTests.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//


import XCTest

@testable import Gallery

class PhotoStorageServiceTests: BaseTestCase {
    
    var photoStorageService: IPhotoStorageService?
    
    override func setUp() {
        super.setUp()
        photoStorageService = DI.resolve(IPhotoStorageService.self)
        
        let albumStorageService = DI.resolve(IAlbumStorageService.self)
        albumStorageService!.Sync(albums: DataGenerator.GenerateAlbums())
    }
    
    func testGetAll() {
        
        let photos = DataGenerator.GeneratePhotos()
        photoStorageService!.Sync(photos: photos)
        
        let storedPhotos = photoStorageService!.GetAll()
        
        XCTAssertEqual(photos.count, storedPhotos.count)
    }
    
    func testGetId() {
        
        let photos = DataGenerator.GeneratePhotos()
        photoStorageService!.Sync(photos: photos)
        let photo = photos.first!
        
        let storedPhoto = photoStorageService!.Get(id: photo.id!)
        
        XCTAssertNotNil(storedPhoto)
        XCTAssertEqual(Int64(photo.id!), storedPhoto!.id)
    }
    
    func testGetIdUnknown() {
        
        let photos = DataGenerator.GeneratePhotos()
        photoStorageService!.Sync(photos: photos)
        
        let storedPhoto = photoStorageService!.Get(id: 12345)
        
        XCTAssertNil(storedPhoto)
    }
    
    func testSyncBasic() {
        let photos = DataGenerator.GeneratePhotos()
        photoStorageService!.Sync(photos: photos)
        
        let storedPhotos = photoStorageService!.GetAll()
        
        XCTAssertEqual(photos.count, storedPhotos.count)
        
        for sp in storedPhotos {
            
            let p = photos.first(where: {
                photo in
                
                if Int64(photo.id!) == sp.id {
                    return true
                }
                return false
            })
            XCTAssertNotNil(p)
            XCTAssertEqual(Int64(p!.id!), sp.id)
            XCTAssertEqual(p!.title, sp.title)
            XCTAssertEqual(p!.url, sp.url)
            XCTAssertNotNil(sp.album)
        }
    }
    
    func testSyncRemove() {
        var photos = DataGenerator.GeneratePhotos()
        photoStorageService!.Sync(photos: photos)
        
        
        photos.removeLast()
        photoStorageService!.Sync(photos: photos)
        let storedPhotos = photoStorageService!.GetAll()
        
        
        XCTAssertEqual(photos.count, storedPhotos.count)
    }
    
    func testSyncUpdate() {
        var photos = DataGenerator.GeneratePhotos()
        photoStorageService!.Sync(photos: photos)
        
        let photo = photos[0]
        photo.title = "DEMO"
        photo.url = "DEMO DEMO"
        photos[0] = photo
        
        photoStorageService!.Sync(photos: photos)
        let storedPhoto = photoStorageService!.Get(id: photo.id!)
        let storedPhotos = photoStorageService!.GetAll()
        
        XCTAssertNotNil(storedPhoto)
        XCTAssertNotNil(storedPhotos)
        XCTAssertEqual(photos.count, storedPhotos.count)
        XCTAssertEqual(photo.title, storedPhoto!.title)
        XCTAssertEqual(photo.url, storedPhoto!.url)
    }
    
    func testSyncAdd() {
        var photos = DataGenerator.GeneratePhotos()
        photoStorageService!.Sync(photos: photos)
        
        let photo = PhotoModel()
        photo.id = 9999
        photo.title = "DEMO"
        photo.url = "DEMO DEMO"
        photo.albumId = 1
        
        photos.append(photo)
        
        photoStorageService!.Sync(photos: photos)
        let storedPhoto = photoStorageService!.Get(id: photo.id!)
        let storedPhotos = photoStorageService!.GetAll()
        
        XCTAssertNotNil(storedPhoto)
        XCTAssertNotNil(storedPhotos)
        XCTAssertEqual(photos.count, storedPhotos.count)
        XCTAssertEqual(photo.title, storedPhoto!.title)
        XCTAssertEqual(photo.url, storedPhoto!.url)
        XCTAssertNotNil(storedPhoto!.album)
    }
}
