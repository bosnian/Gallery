//
//  NetworkServiceTests.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import XCTest
import UIKit
import Alamofire
import ObjectMapper

@testable import Gallery

class NetworkServiceTests: BaseTestCase {
    
    let networkService: INetworkService = NetworkService()
    
    func testAlamofireObjectMapper() {
        
        let exp = expectation(description: "Get Forecast")
        
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/f583be1121dbc5e9b0381b3017718a70c31054f7/sample_array_json"
        Alamofire.request(URL).responseArray { (response: DataResponse<[Forecast]>) in
            
            let forecastArray = response.value
            XCTAssertEqual(3,forecastArray?.count)
            exp.fulfill()
        }
        
         waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testAlamofireFirst() {
        let exp = expectation(description: "Get Forecast")
        
        let URL = "http://jsonplaceholder.typicode.com/posts/"
        Alamofire.request(URL).responseArray { (response: DataResponse<[PostModel]>) in
            
            XCTAssertEqual(response.value?.count, response.result.value?.count)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchAllPosts() {
        
        let exp = expectation(description: "Get Posts")
        
        networkService.FetchAllPosts(success: { (posts) in
            XCTAssertEqual(100,posts.count) //Bug in alamofire? Sometimes returns 101
            exp.fulfill()
        }) { (error) in
            XCTFail("Could not get posts!")
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    
    func testFetchAllUsers() {
        
        let exp = expectation(description: "Get Users")
        
        networkService.FetchAllUsers(success: { (users) in
            XCTAssertEqual(10,users.count)
            exp.fulfill()
        }) { (error) in
            XCTFail("Could not get users!")
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchAllAlbums() {
        
        let exp = expectation(description: "Get Albums")
        
        networkService.FetchAllAlbums(success: { (albums) in
            XCTAssertEqual(100,albums.count)
            exp.fulfill()
        }) { (error) in
            XCTFail("Could not get albums!")
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchAllPhotos() {
        
        let exp = expectation(description: "Get Photos")
        
        networkService.FetchAllPhotos(success: { (photos) in
            XCTAssertEqual(5000,photos.count)
            exp.fulfill()
        }) { (error) in
            XCTFail("Could not get photos!")
            exp.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}

//Dummy
class Forecast: Mappable {
    var day: String?
    var temperature: Int?
    var conditions: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        day <- map["day"]
        temperature <- map["temperature"]
        conditions <- map["conditions"]
    }
}
