//
//  UnsplashAPI.swift
//  UnsplashApp
//
//  Created by Jérémy Laurent on 02/02/2024.
//

import Foundation

struct UnsplashAPI {
    let baseUrl: String = "https://api.unsplash.com"
    let scheme: String = "https"
    let host: String = "api.unsplash.com"
    let clientIdQueryParam: String = "client_id"
    
    let photosPath: String = "/photos"
    let topicsPath: String = "/topics"
    
    // Construit un objet URLComponents avec la base de l'API Unsplash
    // Et un query item "client_id" avec la clé d'API retrouvé depuis PListManager
    func unsplashApiBaseUrl() -> URLComponents {
        var components = URLComponents()
        let clientIdQueryItem = URLQueryItem(name: clientIdQueryParam, value: ConfigurationManager.instance.plistDictionnary.clientId)
        
        components.scheme = scheme
        components.host = host
        components.queryItems = [clientIdQueryItem]
                
        return components
    }

    // Par défaut orderBy = "popular" et perPage = 10 -> Lisez la documentation de l'API pour comprendre les paramètres, vous pouvez aussi en ajouter d'autres si vous le souhaitez
    func feedUrl(orderBy: String = "popular", perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl()
        components.path += photosPath
        
        let orderByQueryItem = URLQueryItem(name: "order_by", value: orderBy)
        let perPageQueryItem = URLQueryItem(name: "per_page", value: "\(perPage)")
        
        if components.queryItems != nil {
            components.queryItems! += [orderByQueryItem, perPageQueryItem]
        }
                
        return components.url
    }
    
    func feedUrlWithSlugs(slugs: String? = nil, orderBy: String = "popular", perPage: Int = 10) -> URL? {
        var components = unsplashApiBaseUrl()
        components.path += "\(topicsPath)"
        
        if let pathSlugs = slugs {
            components.path += "/\(pathSlugs)\(photosPath)"
        }
        
        let orderByQueryItem = URLQueryItem(name: "order_by", value: orderBy)
        let perPageQueryItem = URLQueryItem(name: "per_page", value: "\(perPage)")
        
        if components.queryItems != nil {
            components.queryItems! += [orderByQueryItem, perPageQueryItem]
        }
                
        return components.url
    }   
}
