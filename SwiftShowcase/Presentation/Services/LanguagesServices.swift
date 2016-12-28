//
//  LanguageServices.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 01/12/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


class LanguageServices: NSObject {
    
    func languagesGet(completion:@escaping (_ response: ProgramingLanguageDTO?) -> Void){
        
        
        Alamofire.request("http://curso-iniciantes-1.getsandbox.com/collectionView/programmingLanguages", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { response in
            switch response.result {
            case .success:
                
                if let JSON = response.result.value {
                    var mapper = Mapper<ProgramingLanguageDTO>()
                    let languages = mapper.map(JSONString: JSON as! String)
                    print("JSON: \(JSON)")
                    completion(languages!)
                    
                }
                
            case .failure(let error):
                completion(nil)
                print(error)
            
                
            }
        })
        
    }
    
}
