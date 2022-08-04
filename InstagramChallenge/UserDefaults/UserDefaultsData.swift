//
//  UserDefaults.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/04.
//

import Foundation

class UserDefaultsData {
    enum Key: String, CaseIterable {
        case userID, jwt
    }
    
    static let shared: UserDefaultsData = {
        return UserDefaultsData()
    }()
    
    func removeAll() {
        Key.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    func setToken(userID: String, jwt: String) {
        UserDefaults.standard.setValue(userID, forKey: "userID")
        UserDefaults.standard.setValue(jwt, forKey: "jwt")
        UserDefaults.standard.synchronize()
    }
    
    func getToken() -> UserToken {
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
        let jwt = UserDefaults.standard.string(forKey: "jwt") ?? ""
        return UserToken(loginId: userID, jwt: jwt)
    }
    

}
