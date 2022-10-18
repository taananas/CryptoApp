//
//  CoinImageView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 20.04.2022.
//

import SwiftUI



struct CoinImageView: View {
    @StateObject var vm: CoinViewModel
    init(coin: CoinModel){
        _vm = StateObject(wrappedValue: CoinViewModel(coin: coin))
    }
    var body: some View {
        ZStack{
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else if vm.isLoading{
                ProgressView()
            }else{
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
