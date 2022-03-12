//
//  ShopView.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
//

import SwiftUI

//ショップ
struct ShopView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var dialogPresentation = DialogPresentation()
    @State var coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
    @State var showAlert = false
    @State var isBought = false
    
    
    
    var body: some View {
        NavigationView{
            List(ShopViewModel.skins){ item in
                Button(action: { isBought.toggle() }, label: {
                    HStack{
                        Image(item.image,bundle: .main)
                            .resizable()
                            .frame(width: 90.0, height: 90.0, alignment: .leading)
                        VStack(alignment: .center){
                            Text(item.name).font(.title)
                            HStack{
                                Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                                Text(String(ShopViewModel.itemPrice(article: item))).font(.title)
                            }
                        }
                    }
                })
                    .alert(isPresented: $isBought) {
                        if ShopViewModel.checkCanBuy(price: item.coin){
                            return Alert(title: Text(str.doYouBuyIt.rawValue),
                                         message: Text(item.name),
                                         primaryButton: .cancel(Text(str.quite.rawValue)),
                                         secondaryButton: .default(Text(str.purchase.rawValue), action: {
                                ShopViewModel.buy(article: item)
                                
                            }))
                        }else{
                            return Alert(
                                title: Text(str.noMoney.rawValue),
                                dismissButton: .cancel(Text(str.modoru.rawValue))
                            )
                        }
                        
                    }
            }
            .navigationTitle(str.shop.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    HStack{
                        Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedCoin)")
                        Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedDiamond)")
                    }
                    
                }
            }
        }
    }
}
