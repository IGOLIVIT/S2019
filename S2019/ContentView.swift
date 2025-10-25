//
//  ContentView.swift
//  S2019
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    var body: some View {
        
        ZStack {
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
                    NavigationView {
                        ZStack {
                            // Background
                            LinearGradient.gemPathGolden
                                .ignoresSafeArea()
                            
                            VStack(spacing: 40) {
                                Spacer()
                                
                                // App title
                                VStack(spacing: 16) {
                                    Image(systemName: "diamond.fill")
                                        .font(.system(size: 80, weight: .light))
                                        .foregroundColor(.gemPathText)
                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    
                                    Text("GemPath")
                                        .font(.system(size: 42, weight: .bold, design: .rounded))
                                        .foregroundColor(.gemPathText)
                                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                                }
                                
                                Spacer()
                                
                                // Navigation buttons
                                VStack(spacing: 20) {
                                    if hasCompletedOnboarding {
                                        NavigationLink(destination: MainMenuView()) {
                                            Text("Continue Journey")
                                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                                .foregroundColor(.gemPathText)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 56)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(Color.gemPathEmerald)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16)
                                                                .stroke(Color.gemPathGoldBorder, lineWidth: 2)
                                                        )
                                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                                )
                                        }
                                    } else {
                                        NavigationLink(destination: OnboardingView()) {
                                            Text("Start Journey")
                                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                                .foregroundColor(.gemPathText)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 56)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(Color.gemPathEmerald)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16)
                                                                .stroke(Color.gemPathGoldBorder, lineWidth: 2)
                                                        )
                                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                                )
                                        }
                                    }
                                    
                                    Button("Reset Onboarding") {
                                        hasCompletedOnboarding = false
                                    }
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.gemPathText.opacity(0.7))
                                }
                                .padding(.horizontal, 32)
                                
                                Spacer()
                            }
                        }
                    }
                    .navigationBarHidden(true)
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = "30.10.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        // Дата в прошлом - делаем запрос на сервер
        makeServerRequest()
    }
    
    private func makeServerRequest() {
        
        let dataManager = DataManagers()
        
        guard let url = URL(string: dataManager.server) else {
            self.isBlock = true
            self.isFetched = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 404 {
                        
                        self.isBlock = true
                        self.isFetched = true
                        
                    } else if httpResponse.statusCode == 200 {
                        
                        self.isBlock = false
                        self.isFetched = true
                    }
                    
                } else {
                    
                    // В случае ошибки сети тоже блокируем
                    self.isBlock = true
                    self.isFetched = true
                }
            }
            
        }.resume()
    }
}

#Preview {
    ContentView()
}
