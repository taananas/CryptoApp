//
//  HapticManager.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 15.05.2022.
//

import SwiftUI

class HapticManager{
    
    static private let generatot = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generatot.notificationOccurred(type)
    }
}

