//
//  MemoryMinesView.swift
//  S2019
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct MemoryMinesView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("crystalFragments") private var crystalFragments: Int = 0
    @AppStorage("sequencesCompleted") private var sequencesCompleted: Int = 0
    
    @State private var gems: [GemType] = []
    @State private var sequence: [Int] = []
    @State private var playerSequence: [Int] = []
    @State private var currentlyFlashing: Int? = nil
    @State private var showSuccess = false
    @State private var showReward = false
    @State private var isVisible = false
    @State private var isPlayingSequence = false
    @State private var levelCompleted = false
    @State private var gemAnimations: [Bool] = Array(repeating: false, count: 9)
    @State private var currentLevel: Int = 1
    @State private var gameStarted = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient.gemPathGolden
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            HStack {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.gemPathText)
                                        .frame(width: 44, height: 44)
                                        .background(
                                            Circle()
                                                .fill(Color.gemPathBackground.opacity(0.3))
                                        )
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "diamond.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gemPathRuby)
                                    
                                    Text("\(crystalFragments)")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.gemPathText)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Color.gemPathBackground.opacity(0.3))
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            Text("Sequence Challenge")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.gemPathText)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : -20)
                                .animation(.easeOut(duration: 0.6).delay(0.2), value: isVisible)
                            
                            Text("Watch and repeat the sequence")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gemPathText.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.3), value: isVisible)
                        }
                        
                        // Game info
                        VStack(spacing: 24) {
                            // Level and sequence info
                            HStack(spacing: 24) {
                                VStack(spacing: 4) {
                                    Text("Level")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.gemPathText.opacity(0.7))
                                    Text("\(currentLevel)")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(.gemPathGoldStart)
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Sequence")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.gemPathText.opacity(0.7))
                                    Text("\(sequence.count)")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(.gemPathEmerald)
                                }
                                
                                VStack(spacing: 4) {
                                    Text("Progress")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.gemPathText.opacity(0.7))
                                    Text("\(playerSequence.count)/\(sequence.count)")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(.gemPathRuby)
                                }
                            }
                            
                            // Status text
                            if !gameStarted {
                                Text("Press Start to begin!")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.gemPathGoldStart)
                                    .multilineTextAlignment(.center)
                            } else if isPlayingSequence {
                                Text("Watch carefully...")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.gemPathGoldStart)
                                    .multilineTextAlignment(.center)
                            } else if !levelCompleted {
                                Text("Tap the gems in order!")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.gemPathEmerald)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text("Perfect! Ready for next level")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.gemPathEmerald)
                                    .multilineTextAlignment(.center)
                            }
                            
                            // Sequence display
                            if !playerSequence.isEmpty {
                                VStack(spacing: 8) {
                                    Text("Your sequence:")
                                        .font(.system(size: 12, weight: .regular, design: .rounded))
                                        .foregroundColor(.gemPathText.opacity(0.6))
                                    
                                    HStack(spacing: 8) {
                                        ForEach(Array(playerSequence.enumerated()), id: \.offset) { index, gemIndex in
                                            Image(systemName: gems[gemIndex].rawValue)
                                                .font(.system(size: 16))
                                                .foregroundColor(gems[gemIndex].color)
                                                .frame(width: 24, height: 24)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .gemPathCard()
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                        
                        // 3x3 Gem grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                            ForEach(0..<9, id: \.self) { index in
                                MemoryGemButton(
                                    gem: gems[index],
                                    isFlashing: currentlyFlashing == index,
                                    isInSequence: playerSequence.contains(index),
                                    isCorrect: levelCompleted,
                                    animate: gemAnimations[index]
                                ) {
                                    gemTapped(at: index)
                                }
                                .scaleEffect(isVisible ? 1.0 : 0.5)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.4).delay(0.6 + Double(index) * 0.1), value: isVisible)
                            }
                        }
                        .padding(.horizontal, 32)
                        
                        // Action buttons
                        VStack(spacing: 16) {
                            if !gameStarted {
                                Button("Start Game") {
                                    startGame()
                                }
                                .buttonStyle(GemPathButtonStyle(color: .gemPathEmerald))
                            } else {
                                Button(isPlayingSequence ? "Playing sequence..." : "Watch Sequence Again") {
                                    replaySequence()
                                }
                                .buttonStyle(GemPathButtonStyle(color: .gemPathGoldStart))
                                .disabled(isPlayingSequence || levelCompleted)
                                .opacity(isPlayingSequence || levelCompleted ? 0.5 : 1.0)
                                
                                Button(levelCompleted ? "Next Challenge" : "Solve the sequence first") {
                                    if levelCompleted {
                                        nextChallenge()
                                    }
                                }
                                .buttonStyle(GemPathButtonStyle(color: levelCompleted ? .gemPathEmerald : .gemPathBackground))
                                .disabled(!levelCompleted)
                            }
                        }
                        .padding(.horizontal, 32)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: isVisible)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .overlay(
                // Success popup
                Group {
                    if showSuccess {
                        MemorySuccessPopup {
                            showSuccess = false
                            showReward = true
                        }
                    }
                }
            )
            .overlay(
                // Reward popup
                Group {
                    if showReward {
                        MemoryRewardPopup(fragmentsEarned: 1) {
                            showReward = false
                        }
                    }
                }
            )
        }
        .navigationBarHidden(true)
        .onAppear {
            setupGame()
            isVisible = true
        }
    }
    
    private func startGame() {
        gameStarted = true
        // Start playing sequence after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            playSequence()
        }
    }
    
    private func setupGame() {
        // Initialize 9 random gems
        gems = (0..<9).map { _ in GemType.allCases.randomElement()! }
        
        // Create a sequence based on level (3 + level length, max 8)
        let sequenceLength = min(3 + currentLevel, 8)
        sequence = (0..<sequenceLength).map { _ in Int.random(in: 0..<9) }
        
        playerSequence = []
        levelCompleted = false
        gemAnimations = Array(repeating: false, count: 9)
    }
    
    private func playSequence() {
        guard !isPlayingSequence else { return }
        
        isPlayingSequence = true
        playerSequence = []
        
        var delay: Double = 0.0
        
        for (index, gemIndex) in sequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                // Flash the gem
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentlyFlashing = gemIndex
                    gemAnimations[gemIndex] = true
                }
                
                // Stop flashing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentlyFlashing = nil
                        gemAnimations[gemIndex] = false
                    }
                    
                    // If this was the last gem, enable player input
                    if index == sequence.count - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isPlayingSequence = false
                        }
                    }
                }
            }
            
            delay += 0.9 // Time between flashes
        }
    }
    
    private func replaySequence() {
        playSequence()
    }
    
    private func gemTapped(at index: Int) {
        guard gameStarted, !isPlayingSequence, !levelCompleted else { return }
        
        // Animate gem
        withAnimation(.easeInOut(duration: 0.2)) {
            gemAnimations[index] = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                gemAnimations[index] = false
            }
        }
        
        // Add to player sequence
        playerSequence.append(index)
        
        // Check if correct so far
        let currentIndex = playerSequence.count - 1
        if playerSequence[currentIndex] != sequence[currentIndex] {
            // Wrong! Reset
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                gemAnimations[index] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                playerSequence = []
                gemAnimations = Array(repeating: false, count: 9)
            }
            return
        }
        
        // Check if complete
        if playerSequence.count == sequence.count {
            // Success!
            levelCompleted = true
            
            withAnimation(.easeInOut(duration: 0.5)) {
                showSuccess = true
            }
            
            // Update progress
            crystalFragments += 1
            sequencesCompleted += 1
            
            // Animate all gems
            withAnimation(.easeInOut(duration: 0.5)) {
                for i in 0..<9 {
                    gemAnimations[i] = true
                }
            }
        }
    }
    
    private func nextChallenge() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentLevel += 1
            setupGame()
            showSuccess = false
            levelCompleted = false
            
            // Play new sequence
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                playSequence()
            }
        }
    }
}

