//
//  MarketDataServices.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 22.04.2022.
//

import Foundation
import Combine

class MarketDataServices{
    
    @Published var marketData: MarketDataModel?
    
    var marketDataSubscription: AnyCancellable?
    
    init(){
        getData()
    }
    
    public func getData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handlingCompletion, receiveValue: { [weak self] (returnGlobalDate) in
                self?.marketData = returnGlobalDate.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
