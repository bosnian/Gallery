//
//  BaseModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/14/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class BaseModel: Mappable {
    var id: Int?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id      <- map["id"]
    }
}
