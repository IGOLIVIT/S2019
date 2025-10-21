//
//  LogicTrailsView.swift
//  S2019
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct LogicTrailsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("crystalFragments") private var crystalFragments: Int = 0
    @AppStorage("puzzlesSolved") private var puzzlesSolved: Int = 0
    
    @State private var currentPuzzle: LogicPuzzle = LogicPuzzle.random()
    @State private var selectedGems: [Int] = []
    @State private var showSuccess = false
    @State private var showReward = false
    @State private var isVisible = false
    @State private var gemAnimations: [Bool] = Array(repeating: false, count: 9)
    @State private var levelCompleted = false
    
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
                            
                            Text("Logic Puzzle Challenge")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.gemPathText)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : -20)
                                .animation(.easeOut(duration: 0.6).delay(0.2), value: isVisible)
                            
                            Text("Find and connect the gems following the pattern")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gemPathText.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.3), value: isVisible)
                        }
                        
                        // Game grid
                        VStack(spacing: 24) {
                            // Pattern hint
                            VStack(spacing: 8) {
                                Text("Pattern: \(currentPuzzle.patternDescription)")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.gemPathText.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                
                                if !selectedGems.isEmpty {
                                    Text("Selected: \(selectedGems.map { "\($0)" }.joined(separator: ", "))")
                                        .font(.system(size: 12, weight: .regular, design: .rounded))
                                        .foregroundColor(.gemPathGoldStart)
                                        .multilineTextAlignment(.center)
                                }
                                
                                Text("Target: \(currentPuzzle.solution.map { "\($0)" }.joined(separator: ", "))")
                                    .font(.system(size: 12, weight: .regular, design: .rounded))
                                    .foregroundColor(.gemPathText.opacity(0.6))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 20)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.4), value: isVisible)
                            
                            // 3x3 Grid with connection lines
                            ZStack {
                                // Connection lines
                                if selectedGems.count > 1 {
                                    ConnectionLinesView(selectedIndices: selectedGems)
                                }
                                
                                // Gem grid
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                                    ForEach(0..<9, id: \.self) { index in
                                        GemButton(
                                            gem: currentPuzzle.gems[index],
                                            isSelected: selectedGems.contains(index),
                                            selectionOrder: selectedGems.firstIndex(of: index),
                                            isCorrect: showSuccess,
                                            animate: gemAnimations[index]
                                        ) {
                                            selectGem(at: index)
                                        }
                                        .scaleEffect(isVisible ? 1.0 : 0.5)
                                        .opacity(isVisible ? 1.0 : 0.0)
                                        .animation(.easeOut(duration: 0.4).delay(0.6 + Double(index) * 0.1), value: isVisible)
                                    }
                                }
                            }
                            .padding(.horizontal, 32)
                        }
                        .gemPathCard()
                        .padding(.horizontal, 20)
                        
                        // Action buttons
                        VStack(spacing: 16) {
                            Button("Clear Selection") {
                                clearSelection()
                            }
                            .buttonStyle(GemPathButtonStyle(color: .gemPathRuby))
                            .disabled(selectedGems.isEmpty)
                            .opacity(selectedGems.isEmpty ? 0.5 : 1.0)
                            
                            Button(levelCompleted ? "Next Challenge" : "Solve the puzzle first") {
                                if levelCompleted {
                                    nextChallenge()
                                }
                            }
                            .buttonStyle(GemPathButtonStyle(color: levelCompleted ? .gemPathEmerald : .gemPathBackground))
                            .disabled(!levelCompleted)
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
                        SuccessPopup {
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
                        RewardPopup(fragmentsEarned: 1) {
                            showReward = false
                            // Keep levelCompleted true so Next Challenge button stays active
                        }
                    }
                }
            )
        }
        .navigationBarHidden(true)
        .onAppear {
            isVisible = true
        }
    }
    
    private func selectGem(at index: Int) {
        guard !showSuccess else { return }
        
        if let existingIndex = selectedGems.firstIndex(of: index) {
            selectedGems.remove(at: existingIndex)
        } else {
            selectedGems.append(index)
        }
        
        // Animate gem
        withAnimation(.easeInOut(duration: 0.2)) {
            gemAnimations[index].toggle()
        }
        
        // Check if puzzle is solved
        if selectedGems.count == currentPuzzle.solution.count {
            checkSolution()
        }
    }
    
    private func checkSolution() {
        // For some patterns, order doesn't matter
        let isCorrect: Bool
        if currentPuzzle.patternDescription.contains("corners") || 
           currentPuzzle.patternDescription.contains("cross") {
            // For corners and cross, check if sets are equal (order doesn't matter)
            isCorrect = Set(selectedGems) == Set(currentPuzzle.solution)
        } else {
            // For sequential patterns (diagonal, L-shape, zigzag), order matters
            isCorrect = selectedGems == currentPuzzle.solution
        }
        
        if isCorrect {
            // Success!
            levelCompleted = true
            withAnimation(.easeInOut(duration: 0.5)) {
                showSuccess = true
            }
            
            // Update progress
            crystalFragments += 1
            puzzlesSolved += 1
            
            // Animate all gems
            withAnimation(.easeInOut(duration: 0.5)) {
                for i in 0..<9 {
                    gemAnimations[i] = true
                }
            }
        } else {
            // Wrong answer - shake animation
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                for i in selectedGems {
                    gemAnimations[i] = true
                }
            }
            
            // Clear selection after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                clearSelection()
            }
        }
    }
    
    private func clearSelection() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedGems.removeAll()
            gemAnimations = Array(repeating: false, count: 9)
        }
    }
    
    private func nextChallenge() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentPuzzle = LogicPuzzle.random()
            selectedGems.removeAll()
            showSuccess = false
            levelCompleted = false // Reset for new challenge
            gemAnimations = Array(repeating: false, count: 9)
        }
    }
}

