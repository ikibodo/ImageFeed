//
//  ImagesListStructures.swift
//  ImageFeed
//
//  Created by N L on 1.12.24..
//
import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int?
    let height: Int?
    let likedByUser: Bool?
    let description: String?
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case width = "width"
        case height = "height"
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls = "urls"
    }
}
struct UrlsResult: Codable {
    let full: String?
    let thumb: String?
    
    private enum CodingKeys: String, CodingKey {
        case full = "full"
        case thumb = "thumb"
    }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}

struct LikeResult: Codable {
    let photo: PhotoResult?
}
