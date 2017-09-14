//
//  NetworkService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import Alamofire
import ObjectMapper

class NetworkService: INetworkService {
    
    private let BaseApi: String = "http://jsonplaceholder.typicode.com/"
    
    //MARK: INetworkService
    
    func FetchAllPosts(success: @escaping ([PostModel])->(), error: @escaping (Error?)->()) {
        FetchAllGeneric(type: PostModel.self, path: "posts", success: success, error: error)
    }
    
    func FetchAllUsers(success: @escaping ([UserModel])->(), error: @escaping (Error?)->()) {
        FetchAllGeneric(type: UserModel.self, path: "users", success: success, error: error)
    }
    
    func FetchAllAlbums(success: @escaping ([AlbumModel])->(), error: @escaping (Error?)->()) {
        FetchAllGeneric(type: AlbumModel.self, path: "albums", success: success, error: error)
    }
    
    func FetchAllPhotos(success: @escaping ([PhotoModel])->(), error: @escaping (Error?)->()) {
        FetchAllGeneric(type: PhotoModel.self, path: "photos", success: success, error: error)
    }
    

    //MARK: Private
    
    private func GenerateEndpoint(path: String) -> String {
        var temp = path
        if temp.characters.first == "/" {
            temp.characters.removeFirst()
        }
        return BaseApi + path
    }
    
    private func FetchAllGeneric<T>(type: T.Type, path: String, success: @escaping ([T])->(), error: @escaping (Error?)->()) where T:BaseMappable {
        Alamofire.request( GenerateEndpoint(path: path) ).responseArray {
            (response: DataResponse<[T]>) in
            
            response.result.ifSuccess {
                success(response.value!)
            }
            
            response.result.ifFailure {
                error(response.result.error)
            }
        }
    }
}
