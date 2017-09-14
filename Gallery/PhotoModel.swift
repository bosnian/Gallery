//
//  PhotoModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class PhotoModel: Mappable {
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        albumId         <- map["albumId"]
        id              <- map["id"]
        title           <- map["title"]
        url             <- map["url"]
        thumbnailUrl    <- map["thumbnailUrl"]
    }
}
