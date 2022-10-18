//
//  DetailViewModel.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 15.05.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject{
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var webSiteUrl: String? = nil
    @Published var redditUrl: String? = nil
    @Published var coin: CoinModel
    private let coinDetailSevices: CoinDetailDataService
    private var cancellabels = Set<AnyCancellable>()
 
    init(coin: CoinModel){
        self.coin = coin
        self.coinDetailSevices = CoinDetailDataService(coiun: coin)
        addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailSevices.$coinDetails
            .combineLatest($coin)
            .map(mapDateToStatistics)
            .sink { [weak self] (returnArrays) in
                self?.overviewStatistics = returnArrays.overview
                self?.additionalStatistics = returnArrays.additional
            }
            .store(in: &cancellabels)
        
        coinDetailSevices.$coinDetails
            .sink { [weak self] (returnCoinDetails) in
                self?.coinDescription = returnCoinDetails?.readableDescription
                self?.webSiteUrl = returnCoinDetails?.links?.homepage?.first
                self?.redditUrl = returnCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellabels)
    }
    
    
    private func mapDateToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]){
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel]{
        
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePersentChange = coinModel.priceChangePercentage24H
        let priseState = StatisticModel(title: "Current Price", value: price, percentageChange: pricePersentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marcetCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marcetCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
        priseState, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
    private func createAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticModel]{
        
        let high = coinModel.high24H?.asCurrencyWith2Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith2Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePersentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price change", value: priceChange, percentageChange: pricePersentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let mapketCapPersentChanege = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: mapketCapPersentChanege)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
    
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        return additionalArray
    }
}
