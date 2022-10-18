//
//  SettingView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 15.05.2022.
//

import SwiftUI



struct SettingView: View {
    @Binding var close: Bool
    let defaultUrl = URL(string: "https://www.google.com")!
    let coungeckoUrl = URL(string: "https://www.coingecko.com")!
    let personalUrl = URL(string: "https://github.com/BogdanZyk")!
    var body: some View {
        NavigationView{
            List{
                developInfoSection
                coingeckoInfoSection
                applicationSection
            }
            .tint(.blue)
            .font(.headline)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton(close: $close)
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(close: .constant(true))
    }
}

extension SettingView{
    private var developInfoSection: some View{
        Section {
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100,  height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This App for monitoring cryptocurrency exchanges and saving your cryptocurrencies to your portfolio. It uses MVVM Arhitecture, Combine, and Core Data.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            Link("GitHub", destination: personalUrl)
        } header: {
            Text("SwiftUI Crypto Tracker App")
        }
    }
    private var coingeckoInfoSection: some View{
        Section {
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The ctyptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slighty delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            Link("Website Coingecko", destination: coungeckoUrl)
        } header: {
            Text("Coingecko")
        }
    }
    private var applicationSection: some View{
        Section {
            Link("Terms of Service", destination: defaultUrl)
            Link("Privacy Policy", destination: defaultUrl)
            Link("Compony Website", destination: defaultUrl)
        } header: {
            Text("Application")
        }

    }
}
