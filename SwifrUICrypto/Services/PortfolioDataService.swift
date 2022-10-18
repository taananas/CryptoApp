//
//  PortfolioDataService.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 23.04.2022.
//

import Foundation
import CoreData


class PortfolioDataService{
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var saveEntities: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error.localizedDescription)")
            }
            self.getPortfolio()
        }
    }
    //MARK: Public section
    
    func updatePortfolio(coin: CoinModel, amoun: Double){
        if let entity = saveEntities.first(where: {$0.coinid == coin.id}){
            if amoun > 0 {
                update(entity: entity, amount: amoun)
            }else{
                remove(entity: entity)
            }
        }else{
            add(coin: coin, amount: amoun)
        }
    }
    
    
    
    //MARK: Private section
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            saveEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entitis. \(error.localizedDescription)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinid = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error.localizedDescription)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
}
