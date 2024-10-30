//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 27.10.24..
//
import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "token")
        }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: "token")
            } else {
                UserDefaults.standard.removeObject(forKey: "token")
            }
        }
    }
}
