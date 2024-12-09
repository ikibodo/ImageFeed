//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 8.12.24..
//
import Foundation

struct UrlsResult: Codable {
    let full: String?
    let thumb: String?
    
    private enum CodingKeys: String, CodingKey {
        case full = "full"
        case thumb = "thumb"
    }
}
