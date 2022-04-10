//
//  ItemSelectView.swift
//  ShiranAppNew
//
//  Created by 津村拓哉 on 2022/03/14.
//

import SwiftUI

struct ItemSelectView: View {
    @EnvironmentObject var appState: AppState
    private var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 5), spacing: CGFloat(0.0) ), count: 3)
    @State var setItem = UserDefaults.standard.decodedObject(Skin.self, forKey: Keys.selectSkin.rawValue)?.image ?? ""
    
    var body: some View {
        let items: [Int] = UserDefaults.standard.array(forKey: Keys.yourItem.rawValue) as? [Int] ?? [] as [Int]
        let skins = ShopViewModel.skins
        if setItem.isEmpty {
            VStack {
                HStack{
                    Button(action: {self.appState.isItemSelectView = false},
                           label: {Text(str.back.rawValue).font(.system(size: 20))
                    })
                    Spacer()
                }
                Spacer()
                Text(str.noItems.rawValue)
                Spacer()
            }
        }else{
            VStack {
                HStack{
                    Button(action: {self.appState.isItemSelectView = false},
                           label: {Text(str.back.rawValue).font(.system(size: 20))
                    })
                    Spacer()
                }
                Image(decorative: setItem)//faceImage)
                    .resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .center)
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                        ForEach((items), id: \.self) { num in
                            Image(decorative: skins[num].image)
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .onTapGesture {
                                    UserDefaults.standard.setEncoded(skins[num], forKey: Keys.selectSkin.rawValue)
                                    setItem = skins[num].image
                                }
                        }
                    }
                }
            }
        }
    }
}
