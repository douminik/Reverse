//
//  VideoView.swift
//  Reverse
//
//  Created by Damien on 2025/7/25.
//

import SwiftUI
import AVKit

struct VideoView: View {
    private let player: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "demo", withExtension: "mp4") else {
            fatalError("❌")
        }
        return AVPlayer(url: url)
    }()
    
    var body: some View {
//        Swifty360PlayerView(player: player)
        Swifty360LoopPlayerView(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    VideoView()
}