struct MemoryGemButton: View {
    let gem: GemType
    let isFlashing: Bool
    let isInSequence: Bool
    let isCorrect: Bool
    let animate: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Gem background
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isFlashing ? Color.gemPathGoldStart.opacity(0.8) :
                        isInSequence ? Color.gemPathGoldStart.opacity(0.3) :
                        Color.gemPathBackground.opacity(0.2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isFlashing ? Color.gemPathGoldBorder :
                                isInSequence ? Color.gemPathGoldBorder :
                                Color.gemPathText.opacity(0.3),
                                lineWidth: isFlashing ? 4 : isInSequence ? 3 : 1
                            )
                    )
                    .shadow(
                        color: isFlashing ? Color.gemPathGoldStart.opacity(0.6) : .black.opacity(0.2),
                        radius: isFlashing ? 12 : 4,
                        x: 0,
                        y: isFlashing ? 0 : 2
                    )
                
                // Gem icon
                Image(systemName: gem.rawValue)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(isCorrect ? .gemPathEmerald : gem.color)
            }
        }
        .frame(width: 80, height: 80)
        .scaleEffect(animate || isFlashing ? 1.15 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: animate)
        .animation(.easeInOut(duration: 0.3), value: isFlashing)
    }
}

struct MemorySuccessPopup: View {
    let onDismiss: () -> Void
    @State private var isVisible = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gemPathEmerald)
                    .scaleEffect(isVisible ? 1.0 : 0.5)
                    .animation(.easeOut(duration: 0.6), value: isVisible)
                
                Text("Perfect!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.gemPathText)
                
                Text("You got the sequence right!")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gemPathText.opacity(0.9))
                    .multilineTextAlignment(.center)
                
                Button("Continue") {
                    onDismiss()
                }
                .buttonStyle(GemPathButtonStyle(color: .gemPathEmerald))
            }
            .padding(32)
            .gemPathCard()
            .padding(.horizontal, 40)
            .opacity(isVisible ? 1.0 : 0.0)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .animation(.easeOut(duration: 0.4), value: isVisible)
        }
        .onAppear {
            isVisible = true
        }
    }
}

