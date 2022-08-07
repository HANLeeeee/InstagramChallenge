//
//  UserKakaoSignUpRequest.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/04.
//

import Foundation

class UserKakaoSignUpRequest {
    var accessToken: String?
    var realName: String?
    var birthDate: String?
    var loginId: String?
    var phoneNumber: String?
    
    var kakaoToken: String {
        get {
            return accessToken!
        }
        set(new) {
            accessToken = new
        }
    }
    
    var userName: String {
        get {
            return realName!
        }
        set(new) {
            realName = new
        }
    }
    
    var useBirth: String {
        get {
            return birthDate!
        }
        set(new) {
            birthDate = new
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
    
    var userPN: String {
        get {
            return phoneNumber!
        }
        set(new) {
            phoneNumber = new
        }
    }
    
}
