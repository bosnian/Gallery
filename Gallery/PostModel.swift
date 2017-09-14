//
//  PostModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class PostModel: Mappable {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        userId  <- map["userId"]
        id      <- map["id"]
        title   <- map["title"]
        body    <- map["body"]
    }
}
