//
//  HomeViewModel.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 19.04.2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = []
    @Published var isReloading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    
    private let coinDataService = CounDataService()
    private let marketDataService = MarketDataServices()
    private let portfolioCoinData = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption{
        case rank, rankReversed, holdings, holdingsReversed, price, priceRewersed
    }
    
    init(){
        addSubscribers()
    }
    
   private func addSubscribers(){
        //search coins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnCoin) in
                self?.allCoins = returnCoin
            }
            .store(in: &cancellables)
        //update portfolioCoins
        $allCoins
            .combineLatest(portfolioCoinData.$saveEntities)
            .map(mapAllCounsToPortfolioCoins)
            .sink { [weak self] (returnCoins) in
                guard let self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnCoins)
            }
            .store(in: &cancellables)
        
        //update market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnStats) in
                self?.statistics = returnStats
                self?.isReloading = false
            }
            .store(in: &cancellables)
       
       
   }
    
    public func updatePortfolio(coin: CoinModel, amoun: Double){
        portfolioCoinData.updatePortfolio(coin: coin, amoun: amoun)
    }
    public func reloadData(){
        isReloading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel]{
        var updatedCoins = filterCoin(text: text, coins: coins)
        sortCoins(sort: sortOption, couns: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, couns: inout [CoinModel]){
        switch sort{
        case .rank, .holdings :
            couns.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            couns.sort(by: {$0.rank > $1.rank})
        case .price:
            couns.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceRewersed:
            couns.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func filterCoin(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else{
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCounsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel]{
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinid == coin.id}) else{
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else{
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h volume", value: data.volume)
        let btcDominans = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previewsValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let persentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previewsValue = currentValue / (1 + persentChange)
                return previewsValue
            }
            .reduce(0, +)
        let percentageChange = (portfolioValue - previewsValue) / previewsValue
        let portfolio = StatisticModel(
            title: "Portfolio value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,volume, btcDominans, portfolio
        ])
        return stats
    }
}


