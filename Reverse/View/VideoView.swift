//
//  VideoView.swift
//  Reverse
//
//  Created by Damien on 2025/7/25.
//

import SwiftUI
import AVKit

struct VideoView: View {
    @EnvironmentObject var reverseManager: ReverseManager

    private var player: AVPlayer = {
        guard let videoURL = Bundle.main.url(forResource: "demo", withExtension: "mp4") else {
            fatalError("❌ 视频文件没找到")
        }
        return AVPlayer(url: videoURL)
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
