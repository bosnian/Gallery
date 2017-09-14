//
//  GeoCoModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class GeoCoModel: Mappable {
    
    var lat: String?
    var lng: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}
