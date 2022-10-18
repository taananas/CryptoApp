//
//  SwifrUICryptoApp.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 19.04.2022.
//

import SwiftUI

@main
struct SwifrUICryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchScreenView: Bool = true
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView{
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(.stack)
                .environmentObject(vm)
                
                ZStack{
                    if showLaunchScreenView{
                        LaunchScreenView(showLaunchView: $showLaunchScreenView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2)
            }
        }
    }
}
