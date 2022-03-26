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
    @State var setItem = UserDefaults.standard.string(forKey: Keys.itemFace.rawValue) ?? ""
    
    var body: some View {
        let items = ["face1","face2","face3","face4","face5"]
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
                    ForEach((0...4), id: \.self) { num in
                        Image(decorative: items[num])
                            .onTapGesture {
                                UserDefaults.standard.set(items[num], forKey: Keys.itemFace.rawValue)
                                setItem = items[num]
                            }
                    }
                }
            }
        }
    }
}

struct ItemSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ItemSelectView()
    }
}
