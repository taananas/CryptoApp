//
//  HomeStatView.swift
//  SwifrUICrypto
//
//  Created by Богдан Зыков on 22.04.2022.
//

import SwiftUI

struct HomeStatView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    var body: some View {
        HStack{
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatView(showPortfolio: .constant(true))
            .environmentObject(dev.homeVM)
    }
}
