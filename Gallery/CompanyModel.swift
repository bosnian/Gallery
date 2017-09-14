//
//  CompanyModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class CompanyModel: Mappable {
    
    var name: String?
    var catchPhrase: String?
    var bs: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name        <- map["name"]
        catchPhrase <- map["catchPhrase"]
        bs          <- map["bs"]
    }
}
