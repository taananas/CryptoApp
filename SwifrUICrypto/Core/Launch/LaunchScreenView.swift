//
//  LaunchScreenView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 15.05.2022.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var loadingText: [String] = "Loading your portfolio...".map{String($0)}
    @State private var showLoadingtext: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @Binding var showLaunchView: Bool
    var body: some View {
        ZStack{
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            ZStack{
                if showLoadingtext{
                    HStack(spacing: 0){
                        ForEach(loadingText.indices) {index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundColor(Color.launch.accent)
                                .fontWeight(.heavy)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingtext.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex{
                    showLaunchView = false
                }else{
                    counter += 1
                }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView(showLaunchView: .constant(true))
    }
}
