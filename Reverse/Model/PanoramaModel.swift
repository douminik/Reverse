//
//  PanoramaModel.swift
//  Reverse
//
//  Created by Damien on 2025/7/24.
//

import Foundation

struct PanoramaRequest {
    let x: String
    let y: String
    let year: String
    
    init(x: String, y: String, year: String) {
        self.x = x
        self.y = y
        self.year = year
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)/baidu_map_jailbreak")
    }
    
    var postData: Data? {
        let parameters = [
            "X": x,
            "Y": y,
            "year": year
        ]
        
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}
