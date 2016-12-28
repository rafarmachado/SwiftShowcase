//
//  ProgramingLanguageResponseRequest.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 30/11/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import Foundation
import ObjectMapper


class ProgramingLanguageResponse: NSObject, Mappable {
    var name: String?
    var desc: String?
    var imageURL: String?
    
 
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        desc <- map["desc"]
        imageURL <- map["imageURL"]
    }
}
