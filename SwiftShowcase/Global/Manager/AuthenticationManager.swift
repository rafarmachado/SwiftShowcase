//
//  AuthenticationManager.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 05/12/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import Foundation
import ObjectMapper

class AuthenticationManager : NSObject{
    
    //MARK: Variables
    static let currentUserDefaults = UserDefaults.standard
    
    //MARK: Methods
    static func setCurrentUser(user: UserAuthenticationResponseRequest) -> UserAuthenticationResponseRequest?{
        var currentUser : UserAuthenticationResponseRequest?
        if let userString = user.toJSONString(){
            currentUser = user
            currentUserDefaults.set(userString, forKey: "CurrentUserKey")
        }
        return currentUser
    }
    
    static func getCurrentUser() -> UserAuthenticationResponseRequest?{
        if let user = currentUserDefaults.object(forKey: "CurrentUserKey") as? UserAuthenticationResponseRequest{
            return user
        }
        return nil
    }
    
    static func logOut()-> Bool{
        
        let user = currentUserDefaults.set(nil, forKey: "CurrentUserKey") as Any?
        
        if user == nil{
            return true
        }else{
            return false
        }
    }
    
}
