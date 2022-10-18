//
//  View.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 23.04.2022.
//

import Foundation
import SwiftUI



extension View {
    func withoutAnimation() -> some View {
        self.animation(nil, value: UUID())
    }
}
