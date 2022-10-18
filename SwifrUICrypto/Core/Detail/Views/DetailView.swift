//
//  DetailView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 15.05.2022.
//

import SwiftUI

struct DetailLoadingView: View{
    @Binding var coin: CoinModel?
    var body: some View {
        ZStack{
            if let coin = coin{
               DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    let coin: CoinModel
    init(coin: CoinModel){
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    private let spacing: CGFloat = 30
    var body: some View {
        
        ScrollView{
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 24){
                    overViewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
    
    }
}

extension DetailView{
    
    private var navigationBarTrailingItems: some View{
        HStack {
            Text(vm.coin.symbol)
                .font(.headline)
            .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overViewTitle: some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var additionalTitle: some View{
        Text("Addition Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overviewStatistics) {stat in
                    StatisticView(stat: stat)
                }
            }
    }
    private var additionalGrid: some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) {stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var descriptionSection: some View{
        ZStack{
            if let counDescription = vm.coinDescription, !counDescription.isEmpty{
                VStack(alignment: .leading){
                    Text(counDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    private var websiteSection: some View{
        VStack(alignment: .leading, spacing: 10){
            if let website = vm.webSiteUrl,
               let url = URL(string: website){
             Link("Website", destination: url)
            }
            if let redditStr = vm.redditUrl, let url = URL(string: redditStr){
                Link("Reddit", destination: url)
            }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
