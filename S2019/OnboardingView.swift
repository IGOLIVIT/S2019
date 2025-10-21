//
//  OnboardingView.swift
//  S2019
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    @State private var showMainMenu = false
    
    private let pages = [
        OnboardingPage(
            title: "Sharpen your mind through discovery",
            description: "Embark on a journey of cognitive enhancement through engaging puzzles and challenges.",
            imageName: "mountain.2.fill",
            imageColor: Color.gemPathGoldStart
        ),
        OnboardingPage(
            title: "Find patterns, solve paths, and train your focus",
            description: "Develop logical thinking and memory skills with beautifully crafted gem-based exercises.",
            imageName: "sparkles",
            imageColor: Color.gemPathEmerald
        ),
        OnboardingPage(
            title: "Ready to begin your journey?",
            description: "Start collecting crystal fragments and unlock the power of your mind.",
            imageName: "diamond.fill",
            imageColor: Color.gemPathRuby
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient.gemPathGolden
                    .ignoresSafeArea()
                
                // Simple background decoration
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "sparkles")
                            .font(.system(size: 30))
                            .foregroundColor(.gemPathText.opacity(0.3))
                        Spacer()
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.gemPathRuby.opacity(0.4))
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gemPathEmerald.opacity(0.3))
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    // Page content
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.4), value: currentPage)
                    
                    // Bottom section
                    VStack(spacing: 24) {
                        // Page indicators
                        HStack(spacing: 12) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? Color.gemPathText : Color.gemPathText.opacity(0.3))
                                    .frame(width: 12, height: 12)
                                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                        
                        // Action button
                        if currentPage < pages.count - 1 {
                            Button("Continue") {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    currentPage += 1
                                }
                            }
                            .buttonStyle(GemPathButtonStyle())
                            .padding(.horizontal, 32)
                        } else {
                            Button("Start Journey") {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    hasCompletedOnboarding = true
                                }
                            }
                            .buttonStyle(GemPathButtonStyle())
                            .padding(.horizontal, 32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gemPathText.opacity(0.3), lineWidth: 1)
                                    .blur(radius: 8)
                                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: showMainMenu)
                            )
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let imageColor: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isVisible = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Spacer(minLength: 80)
                
                // Icon
                Image(systemName: page.imageName)
                    .font(.system(size: 120, weight: .light))
                    .foregroundColor(page.imageColor)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .scaleEffect(isVisible ? 1.0 : 0.5)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
                
                VStack(spacing: 20) {
                    // Title
                    Text(page.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.gemPathText)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                    
                    // Description
                    Text(page.description)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.gemPathText.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: isVisible)
                }
                .padding(.horizontal, 32)
                
                Spacer(minLength: 120)
            }
        }
        .onAppear {
            isVisible = true
        }
        .onDisappear {
            isVisible = false
        }
    }
}

// Removed FloatingGem to prevent crashes

#Preview {
    OnboardingView()
}
