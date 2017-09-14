//
//  UserStorageServiceTests.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import XCTest

@testable import Gallery

class UserStorageServiceTests: BaseTestCase {
    
    var userStorageService: IUserStorageService?
    
    override func setUp() {
        super.setUp()
        userStorageService = DI.resolve(IUserStorageService.self)
    }
    
    func testGetAll() {
        
        let users = DataGenerator.GenerateUsers()
        userStorageService!.Sync(users: users)
        
        let storedUsers = userStorageService!.GetAll()
        
        XCTAssertEqual(users.count, storedUsers.count)
    }
    
    func testGetId() {
        
        let users = DataGenerator.GenerateUsers()
        userStorageService!.Sync(users: users)
        let user = users.first!
        
        let storedUser = userStorageService!.Get(id: user.id!)
        
        XCTAssertNotNil(storedUser)
        XCTAssertEqual(Int64(user.id!), storedUser!.id)
    }
    
    func testGetIdUnknown() {
        
        let users = DataGenerator.GenerateUsers()
        userStorageService!.Sync(users: users)
        
        let storedUser = userStorageService!.Get(id: 12345)
        
        XCTAssertNil(storedUser)
    }
    
    func testSyncBasic() {
        let users = DataGenerator.GenerateUsers()
        userStorageService!.Sync(users: users)
        
        let storedUsers = userStorageService!.GetAll()
        
        XCTAssertEqual(users.count, storedUsers.count)
        
        for su in storedUsers {
            
            let u = users.first(where: {
                user in
                
                if Int64(user.id!) == su.id {
                    return true
                }
                return false
            })
            XCTAssertNotNil(u)
            XCTAssertEqual(Int64(u!.id!), su.id)
            XCTAssertEqual(u!.name, su.name)
            XCTAssertEqual(u!.company!.name, su.company!.name)
        }
    }
    
    func testSyncRemove() {
        var users = DataGenerator.GenerateUsers()
        userStorageService!.Sync(users: users)
        
        
        users.removeLast()
        userStorageService!.Sync(users: users)
        let storedUsers = userStorageService!.GetAll()
        
        
        XCTAssertEqual(users.count, storedUsers.count)
    }
    
    func testSyncUpdate() {
        var users = DataGenerator.GenerateUsers()
        userStorageService!.Sync(users: users)
        
        let user = users[0]
        user.name = "DEMO"
        user.username = "DEMO DEMO"
        users[0] = user
        
        userStorageService!.Sync(users: users)
        let storedUser = userStorageService!.Get(id: user.id!)
        let storedUsers = userStorageService!.GetAll()
        
        XCTAssertNotNil(storedUser)
        XCTAssertNotNil(storedUsers)
        XCTAssertEqual(users.count, storedUsers.count)
        XCTAssertEqual(user.name, storedUser!.name)
        XCTAssertEqual(user.username, storedUser!.username)
    }
    
    func testSyncAdd() {
        var users = DataGenerator.GenerateUsers()
        userStorageService!.Sync(users: users)
        
        let user = UserModel()
        user.id = 100
        user.name = "DEMO"
        user.username = "DEMO DEMO"
        
        users.append(user)
        
        userStorageService!.Sync(users: users)
        let storedUser = userStorageService!.Get(id: user.id!)
        let storedUsers = userStorageService!.GetAll()
        
        XCTAssertNotNil(storedUser)
        XCTAssertNotNil(storedUsers)
        XCTAssertEqual(users.count, storedUsers.count)
        XCTAssertEqual(user.name, storedUser!.name)
        XCTAssertEqual(user.username, storedUser!.username)
    }
}
