//
//  AlbumModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class AlbumModel: BaseModel {
    
    var userId: Int?
    var title: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId  <- map["userId"]
        title   <- map["title"]
    }
}
