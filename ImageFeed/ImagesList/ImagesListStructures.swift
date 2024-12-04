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
    let updatedAt: String?
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let downloads: Int?
    let likes: Int?
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width = "width"
        case height = "height"
        case color = "color"
        case blurHash = "blur_hash"
        case downloads = "downloads"
        case likes = "likes"
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls = "urls"
    }
}
struct UrlsResult: Codable {
    let raw: String
    let full: String?
    let regular: String
    let small: String
    let thumb: String?  
    
    private enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case full = "full"
        case regular = "regular"
        case small = "small"
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
