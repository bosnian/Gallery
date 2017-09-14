//
//  IUserStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//


protocol IUserStorageService {
    
    func GetAll() -> [UsersModelCD]
    
    func Get(id: Int) -> UsersModelCD?
    
    func Sync(users: [UserModel])
    
}
