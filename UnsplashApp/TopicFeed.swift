//
//  TopicFeed.swift
//  UnsplashApp
//
//  Created by Jérémy Laurent on 02/02/2024.
//

import SwiftUI

struct TopicFeed: View {
    @StateObject var feedState = FeedState()
    @State var topic: UnsplashTopic
    
    var body: some View {
        NavigationStack {
            VStack {
                // le bouton va lancer l'appel réseau
                Button(action: {
                    Task {
                        await feedState.fetchTopicFeed(topic: topic)
                    }
                }, label: {
                    Text("Load photos for topic")
                })
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(minimum: 150), spacing: 8), GridItem(.flexible(minimum: 150), spacing: 8)]) {
                        if (feedState.topicFeed != nil) {
                            ForEach(feedState.topicFeed!, id: \.id) { img in
                                AsyncImage(url: URL(string: img.urls.regular)) { image in
                                    image
                                        .centerCropped()
                                        .frame(height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundStyle(Color(hex: img.color))
                                        .frame(height: 150)
                                }
                            }
                        } else {
                            ForEach(0 ..< 12) { item in
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(height: 150)
                                    .foregroundStyle(.placeholder)
                            }
                        }
                    }.redacted(reason: feedState.homeFeed == nil ? .placeholder : .init())
                }
                .padding(.horizontal)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .navigationBarTitle(topic.title)
        }
    }
}
