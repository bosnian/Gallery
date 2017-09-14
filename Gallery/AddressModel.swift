//
//  AddressModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class AddressModel: Mappable {
    
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: GeoCoModel?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        street      <- map["street"]
        suite       <- map["suite"]
        city        <- map["city"]
        zipcode     <- map["zipcode"]
        geo         <- map["geo"]
    }
}
