//
//  IAlbumStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

protocol IAlbumStorageService {
    
    func GetAll() -> [AlbumModelCD]
    
    func Get(id: Int) -> AlbumModelCD?
    
    func Sync(albums: [AlbumModel])
    
}
