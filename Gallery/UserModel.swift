//
//  UserModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/11/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import ObjectMapper

class UserModel: Mappable {

    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var address: AddressModel?
    var phone: String?
    var website: String?
    var company: CompanyModel?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
        email <- map["email"]
        address <- map["address"]
        phone <- map["phone"]
        website <- map["website"]
        company <- map["company"]
    }
}
