//
//  Profile.swift
//  ImageFeed
//
//  Created by N L on 10.11.24..
//
import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.userName ?? ""
        self.name = (profileResult.firstName ?? "") + " " + (profileResult.lastName ?? "")
        self.loginName = "@\(username)"
        self.bio = profileResult.bio
    }
}
