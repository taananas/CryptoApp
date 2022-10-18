//
//  CoinImageServices.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 20.04.2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageServices{
    
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedIimage = fileManager.getImage(imageName: imageName, folederName: folderName){
            image = savedIimage
        }else{
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        
        guard let url = URL(string: coin.image) else {return}
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handlingCompletion, receiveValue: { [weak self] (returnImage) in
                guard let self = self, let downloadedImage = returnImage else {return}
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
