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
        case id, createdAt, updatedAt, width, height, color, blurHash, downloads, likes, likedByUser, description, urls = "urls"
    }
}
struct UrlsResult: Codable {
    let raw: String
    let full: String?
    let regular: String
    let small: String
    let thumb: String?  
    
    private enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
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
    
//    init(photoResult: PhotoResult) {
//        self.id = photoResult.id
//        self.size = CGSize(width: photoResult.width, height: photoResult.height)
//        self.createdAt = ISO8601DateFormatter().date(from: photoResult.createdAt ?? "")
//        self.welcomeDescription = photoResult.description
//        self.thumbImageURL = photoResult.urls.thumb
//        self.largeImageURL = photoResult.urls.full
//        self.isLiked = photoResult.likedByUser
//    }
}
