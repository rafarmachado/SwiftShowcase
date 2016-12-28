//
//  AuthenticationServices.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 01/12/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


class AuthenticationServices: NSObject {
    
//    //MARK: Register USER
//    func registerToServer(user: UserAuthenticationResponseRequest){
//        let dictUserData = [
//            "name" : user.name!,
//            "email" : user.email!,
//            "password" : user.password!,
//            "profileURL" : user.profileURL!,
//            "isUsingFB" : user.isUsingFB!
//            ] as [String : Any]
//        
//        
//        Alamofire.request("http://curso-iniciantes-1.getsandbox.com/users/register", method: .post, parameters: dictUserData, encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            
//            switch response.result {
//            case .success:
//                
//                if let JSON = response.result.value {
//                    var mapper = Mapper<UserAuthenticationResponseRequest>()
//                    let user = mapper.map(JSONString: JSON as! String)
//                    print("JSON: \(JSON)")
//                    var x = 1
//                    
//                    
//                }
//                
//            case .failure(let error):
//                print(error)
//            }
//        })
//    }
//    
    
    
    func registerToServer(request: UserAuthenticationResponseRequest, completion:@escaping (_ response: UserAuthenticationResponseRequest?) -> Void){
                let dictUserData = [
                    "name" : request.name!,
                    "email" : request.email!,
                    "password" : request.password!,
                    "profileURL" : request.profileURL!,
                    "isUsingFB" : request.isUsingFB!
                    ] as [String : Any]

        
        Alamofire.request("http://curso-iniciantes-1.getsandbox.com/users/register", method: .post, parameters: dictUserData, encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { response in
            switch response.result {
            case .success:

                if let JSON = response.result.value {
                    var mapper = Mapper<UserAuthenticationResponseRequest>()
                    let user = mapper.map(JSONString: JSON as! String)
                    print("JSON: \(JSON)")
                    completion(user!)
                    
                }
                
            case .failure(let error):
                completion(nil)
                print(error)
                
            }
        })

    }
    
    func sendRequestLogin(user : UserAuthenticationResponseRequest, completion:@escaping (_ response: UserAuthenticationResponseRequest?) -> Void){
        let dictionary = ["email" : user.email,
                          "password" : user.password] as [String : Any]
        
        Alamofire.request("http://curso-iniciantes-1.getsandbox.com/users/login", method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<300).responseString(completionHandler: { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value {
                    let mapper = Mapper<UserAuthenticationResponseRequest>()
                    let user = mapper.map(JSONString: JSON )
                    print("JSON: \(user?.token)")
                    completion(user)
                }
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    
    

}
