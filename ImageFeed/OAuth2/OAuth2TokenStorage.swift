//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 27.10.24..
//
import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "token")
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: "token")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "token")
            }
        }
    }
}

extension OAuth2TokenStorage {
    func cleanSession() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
