//
//  PostModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class PostModel: BaseModel {
    
    var userId: Int?
    var title: String?
    var body: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId  <- map["userId"]
        id      <- map["id"]
        title   <- map["title"]
        body    <- map["body"]
    }
}
