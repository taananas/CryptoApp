//
//  CounDataService.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 20.04.2022.
//

import Foundation
import Combine

class CounDataService{
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscription: AnyCancellable?
    
    init(){
        getCoins()
    }
    
    public func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handlingCompletion, receiveValue: { [weak self] (returnCoins) in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()
            })
    }
}
