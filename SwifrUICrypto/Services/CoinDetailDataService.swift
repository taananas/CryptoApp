//
//  CoinDetailDataService.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 15.05.2022.
//

import Foundation
import Combine



class CoinDetailDataService{
    @Published var coinDetails: CoinDetailModel? = nil
    
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coiun: CoinModel){
        self.coin = coiun
        getCoinsDetails()
    }
    
    public func getCoinsDetails(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handlingCompletion, receiveValue: { [weak self] (returnCoinsDetails) in
                self?.coinDetails = returnCoinsDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
