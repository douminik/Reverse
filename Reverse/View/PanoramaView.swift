//
//  PanoramaView.swift
//  Reverse
//
//  Created by Damien on 2025/7/24.
//

import SwiftUI
import UIKit
import SwiftUIPanoramaViewer

@MainActor
struct PanoramaView: View {
    @State var displayYearInfo: Bool = false
    @State private var gradientRotation: Double = 0
    @State private var buttonGradientRotation: Double = 0
    @EnvironmentObject var reverseManager: ReverseManager
    @Environment(\.dismiss) private var dismiss
    @State var deviceCornerRadius: CGFloat = 0.0
    @State var rainBowBlurLineWidth: CGFloat = 16.0
    @State var rainBowLineWidth: CGFloat = 8.0
    @StateObject private var effectManager = EffectManager.shared
    @State var selectedYear: String? = nil
    // Marker
    @State private var currentYaw: Float = 0
    @State private var currentPitch: Float = 0
    // Motion
    @StateObject var motionTracker = MotionTracker()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack(alignment: .top) {
                    // PanoramaV iew
//                    VideoView()
                    
                    PhotoView()
                        .environmentObject(reverseManager)
                    
                    VStack {
                        Spacer()
                        Button {
                            reverseManager.panoramaViewModel.isShowTimeLine.toggle()
                        } label: {
                            Text("Reverse")
                                .padding()
                                .foregroundStyle(.black)
                                .background(Color("ButtonColor"))
                                .clipShape(.capsule)
                                .opacity(0.8)
                                .padding()
                        }

                    }
                    
                    // TimeLine View
                    if !reverseManager.panoramaViewModel.timeLine.isEmpty && reverseManager.panoramaViewModel.isShowTimeLine {
                        VStack {
                            HStack(spacing: 16) {
                                ForEach(Array(reverseManager.panoramaViewModel.timeLine.sorted(by: { $0.key < $1.key }).enumerated()), id: \.element.key) { index, element in
                                    let time = element.key
                                    let _ = element.value
                                    Text(time)
                                        .font(.system(.title3, design: .rounded, weight: .medium))
                                        .padding(10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    AngularGradient(
                                                        colors: [
                                                            .red,
                                                            .orange,
                                                            .yellow,
                                                            .green,
                                                            .mint,
                                                            .cyan,
                                                            .blue,
                                                            .indigo,
                                                            .purple,
                                                            .pink,
                                                            .red
                                                        ],
                                                        center: .center,
                                                        angle: .degrees(buttonGradientRotation + Double(index * 60))
                                                    )
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.black.opacity(0.3))
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(
                                                            LinearGradient(
                                                                colors: [
                                                                    .white.opacity(0.6),
                                                                    .white.opacity(0.2),
                                                                    .white.opacity(0.8)
                                                                ],
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            ),
                                                            lineWidth: 2
                                                        )
                                                )
                                                .shadow(
                                                    color: Color.rainbow(index: index, total: reverseManager.panoramaViewModel.timeLine.count).opacity(0.8),
                                                    radius: 8,
                                                    x: 0,
                                                    y: 2
                                                )
                                        )
                                        .foregroundColor(.white)
                                        .scaleEffect(selectedYear == time ? 1.1 : 0.9)
                                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false), value: buttonGradientRotation)
                                        .onTapGesture {
                                            effectManager.triggerHaptic(.medium)
                                            self.selectedYear = time
                                            reverseManager.panoramaViewModel.fetchPanoramaImageSync(year: time)
                                        }
                                        .animation(.default, value: self.selectedYear)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .onAppear {
                            buttonGradientRotation = 0
                            withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
                                buttonGradientRotation = 360
                            }
                        }
                    }
                    
                    VStack {
                        if let year = selectedYear {
                            Text("欢迎来到\(year)年")
                                .foregroundColor(Color("ButtonColor"))
                                .font(.system(.largeTitle, design: .default, weight: .black))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(.ultraThinMaterial)
                    .opacity(displayYearInfo ? 1.0 : 0.0)
                    .animation(.easeInOut, value: displayYearInfo)
                    
                    VStack {
                        Text("正在前往")
                            .foregroundColor(Color("ButtonColor"))
                            .font(.system(.largeTitle, design: .default, weight: .black))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(.ultraThinMaterial)
                    .opacity(reverseManager.panoramaViewModel.isLoading ? 1.0 : 0.0)
                    .animation(.easeInOut, value: reverseManager.panoramaViewModel.isLoading)
                    
                    HStack {
                        Button(action: {
                            dismiss()
                            effectManager.stopAllEffects()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.black)
                                .padding(10)
                        }
                        .tint(Color("ButtonColor"))
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .opacity(0.8)
                        .padding()
                        
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .padding(.top, 30)
                    
                    // 炫光边框
                    if reverseManager.panoramaViewModel.isLoading {
                        RoundedRectangle(cornerRadius: deviceCornerRadius)
                            .stroke(
                                AngularGradient(
                                    colors: [
                                        .red,
                                        .orange,
                                        .yellow,
                                        .green,
                                        .mint,
                                        .cyan,
                                        .blue,
                                        .indigo,
                                        .purple,
                                        .pink,
                                        .red
                                    ],
                                    center: .center,
                                    angle: .degrees(gradientRotation)
                                ),
                                lineWidth: self.rainBowBlurLineWidth
                            )
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                            .blur(radius: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: deviceCornerRadius)
                                    .stroke(
                                        AngularGradient(
                                            colors: [
                                                .red,
                                                .orange,
                                                .yellow,
                                                .green,
                                                .mint,
                                                .cyan,
                                                .blue,
                                                .indigo,
                                                .purple,
                                                .pink,
                                                .red
                                            ],
                                            center: .center,
                                            angle: .degrees(gradientRotation + 180)
                                        ),
                                        lineWidth: self.rainBowLineWidth
                                    )
                                    .frame(
                                        width: geometry.size.width,
                                        height: geometry.size.height
                                    )
                            )
                            .ignoresSafeArea(.all)
                            .onAppear {
                                withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
                                    gradientRotation = 360
                                }
                            }
                    }
                    
//                    Text("debug")
//                        .font(.largeTitle)
//                        .background(.white)
//                        .padding(.top, 200)
//                        .onTapGesture {
//                            reverseManager.panoramaViewModel.debug()
//                        }
                    
                }
                .onChange(of: reverseManager.panoramaViewModel.isLoading, { _, value in
                    if value {
                        gradientRotation = 0
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
                            gradientRotation = 360
                        }
                        rainBowLineWidthAnimation()
                        
                    } else {
                        effectManager.stopAllEffects()
            
                        withAnimation {
                            if let _ = selectedYear {
                                displayYearInfo = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    displayYearInfo = false
                                }
                            }
                        }
                    }
                })
                .animation(.default, value: reverseManager.panoramaViewModel.isShowTimeLine)
                .background(Color("BackgroundColor"))
                .onAppear {
                    self.deviceCornerRadius = UIScreen.main.displayCornerRadius
                    self.rainBowLineWidthAnimation()
                }
                .bold()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func rainBowLineWidthAnimation() {
        self.rainBowBlurLineWidth = 16.0
        self.rainBowLineWidth = 8.0
        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            self.rainBowBlurLineWidth = 32.0
            self.rainBowLineWidth = 16.0
        }
    }
}


#Preview {
    PanoramaView()
        .ignoresSafeArea(.all)
        .environmentObject(ReverseManager())
}
