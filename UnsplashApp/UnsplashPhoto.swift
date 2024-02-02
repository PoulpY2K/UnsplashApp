//
//  UnsplashPhoto.swift
//  UnsplashApp
//
//  Created by Jérémy Laurent on 02/02/2024.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id, slug: String
    let urls: UnsplashPhotoUrls
    let user: User
    let color: String;
}

struct UnsplashPhotoUrls: Codable {
    let raw, full, regular, small: String
    let thumb: String
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}

struct User: Codable {
    let name: String
}
