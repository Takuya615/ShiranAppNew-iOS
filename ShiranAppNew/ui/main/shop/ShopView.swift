
import SwiftUI

//ショップ
struct ShopView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var dialogPresentation = DialogPresentation()
    @State var coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
    @State var showAlert = false
    @State var isBought = false
    @State var products: [Skin] = ShopViewModel.getSkins()
    
    var body: some View {
        if products.isEmpty {
            Text(str.noItems.rawValue).font(.title)
        }else{
            NavigationView{
                List(products){ p in
                    Button(action: { isBought.toggle() }, label: {
                        HStack{
                            Image(p.image,bundle: .main)
                                .resizable()
                                .frame(width: 90.0, height: 90.0, alignment: .leading)
                            VStack(alignment: .center){
                                Text(p.name).font(.title)
                                HStack{
                                    Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                                    Text(String(ShopViewModel.itemPrice(article: p))).font(.title)
                                }
                            }
                        }
                    })
                        .alert(isPresented: $isBought) {
                            if ShopViewModel.checkCanBuy(price: p.coin){
                                return Alert(title: Text(str.doYouBuyIt.rawValue),
                                             message: Text(p.name),
                                             primaryButton: .cancel(Text(str.quite.rawValue)),
                                             secondaryButton: .default(Text(str.purchase.rawValue), action: {
                                    
                                    self.dataCounter.countedCoin = ShopViewModel.buy(article: p)
                                    delete(id: p.id)
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
                //.onAppear(perform: { products = ShopViewModel.getSkins() })
            }
        }
    }
    func delete(id: Int){
        var num = 0
        for skin in products{
            if skin.id == id {
                products.remove(at: num)
            }
            num += 1
        }
    }
}
