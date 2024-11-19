//
//  ProfileImagesStructures.swift
//  ImageFeed
//
//  Created by N L on 12.11.24..
//
import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}
