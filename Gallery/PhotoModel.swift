//
//  PhotoModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class PhotoModel: BaseModel {
    
    var albumId: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        albumId         <- map["albumId"]
        title           <- map["title"]
        url             <- map["url"]
        thumbnailUrl    <- map["thumbnailUrl"]
    }
}
