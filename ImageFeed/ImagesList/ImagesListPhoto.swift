//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 8.12.24..
//
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}
