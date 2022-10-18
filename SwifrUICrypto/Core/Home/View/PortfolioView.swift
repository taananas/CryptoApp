//
//  PortfolioView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 23.04.2022.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoun: CoinModel? = nil
    @State private var quantity: String = ""
    @State private var showCheckmarck: Bool = false
    @Binding var close: Bool
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogolist
                    if selectedCoun != nil{
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton(close: $close)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavbarButtons
                }
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue == ""{
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(close: .constant(true))
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView{
    private var coinLogolist: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coun: coin)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedCoun?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1))
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    private func updateSelectedCoin(coun: CoinModel){
        selectedCoun = coun
        if let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coun.id}),
           let amount = portfolioCoin.currentHoldings {
            quantity = "\(amount)"
        }else{
            quantity = ""
        }
    }
    private func getCoinValue() -> Double{
        if let quantity = Double(quantity){
            return quantity * (selectedCoun?.currentPrice ?? 0)
        }
        return 0
    }
    private var portfolioInputSection: some View{
        VStack(spacing: 20){
            HStack{
                Text("Current price of \(selectedCoun?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoun?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCoinValue().asCurrencyWith2Decimals())
            }
        }
        .withoutAnimation()
        .padding()
        .font(.headline)
    }
    private var trailingNavbarButtons: some View{
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckmarck ? 1 : 0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity( (selectedCoun != nil && selectedCoun?.currentHoldings != Double(quantity)) ? 1 : 0)
        }
        .font(.headline)
    }
    private func saveButtonPressed(){
        guard let coin = selectedCoun, let amout = Double(quantity) else {return}
        vm.updatePortfolio(coin: coin, amoun: amout)
        withAnimation(.easeIn){
            showCheckmarck = true
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut){
                showCheckmarck = false
            }
        }
    }
    private func removeSelectedCoin(){
        selectedCoun = nil
        vm.searchText = ""
    }
}



