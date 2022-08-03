//
//  SignUp.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import Foundation

class UserPostRequest {
    
    var realName: String?
    var password: String?
    var loginId: String?
    var birthDate: String?
    var phoneNumber: String?
    
    var userName: String {
        get {
            return realName!
        }
        set(new) {
            realName = new
        }
    }
    
    var userPW: String {
        get {
            return password!
        }
        set(new) {
            password = new
        }
    }
    
    var userID: String {
        get {
            return loginId!
        }
        set(new) {
            loginId = new
        }
    }
    
    var userBirth: String {
        get {
            return birthDate!
        }
        set(new) {
            birthDate = new
        }
    }
    
    var userPN: String {
        get {
            return phoneNumber!
        }
        set(new) {
            phoneNumber = new
        }
    }
    
}

