//
//  UserAuthenticationResponseRequest.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 30/11/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import Foundation
import ObjectMapper


class UserAuthenticationResponseRequest: NSObject, Mappable {
    var name: String?
    var email: String?
    var password: String?
    var profileURL: String?
    var token: String?
    var isUsingFB: Bool?
    var photoBase64 : String?
    

    

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        password <- map["password"]
        profileURL <- map["profileURL"]
        isUsingFB <- map["isUsingFB"]
        token <- map["token"]
        photoBase64 <- map["photoBase64"]
    }
}
