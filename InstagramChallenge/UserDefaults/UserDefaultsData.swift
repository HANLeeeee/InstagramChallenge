//
//  UserDefaults.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/04.
//

import Foundation

class UserDefaultsData {
    enum Key: String, CaseIterable {
        case jwt
    }
    
    static let shared: UserDefaultsData = {
        return UserDefaultsData()
    }()
    
    func removeAll() {
        Key.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    func setJWT(jwt: String) {
        UserDefaults.standard.setValue(jwt, forKey: "jwt")
        UserDefaults.standard.synchronize()
    }
    
    func getJWT() -> String {
        let jwt = UserDefaults.standard.string(forKey: "jwt") ?? ""
        return jwt
    }
    
    func setUserID(userID: String) {
        UserDefaults.standard.setValue(userID, forKey: "userID")
        UserDefaults.standard.synchronize()
    }
    
    func getUserID() -> String {
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
        return userID
    }
}
