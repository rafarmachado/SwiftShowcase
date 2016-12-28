//
//  ProgramingLanguageDTO.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 08/12/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import Foundation
import ObjectMapper

class ProgramingLanguageDTO: NSObject, Mappable{

    var programingLanguageResponseRequest : [ProgramingLanguageResponse]?
    
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    func mapping(map: Map){
        programingLanguageResponseRequest <- map ["programmingLanguages"]
    }

}
