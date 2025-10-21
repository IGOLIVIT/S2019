//
//  StatsView.swift
//  S2019
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct StatsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("crystalFragments") private var crystalFragments: Int = 0
    @AppStorage("puzzlesSolved") private var puzzlesSolved: Int = 0
    @AppStorage("memoryStreak") private var memoryStreak: Int = 0
    
    @State private var showResetAlert = false
    @State private var isVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background with wooden texture effect
                LinearGradient(
                    colors: [
                        Color.gemPathBackground,
                        Color.gemPathBackground.opacity(0.8),
                        Color.gemPathGoldEnd.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Simple background decoration
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gemPathRuby.opacity(0.3))
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 120)
                    Spacer()
                }
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.gemPathText)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(Color.gemPathBackground.opacity(0.5))
                                    )
                            }
                            
                            Spacer()
                            
                            Text("Stats & Settings")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.gemPathText)
                            
                            Spacer()
                            
                            // Placeholder for symmetry
                            Color.clear
                                .frame(width: 44, height: 44)
                        }
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: isVisible)
                        
                        // Progress Summary Card
                        VStack(spacing: 24) {
                            // Title
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gemPathGoldStart)
                                
                                Text("Progress Summary")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.gemPathText)
                                
                                Spacer()
                            }
                            
                            // Stats grid
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 20) {
                                StatCard(
                                    title: "Crystal Fragments",
                                    value: "\(crystalFragments)",
                                    icon: "diamond.fill",
                                    color: .gemPathRuby,
                                    delay: 0.3
                                )
                                
                                StatCard(
                                    title: "Puzzles Solved",
                                    value: "\(puzzlesSolved)",
                                    icon: "brain.head.profile",
                                    color: .gemPathEmerald,
                                    delay: 0.4
                                )
                                
                                StatCard(
                                    title: "Memory Streak",
                                    value: "\(memoryStreak)",
                                    icon: "flame.fill",
                                    color: .gemPathGoldStart,
                                    delay: 0.5
                                )
                                
                                StatCard(
                                    title: "Total Sessions",
                                    value: "\(puzzlesSolved + memoryStreak)",
                                    icon: "clock.fill",
                                    color: .blue,
                                    delay: 0.6
                                )
                            }
                        }
                        .padding(24)
                        .gemPathCard()
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: isVisible)
                        
                        // Achievement Badges
                        VStack(spacing: 20) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gemPathGoldStart)
                                
                                Text("Achievements")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.gemPathText)
                                
                                Spacer()
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 16) {
                                AchievementBadge(
                                    title: "First Steps",
                                    description: "Solve your first puzzle",
                                    icon: "footprints",
                                    isUnlocked: puzzlesSolved >= 1,
                                    delay: 0.7
                                )
                                
                                AchievementBadge(
                                    title: "Gem Collector",
                                    description: "Collect 10 fragments",
                                    icon: "diamond.fill",
                                    isUnlocked: crystalFragments >= 10,
                                    delay: 0.8
                                )
                                
                                AchievementBadge(
                                    title: "Memory Master",
                                    description: "5 memory streak",
                                    icon: "brain.head.profile",
                                    isUnlocked: memoryStreak >= 5,
                                    delay: 0.9
                                )
                                
                                AchievementBadge(
                                    title: "Puzzle Expert",
                                    description: "Solve 25 puzzles",
                                    icon: "star.circle.fill",
                                    isUnlocked: puzzlesSolved >= 25,
                                    delay: 1.0
                                )
                                
                                AchievementBadge(
                                    title: "Crystal Hoarder",
                                    description: "Collect 50 fragments",
                                    icon: "sparkles",
                                    isUnlocked: crystalFragments >= 50,
                                    delay: 1.1
                                )
                                
                                AchievementBadge(
                                    title: "Mind Palace",
                                    description: "10 memory streak",
                                    icon: "brain.filled.head.profile",
                                    isUnlocked: memoryStreak >= 10,
                                    delay: 1.2
                                )
                            }
                        }
                        .padding(24)
                        .gemPathCard()
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                        
                        // Settings Section
                        VStack(spacing: 20) {
                            HStack {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gemPathGoldStart)
                                
                                Text("Settings")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.gemPathText)
                                
                                Spacer()
                            }
                            
                            Button("Reset Progress") {
                                showResetAlert = true
                            }
                            .buttonStyle(GemPathButtonStyle(color: .gemPathRuby))
                        }
                        .padding(24)
                        .gemPathCard()
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: isVisible)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
        }
        .alert("Reset Progress", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("Are you sure you want to reset all your progress? This action cannot be undone.")
        }
    }
    
    private func resetProgress() {
        withAnimation(.easeInOut(duration: 0.5)) {
            crystalFragments = 0
            puzzlesSolved = 0
            memoryStreak = 0
        }
    }
    
    // Removed generateFloatingCrystals to prevent crashes
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(color)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .animation(.easeOut(duration: 0.6).delay(delay), value: isVisible)
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.gemPathText)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.gemPathText.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gemPathBackground.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
        )
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(y: isVisible ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(delay), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}

struct AchievementBadge: View {
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let delay: Double
    
    @State private var isVisible = false
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        isUnlocked ?
                        LinearGradient(
                            colors: [Color.gemPathGoldStart, Color.gemPathGoldEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [Color.gemPathBackground.opacity(0.5), Color.gemPathBackground.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(
                                isUnlocked ? Color.gemPathGoldBorder : Color.gemPathText.opacity(0.3),
                                lineWidth: 2
                            )
                    )
                    .scaleEffect(isUnlocked && pulseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isUnlocked ? .gemPathText : .gemPathText.opacity(0.5))
            }
            
            Text(title)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(isUnlocked ? .gemPathText : .gemPathText.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .scaleEffect(isVisible ? 1.0 : 0.5)
        .animation(.easeOut(duration: 0.6).delay(delay), value: isVisible)
        .onAppear {
            isVisible = true
            if isUnlocked {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.5) {
                    pulseAnimation = true
                }
            }
        }
    }
}

// Removed FloatingCrystal structures to prevent crashes

#Preview {
    StatsView()
}
