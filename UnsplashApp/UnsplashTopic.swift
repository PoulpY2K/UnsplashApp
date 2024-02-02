//
//  UnsplashTopic.swift
//  UnsplashApp
//
//  Created by Jérémy Laurent on 02/02/2024.
//

import Foundation

struct UnsplashTopic: Codable {
    let id, slug, title, description: String
    let coverPhoto: CoverPhoto

    enum CodingKeys: String, CodingKey {
        case id, slug, title, description
        case coverPhoto = "cover_photo"
    }
}

struct CoverPhoto: Codable {
    let id, slug, color: String
    let urls: UnsplashPhotoUrls
}
