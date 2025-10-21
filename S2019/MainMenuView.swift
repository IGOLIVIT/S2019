//
//  MainMenuView.swift
//  S2019
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct MainMenuView: View {
    @State private var showLogicTrails = false
    @State private var showMemoryMines = false
    @State private var showStats = false
    @State private var isVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient.gemPathGolden
                    .ignoresSafeArea()
                
                // Simple background decoration
                VStack {
                    HStack {
                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .foregroundColor(.gemPathText.opacity(0.2))
                        Spacer()
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.gemPathRuby.opacity(0.3))
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 100)
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gemPathEmerald.opacity(0.2))
                        Spacer()
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gemPathGoldStart.opacity(0.3))
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 150)
                }
                
                ScrollView {
                    VStack(spacing: 40) {
                        Spacer(minLength: 60)
                        
                        // Title
                        VStack(spacing: 16) {
                            Image(systemName: "diamond.fill")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(.gemPathText)
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                .scaleEffect(isVisible ? 1.0 : 0.5)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
                            
                            Text("Choose Your Path")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.gemPathText)
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : 30)
                                .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                        }
                        
                        // Menu buttons
                        VStack(spacing: 24) {
                            // Logic Trails Button
                            NavigationLink(destination: LogicTrailsView()) {
                                MenuButtonContent(
                                    title: "Logic Trails",
                                    subtitle: "Connect gems in sequence",
                                    icon: "brain.head.profile",
                                    color: .gemPathEmerald
                                )
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -100)
                            .animation(.easeOut(duration: 0.6).delay(0.6), value: isVisible)
                            
                            // Memory Mines Button
                            NavigationLink(destination: MemoryMinesView()) {
                                MenuButtonContent(
                                    title: "Gem Patterns",
                                    subtitle: "Follow the glowing sequence",
                                    icon: "lightbulb.fill",
                                    color: .gemPathRuby
                                )
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : 100)
                            .animation(.easeOut(duration: 0.6).delay(0.8), value: isVisible)
                            
                            // Stats & Settings Button
                            NavigationLink(destination: StatsView()) {
                                MenuButtonContent(
                                    title: "Stats & Settings",
                                    subtitle: "View your progress",
                                    icon: "chart.bar.fill",
                                    color: .gemPathGoldStart
                                )
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(y: isVisible ? 0 : 50)
                            .animation(.easeOut(duration: 0.6).delay(1.0), value: isVisible)
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer(minLength: 60)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
        }
    }
}

struct MenuButtonContent: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.gemPathText)
                .frame(width: 50, height: 50)
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.gemPathText)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gemPathText.opacity(0.8))
            }
            
            Spacer()
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gemPathText.opacity(0.7))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gemPathGoldBorder, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
}

// Removed FloatingSparkle to prevent crashes

#Preview {
    MainMenuView()
}
