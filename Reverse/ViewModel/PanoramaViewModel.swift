//
//  PanoramaViewModel.swift
//  Reverse
//
//  Created by Damien on 2025/7/24.
//

import Foundation
import SwiftUI

class PanoramaViewModel: ObservableObject {
    @Published var panoramaImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var isShowTimeLine: Bool = false
    @Published var errorMessage: String?
    @Published var timeLine: [String: String] = [:]
    
    private let urlSession = URLSession.shared
    
    func debug() {
        self.isLoading = false
        self.isShowTimeLine = true
        self.timeLine = ["2019": "sid", "2018": "sid", "2017": "sid"]
        self.panoramaImage = UIImage(named: "Street")
    }
    
    func fetchPanoramaYear(request: PanoramaRequest) async {
        isLoading = true
        errorMessage = nil
        panoramaImage = nil
        
        guard let url = request.url else {
            errorMessage = "无效的URL"
            isLoading = false
            return
        }
        
        guard let postData = request.postData else {
            errorMessage = "请求数据格式错误"
            isLoading = false
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = postData
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "网络请求失败"
                isLoading = false
                return
            }
            
            if let arr = try? JSONSerialization.jsonObject(with: data) as? [Any],
               let years = arr.first as? [String],
               let sid = arr.last as? String {
                var timeLineDict: [String: String] = [:]
                for year in years {
                    timeLineDict[year] = sid
                }
                self.timeLine = timeLineDict
                self.isShowTimeLine = true
            }
            
            isLoading = false
            
        } catch {
            errorMessage = "获取日期失败: \(error.localizedDescription)"
            isLoading = false
            print("获取日期失败: \(error.localizedDescription)")
        }
    }
    
    func fetchPanoramaImage(year: String) async {
        isLoading = true
        errorMessage = nil
        panoramaImage = nil
        
        var components = URLComponents(string: "\(baseURL)/get_image")
        components?.queryItems = [
            URLQueryItem(name: "year", value: year),
            URLQueryItem(name: "sid", value: timeLine[year])
        ]
        
        guard let url = components?.url else {
            errorMessage = "无效的URL"
            isLoading = false
            return
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                errorMessage = "网络请求失败"
                isLoading = false
                return
            }
            
            guard let image = UIImage(data: data) else {
                errorMessage = "图片解析失败"
                isLoading = false
                return
            }
            
            panoramaImage = image
            self.isShowTimeLine = false
            isLoading = false
            
        } catch {
            errorMessage = "获取全景图失败: \(error.localizedDescription)"
            isLoading = false
            print("获取全景图失败: \(error.localizedDescription)")
        }
    }
    
    func fetchPanoramaYearSync(request: PanoramaRequest) {
        Task {
            await fetchPanoramaYear(request: request)
        }
    }
    
    func fetchPanoramaImageSync(year: String) {
        Task {
            await fetchPanoramaImage(year: year)
        }
    }
}
