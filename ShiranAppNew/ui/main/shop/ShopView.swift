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
    @State var products: [Skin] = []//ShopViewModel.getSkins()
    
    var body: some View {
        TListBox()
        NavigationView{
            List{
                Button(action: { isBought.toggle() }, label: {
                    HStack{
                        //if !products[i].image.isEmpty {
                        Image($0.image,bundle: .main)
                            .resizable()
                            .frame(width: 90.0, height: 90.0, alignment: .leading)
                        //}
                        VStack(alignment: .center){
                            Text($0.name).font(.title)
                            HStack{
                                Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                                Text(String(ShopViewModel.itemPrice(article: $0))).font(.title)
                            }
                        }
                    }
                })
                    .alert(isPresented: $isBought) {
                        if ShopViewModel.checkCanBuy(price: $0.coin){
                            return Alert(title: Text(str.doYouBuyIt.rawValue),
                                         message: Text($0.name),
                                         primaryButton: .cancel(Text(str.quite.rawValue)),
                                         secondaryButton: .default(Text(str.purchase.rawValue), action: {

                                //self.dataCounter.countedCoin = ShopViewModel.buy(article: products[i])
                                $0..append(Skin(id: 6, name: "aa", image: "item1", coin: 100, x: 1.0, y: 1.0))
                                //products.remove(at: i)
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
            .onAppear(perform: {
                //ShopViewModel.getMoney(coin: 500)
                print("ああああああああああ")
                print("products = \(products)")
                products = ShopViewModel.getSkins()
                print("After = \(products)")
                //coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
            })
        }
    }
}

//Test....

struct TListItem: Identifiable {
    var id: Int
    var t: String
    init(_ i: Int, _ s: String) {
        id = i
        t = s
    }
}

struct TListBox: View {
    @State var listItems: [Skin] = [];
    @State var count: Int = 0
    @State var timer1: Timer?
    var body: some View {
        let list = ShopViewModel.skins
        List(listItems){
            Text($0.name)
        }.onAppear(){
            
            self.listItems.append(contentsOf: list)
//            self.timer1?.invalidate()
//            self.timer1 = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) {_ in
//                if (self.count <= 5) {
//                    let df = DateFormatter()
//                    df.dateFormat = "🕐 mm分ss秒SSS"
//                    self.listItems.append(TListItem(self.count, df.string(from: Date())))
//                    self.count += 1
//                }
//            }
        }.onTapGesture(perform: {
            if (self.count <= 3) {
                self.listItems.remove(at: self.count)
                //self.listItems.append(list[self.count])
                self.count += 1
            }
        })
    }
}

struct test3_Previews: PreviewProvider {
    static var previews: some View {
        TListBox()
    }
}
