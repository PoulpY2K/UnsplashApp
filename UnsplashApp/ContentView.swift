//
//  ContentView.swift
//  UnsplashApp
//
//  Created by Jérémy Laurent on 02/02/2024.
//

import SwiftUI

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ContentView: View {
    @StateObject var feedState = FeedState()
    
    var body: some View {
        NavigationStack {
            VStack {
                // le bouton va lancer l'appel réseau
                Button(action: {
                    Task {
                        await feedState.fetchHomeFeed()
                        await feedState.fetchTopicsFeed()
                    }
                }, label: {
                    Text("Load...")
                })
                ScrollView(Axis.Set.horizontal) {
                    LazyHGrid(rows: [GridItem(.flexible(minimum: 50, maximum: 100))]) {
                        if (feedState.topicsFeed != nil) {
                            Spacer()
                            HStack(spacing: 23) {
                                ForEach(feedState.topicsFeed!, id: \.id) { topic in
                                    NavigationLink {
                                        TopicFeed(topic: topic)
                                    } label: {
                                        VStack {
                                            AsyncImage(url: URL(string: topic.coverPhoto.urls.regular)) { image in
                                                image
                                                    .centerCropped()
                                                    .frame(width: 100, height: 50)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                            } placeholder: {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .foregroundStyle(Color(hex: topic.coverPhoto.color))
                                                    .frame(width: 100, height: 50)
                                            }
                                            Text(topic.title)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        } else {
                            HStack(spacing: 20) {
                                Spacer()
                                ForEach(0 ..< 3) { item in
                                    VStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 100, height: 50)
                                            .foregroundStyle(.placeholder)
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 80, height: 20)
                                            .foregroundStyle(.placeholder)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(minimum: 150), spacing: 8), GridItem(.flexible(minimum: 150), spacing: 8)]) {
                        if (feedState.homeFeed != nil) {
                            ForEach(feedState.homeFeed!, id: \.id) { img in
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
            .navigationBarTitle("Feed")
        }
    }
}

#Preview {
    ContentView()
}
