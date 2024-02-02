//
//  FeedState.swift
//  UnsplashApp
//
//  Created by Jérémy Laurent on 02/02/2024.
//

import Foundation

class FeedState: ObservableObject {
    @Published var homeFeed: [UnsplashPhoto]?
    @Published var topicsFeed: [UnsplashTopic]?
    @Published var topicFeed: [UnsplashPhoto]?

    // Fetch home feed doit utiliser la fonction feedUrl de UnsplashAPI
    // Puis assigner le résultat de l'appel réseau à la variable homeFeed
    func fetchHomeFeed() async {
            do {
                // Créez une requête avec cette URL
                if let url = UnsplashAPI().feedUrl() {
                    let request = URLRequest(url: url)
                                        
                    // Faites l'appel réseau
                    let (data, _) = try await URLSession.shared.data(for: request)
                    
                    // Transformez les données en JSON
                    let deserializedData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                    
                    // Mettez à jour l'état de la vue
                    homeFeed = deserializedData
                }
            } catch {
                print("Error: \(error)")
            }
    }
    
    // Fetch home feed doit utiliser la fonction feedUrl de UnsplashAPI
    // Puis assigner le résultat de l'appel réseau à la variable homeFeed
    func fetchTopicsFeed() async {
            do {
                // Créez une requête avec cette URL
                if let url = UnsplashAPI().feedUrlWithSlugs(orderBy: "featured") {
                    let request = URLRequest(url: url)
                                        
                    // Faites l'appel réseau
                    let (data, _) = try await URLSession.shared.data(for: request)
                    
                    // Transformez les données en JSON
                    let deserializedData = try JSONDecoder().decode([UnsplashTopic].self, from: data)
                    
                    // Mettez à jour l'état de la vue
                    topicsFeed = deserializedData
                }
            } catch {
                print("Error: \(error)")
            }
    }
    
    // Fetch home feed doit utiliser la fonction feedUrl de UnsplashAPI
    // Puis assigner le résultat de l'appel réseau à la variable homeFeed
    func fetchTopicFeed(topic: UnsplashTopic) async {
            do {
                // Créez une requête avec cette URL
                if let url = UnsplashAPI().feedUrlWithSlugs(slugs: topic.slug) {
                    let request = URLRequest(url: url)
                                        
                    // Faites l'appel réseau
                    let (data, _) = try await URLSession.shared.data(for: request)
                    
                    // Transformez les données en JSON
                    let deserializedData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                    
                    // Mettez à jour l'état de la vue
                    topicFeed = deserializedData
                }
            } catch {
                print("Error: \(error)")
            }
    }
}
