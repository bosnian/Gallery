//
//  IPhotoStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

protocol IPhotoStorageService {
    
    func GetAll() -> [PhotoModelCD]
    
    func Get(id: Int) -> PhotoModelCD?
    
    func Sync(photos: [PhotoModel])
    
}
