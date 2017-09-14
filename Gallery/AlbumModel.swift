//
//  AlbumModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class AlbumModel: Mappable {
    var userId: Int?
    var id: Int?
    var title: String?
    
    init() { }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId  <- map["userId"]
        id      <- map["id"]
        title   <- map["title"]
    }
}