struct LogicPuzzle {
    let gems: [GemType]
    let solution: [Int]
    let patternDescription: String
    
    static func random() -> LogicPuzzle {
        let patterns = [
            // Diagonal pattern
            LogicPuzzle(
                gems: [.diamond, .circle, .triangle, .square, .star, .heart, .hexagon, .pentagon, .octagon],
                solution: [0, 4, 8], // Top-left to bottom-right diagonal
                patternDescription: "Connect the main diagonal"
            ),
            // L-shape pattern
            LogicPuzzle(
                gems: [.star, .diamond, .circle, .triangle, .square, .heart, .hexagon, .pentagon, .octagon],
                solution: [0, 3, 6, 7, 8], // L-shape
                patternDescription: "Form an L-shape"
            ),
            // Cross pattern
            LogicPuzzle(
                gems: [.heart, .diamond, .star, .circle, .triangle, .square, .hexagon, .pentagon, .octagon],
                solution: [1, 3, 4, 5, 7], // Cross shape: top, left, center, right, bottom
                patternDescription: "Create a cross (any order)"
            ),
            // Square corners
            LogicPuzzle(
                gems: [.octagon, .diamond, .pentagon, .circle, .triangle, .square, .hexagon, .star, .heart],
                solution: [0, 2, 6, 8], // Four corners: top-left, top-right, bottom-left, bottom-right
                patternDescription: "Connect all 4 corners (any order)"
            ),
            // Zigzag pattern
            LogicPuzzle(
                gems: [.triangle, .diamond, .star, .circle, .heart, .square, .hexagon, .pentagon, .octagon],
                solution: [0, 1, 3, 4, 6, 7], // Zigzag
                patternDescription: "Follow the zigzag"
            )
        ]
        
        return patterns[Int.random(in: 0..<patterns.count)]
    }
}

struct GemButton: View {
    let gem: GemType
    let isSelected: Bool
    let selectionOrder: Int?
    let isCorrect: Bool
    let animate: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Gem background
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected ? Color.gemPathGoldStart.opacity(0.3) : Color.gemPathBackground.opacity(0.2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.gemPathGoldBorder : Color.gemPathText.opacity(0.3),
                                lineWidth: isSelected ? 3 : 1
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                // Gem icon
                Image(systemName: gem.rawValue)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(isCorrect ? .gemPathEmerald : gem.color)
                
                // Selection order number
                if let order = selectionOrder {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(order + 1)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.gemPathText)
                                .frame(width: 20, height: 20)
                                .background(
                                    Circle()
                                        .fill(Color.gemPathRuby)
                                )
                        }
                        Spacer()
                    }
                    .padding(4)
                }
            }
        }
        .frame(width: 80, height: 80)
        .scaleEffect(animate ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: animate)
    }
}

struct SuccessPopup: View {
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
                
                Text("Success!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.gemPathText)
                
                Text("You discovered the pattern!")
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

struct RewardPopup: View {
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

struct ConnectionLinesView: View {
    let selectedIndices: [Int]
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize: CGFloat = 80
            let spacing: CGFloat = 16
            let totalWidth = gridSize * 3 + spacing * 2
            let startX = (geometry.size.width - totalWidth) / 2 + gridSize / 2
            let startY = gridSize / 2
            
            ForEach(0..<selectedIndices.count - 1, id: \.self) { index in
                let fromIndex = selectedIndices[index]
                let toIndex = selectedIndices[index + 1]
                
                let fromRow = fromIndex / 3
                let fromCol = fromIndex % 3
                let toRow = toIndex / 3
                let toCol = toIndex % 3
                
                let fromPoint = CGPoint(
                    x: startX + CGFloat(fromCol) * (gridSize + spacing),
                    y: startY + CGFloat(fromRow) * (gridSize + spacing)
                )
                let toPoint = CGPoint(
                    x: startX + CGFloat(toCol) * (gridSize + spacing),
                    y: startY + CGFloat(toRow) * (gridSize + spacing)
                )
                
                Path { path in
                    path.move(to: fromPoint)
                    path.addLine(to: toPoint)
                }
                .stroke(Color.gemPathGoldBorder, lineWidth: 3)
                .opacity(0.8)
                
                // Arrow at the end
                Image(systemName: "arrowtriangle.right.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.gemPathGoldBorder)
                    .position(toPoint)
                    .rotationEffect(.radians(atan2(toPoint.y - fromPoint.y, toPoint.x - fromPoint.x)))
            }
        }
    }
}

#Preview {
    LogicTrailsView()
}
