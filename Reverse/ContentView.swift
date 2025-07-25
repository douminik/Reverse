//
//  ContentView.swift
//  Reverse
//
//  Created by Damien on 2025/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var reverseManager = ReverseManager()
    @State var startStory: Bool = false
    @State var longitude: String = "116.313393"
    @State var latitude: String = "40.047783"
    @State var year: String = "2023"
    @FocusState private var longitudeFocused: Bool
    @FocusState private var latitudeFocused: Bool
    @FocusState private var yearFocused: Bool
    @StateObject private var effectManager = EffectManager.shared
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // 经度输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text("经度 (Longitude)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.leading, 4)
                    
                    TextField("116.313393", text: $longitude)
                        .focused($longitudeFocused)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: longitudeFocused ?
                                                    [.blue, .purple, .cyan] :
                                                    [.gray.opacity(0.5), .gray.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: longitudeFocused ? 2 : 1
                                        )
                                )
                                .shadow(
                                    color: longitudeFocused ? .blue.opacity(0.5) : .clear,
                                    radius: longitudeFocused ? 8 : 0
                                )
                        )
                        .scaleEffect(longitudeFocused ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: longitudeFocused)
                }
                .padding(.horizontal, 20)
                
                // 纬度输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text("纬度 (Latitude)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.leading, 4)
                    
                    TextField("40.047783", text: $latitude)
                        .focused($latitudeFocused)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: latitudeFocused ?
                                                    [.green, .mint, .teal] :
                                                    [.gray.opacity(0.5), .gray.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: latitudeFocused ? 2 : 1
                                        )
                                )
                                .shadow(
                                    color: latitudeFocused ? .green.opacity(0.5) : .clear,
                                    radius: latitudeFocused ? 8 : 0
                                )
                        )
                        .scaleEffect(latitudeFocused ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: latitudeFocused)
                }
                .padding(.horizontal, 20)
                
                // 年份输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text("年份 (Year)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.leading, 4)
                    
                    TextField("2023", text: $year)
                        .focused($yearFocused)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: yearFocused ?
                                                    [.orange, .red, .pink] :
                                                    [.gray.opacity(0.5), .gray.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: yearFocused ? 2 : 1
                                        )
                                )
                                .shadow(
                                    color: yearFocused ? .orange.opacity(0.5) : .clear,
                                    radius: yearFocused ? 8 : 0
                                )
                        )
                        .scaleEffect(yearFocused ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: yearFocused)
                }
                .padding(.horizontal, 20)
                
                Button {
                    self.runVisit()
                    self.runEffect()
                    
                } label: {
                    Text("Reverse")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .foregroundStyle(.black)
                        .background(
                            LinearGradient(
                                colors: [Color("ButtonColor"), Color("ButtonColor").opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color("ButtonColor").opacity(0.3), radius: 8, x: 0, y: 4)
                        .scaleEffect(reverseManager.panoramaViewModel.isLoading ? 0.95 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: reverseManager.panoramaViewModel.isLoading)
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor"))
            .navigationDestination(isPresented: $startStory, destination: {
                PanoramaView()
                    .environmentObject(reverseManager)
                    .ignoresSafeArea(.all)
                    .navigationBarBackButtonHidden()
            })
            .onTapGesture {
                self.longitudeFocused = false
                self.latitudeFocused = false
                self.yearFocused = false
            }
        }
        .background(Color("BackgroundColor"))
    
    }
    
    func runVisit() {
        self.reverseManager.panoramaViewModel.isLoading = true
        reverseManager.panoramaViewModel.fetchPanoramaYearSync(request: PanoramaRequest(
            x: "116.313393",
            y: "40.047783",
            year: "2023"
        ))
        self.startStory = true
    }
    
    func runEffect() {
        if #available(iOS 18.2, *) {
            effectManager.startRainbowFlashEffect()
        } else {
            print("iOS version too low, skipping execution.")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ReverseManager())
}
