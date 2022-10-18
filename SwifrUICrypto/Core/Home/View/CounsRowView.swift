//
//  CounsRowView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 19.04.2022.
//

import SwiftUI

struct CounsRowView: View {
    let coin: CoinModel
    let showHoldingsColums: Bool
    var body: some View {
        HStack(spacing: 0){
            letfColum
            Spacer()
            if showHoldingsColums{
                centerColum
            }
            rightColum
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
    }
}

struct CounsRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CounsRowView(coin: dev.coin, showHoldingsColums: true)
                .previewLayout(.sizeThatFits)
            CounsRowView(coin: dev.coin, showHoldingsColums: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CounsRowView{
    private var letfColum: some View{
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    private var centerColum: some View{
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text("\((coin.currentHoldings ?? 0).asNumberString())")
        }
        .foregroundColor(Color.theme.accent)
    }
    private var rightColum: some View{
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(minWidth: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
