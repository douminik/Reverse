//
//  ContentView.swift
//  Reverse
//
//  Created by Damien on 2025/7/24.
//

import SwiftUI
import MapKit

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
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @ObservedObject private var valueMonitor = ValueMonitor.shared
    @Environment(\.dismiss) private var dismiss
    
    @State var handleInputDateModel: Bool = false
    
    @State private var isRecommendPressed = false
    @State private var isMapPressed = false
    @State private var isPanoramaPressed = false
    @State private var selectedCityIndex: Int? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("推荐城市")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // 炫酷城市图片展示
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        CityImageCard(
                            imageName: "shanghai",
                            cityName: "上海",
                            gradientColors: [.blue, .cyan, .teal],
                            isSelected: selectedCityIndex == 0
                        ) {
                            selectedCityIndex = selectedCityIndex == 0 ? nil : 0
                        }
                        
                        CityImageCard(
                            imageName: "chongqing",
                            cityName: "重庆",
                            gradientColors: [.purple, .pink, .red],
                            isSelected: selectedCityIndex == 1
                        ) {
                            selectedCityIndex = selectedCityIndex == 1 ? nil : 1
                        }
                    }
                    .padding(.horizontal, 10)
                    HStack(spacing: 15) {
                        
                        CityImageCard(
                            imageName: "beijing",
                            cityName: "北京",
                            gradientColors: [.orange, .yellow, .green],
                            isSelected: selectedCityIndex == 2
                        ) {
                            selectedCityIndex = selectedCityIndex == 2 ? nil : 2
                        }
                        
                        CityImageCard(
                            imageName: "quanzhou",
                            cityName: "泉州",
                            gradientColors: [.mint, .green, .teal],
                            isSelected: selectedCityIndex == 3
                        ) {
                            selectedCityIndex = selectedCityIndex == 3 ? nil : 3
                        }
                    }
                    .padding(.horizontal, 10)
                }
                
                Button {
                    self.runVisit()
                    self.runEffect()
                    
                } label: {
                    Text("推荐")
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
                
                NavigationLink {
                    TapMapView(tappedCoordinate: $tappedCoordinate)
                } label: {
                    if let coordinate = tappedCoordinate {
                        Text("您上次跃起迁到📍 纬度: \(String(coordinate.latitude)), 经度: \(String(coordinate.longitude))")
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
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                    } else {
                        Text("选点跃迁")
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
                    }
                }
                .onChange(of: valueMonitor.locationChangeTrigger) { oldValue, newValue in
                    longitude = String(tappedCoordinate!.longitude)
                    latitude = String(tappedCoordinate!.latitude)
                    self.runVisit()
                    self.runEffect()
                }

                
                NavigationLink(destination: CustomPanoramaView()) {
                    Text("创建全景图")
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
                }
                
                Toggle(isOn: $handleInputDateModel) {
                    Text("高级模式")
                }
                .toggleStyle(CustomToggleStyle())
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
                .frame(width: 200)
                
                VStack {
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
                }
                .opacity(self.handleInputDateModel ? 1.0 : 0.0)
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                .animation(.easeInOut(duration: 0.3), value: handleInputDateModel)
                

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
            x: longitude,
            y: latitude,
            year: year
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

// 炫酷城市图片卡片组件
struct CityImageCard: View {
    let imageName: String
    let cityName: String
    let gradientColors: [Color]
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var glowOffset: CGFloat = -100
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // 主图片
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipped()
                
                // 光泽覆盖层
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.4),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 30, height: 120)
                    .rotationEffect(.degrees(15))
                    .offset(x: glowOffset)
                    .animation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: false),
                        value: glowOffset
                    )
                    .onAppear {
                        glowOffset = 120
                    }
                
                // 渐变遮罩（选中状态）
                if isSelected {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: gradientColors.map { $0.opacity(0.3) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                // 城市名称标签
                VStack {
                    Spacer()
                    Text(cityName)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            LinearGradient(
                                                colors: gradientColors,
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        )
                        .offset(y: -8)
                }
            }
        }
        .frame(width: 120, height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            // 边框光效
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: isSelected ?
                            gradientColors + [gradientColors[0]] :
                            [Color.white.opacity(0.3), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .shadow(
            color: isSelected ?
                gradientColors[1].opacity(0.4) :
                Color.black.opacity(0.3),
            radius: isSelected ? 12 : 6,
            x: 0,
            y: isSelected ? 6 : 3
        )
        .shadow(
            color: isSelected ? gradientColors[0].opacity(0.2) : Color.clear,
            radius: isSelected ? 20 : 0,
            x: 0,
            y: isSelected ? 10 : 0
        )
        .scaleEffect(isPressed ? 0.95 : (isSelected ? 1.05 : 1.0))
        .rotation3DEffect(
            .degrees(isPressed ? 8 : 0),
            axis: (x: 1, y: 1, z: 0)
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPressed)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isSelected)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// 自定义 Toggle 样式
struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: configuration.isOn ?
                            [Color.green, Color.mint] :
                            [Color.gray.opacity(0.3), Color.gray.opacity(0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 60, height: 32)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                        .frame(width: 28, height: 28)
                        .offset(x: configuration.isOn ? 14 : -14)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ReverseManager())
}