struct MemoryRewardPopup: View {
    let fragmentsEarned: Int
    let onDismiss: () -> Void
    @State private var isVisible = false
    @State private var sparkleAnimation = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 24) {
                ZStack {
                    // Sparkle effects
                    ForEach(0..<8, id: \.self) { index in
                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .foregroundColor(.gemPathGoldStart)
                            .offset(
                                x: cos(Double(index) * .pi / 4) * (sparkleAnimation ? 60 : 20),
                                y: sin(Double(index) * .pi / 4) * (sparkleAnimation ? 60 : 20)
                            )
                            .opacity(sparkleAnimation ? 0 : 1)
                            .animation(.easeOut(duration: 1.5), value: sparkleAnimation)
                    }
                    
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gemPathRuby)
                        .scaleEffect(isVisible ? 1.0 : 0.5)
                        .animation(.easeOut(duration: 0.6), value: isVisible)
                }
                
                Text("You discovered a Crystal Fragment!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.gemPathText)
                    .multilineTextAlignment(.center)
                
                Text("+\(fragmentsEarned) Fragment")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.gemPathGoldStart)
                
                Button("Collect") {
                    onDismiss()
                }
                .buttonStyle(GemPathButtonStyle(color: .gemPathRuby))
            }
            .padding(32)
            .gemPathCard()
            .padding(.horizontal, 40)
            .opacity(isVisible ? 1.0 : 0.0)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .animation(.easeOut(duration: 0.4), value: isVisible)
        }
        .onAppear {
            isVisible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sparkleAnimation = true
            }
        }
    }
}

#Preview {
    MemoryMinesView()
}
