//
//  IPostStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

protocol IPostStorageService {
    
    func GetAll() -> [PostModelCD]
    
    func Get(id: Int) -> PostModelCD?
    
    func Sync(posts: [PostModel])
    
    func Remove(id: Int)
    
}
