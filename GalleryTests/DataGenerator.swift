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
    static func GenerateUsers() -> [UserModel] {
        return ReadDataBasedOnTypes(type: UserModel.self, fileName: "users")
    }
    
    static func GeneratePosts() -> [PostModel] {
        return ReadDataBasedOnTypes(type: PostModel.self, fileName: "posts")
    }
    
    static func GenerateAlbums() -> [AlbumModel] {
        return ReadDataBasedOnTypes(type: AlbumModel.self, fileName: "albums")
    }
    
    static func GeneratePhotos() -> [PhotoModel] {
        return ReadDataBasedOnTypes(type: PhotoModel.self, fileName: "photos")

    }
    
    private static func ReadDataBasedOnTypes<T>(type: T.Type, fileName: String) -> [T] where T: BaseMappable {
        let testBundle = Bundle(for: self)
        if let file = testBundle.url(forResource: fileName, withExtension: "json") {
            let data = try! Data(contentsOf: file)
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            return Mapper<T>().mapArray(JSONObject: json)!
        }
        return [T]()
    }
}
