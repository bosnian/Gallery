//
//  INetworkService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

protocol INetworkService {
    
    func FetchAllPosts(success: @escaping ([PostModel])->(), error: @escaping (Error?)->())
    
    func FetchAllUsers(success: @escaping ([UserModel])->(), error: @escaping (Error?)->())
    
    func FetchAllAlbums(success: @escaping ([AlbumModel])->(), error: @escaping (Error?)->())
    
    func FetchAllPhotos(success: @escaping ([PhotoModel])->(), error: @escaping (Error?)->())
}
