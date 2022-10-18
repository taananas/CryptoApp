//
//  LocalFileManager.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 22.04.2022.
//

import Foundation
import SwiftUI


class LocalFileManager{
    
    static let instance = LocalFileManager()
    
    private init(){}
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        //Create folder
        createFolderIfNeeded(folderName: folderName)
        // get path image
        guard
            let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {return}
        // save image
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    func getImage(imageName: String, folederName: String) -> UIImage?{
        guard let url = getURLForImage(imageName: imageName, folderName: folederName),
              FileManager.default.fileExists(atPath: url.path) else{
                  return nil
              }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String){
        guard let url = getURLForFolder(folderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. Folder \(folderName). \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL?{
        guard let folderUrl = getURLForFolder(folderName: folderName) else {return nil}
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}
