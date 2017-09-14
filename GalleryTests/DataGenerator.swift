//
//  DataGenerator.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//
import Foundation
import ObjectMapper

@testable import Gallery

class DataGenerator {
    class func GenerateUsers() -> [UserModel] {
        let testBundle = Bundle(for: self)
        if let file = testBundle.url(forResource: "users", withExtension: "json") {
            let data = try! Data(contentsOf: file)
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            return Mapper<UserModel>().mapArray(JSONObject: json)!
        }
        return [UserModel]()
    }
    
    class func GeneratePosts() -> [PostModel] {
        let testBundle = Bundle(for: self)
        if let file = testBundle.url(forResource: "posts", withExtension: "json") {
            let data = try! Data(contentsOf: file)
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            return Mapper<PostModel>().mapArray(JSONObject: json)!
        }
        return [PostModel]()
    }
    
    class func GenerateAlbums() -> [AlbumModel] {
        let testBundle = Bundle(for: self)
        if let file = testBundle.url(forResource: "albums", withExtension: "json") {
            let data = try! Data(contentsOf: file)
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            return Mapper<AlbumModel>().mapArray(JSONObject: json)!
        }
        return [AlbumModel]()
    }
    
    class func GeneratePhotos() -> [PhotoModel] {
        let testBundle = Bundle(for: self)
        if let file = testBundle.url(forResource: "photos", withExtension: "json") {
            let data = try! Data(contentsOf: file)
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            return Mapper<PhotoModel>().mapArray(JSONObject: json)!
        }
        return [PhotoModel]()
    }
}
