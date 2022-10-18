//
//  XmarkButton.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 23.04.2022.
//

import SwiftUI

struct XmarkButton: View {
    @Binding var close: Bool
    var body: some View {
        Button {
            close.toggle()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButton(close: .constant(true))
    }
}
