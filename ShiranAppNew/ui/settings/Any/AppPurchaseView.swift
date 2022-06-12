
import SwiftUI

struct AppPurchaseView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var showingAlert = false
    var body: some View {
        let products = CoinPurchace.coins
        let products2 = DiaPurchace.dia
        NavigationView{
            VStack{
                List{
                    Section {
                        ForEach(products){ p in
                            HStack{
                                Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                                Text(String(p.coin))
                                Spacer()
                                Button("¥ \(p.enn)"){
                                    PurchaseUtil().purchase(p.product,enn:p.enn,callBack: {
                                        self.dataCounter.countedCoin += p.coin
                                        UserDefaults.standard.set(self.dataCounter.countedCoin, forKey: Keys.coin.rawValue)
                                    },callError: {showingAlert=true})
                                }.padding()
                            }
                        }
                    } header: {
                        Text(str.coin.rawValue)
                    }
                    Section {
                        ForEach(products2){ p in
                            HStack{
                                Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                                Text(String(p.coin))
                                Spacer()
                                Button("¥ \(p.enn)"){
                                    PurchaseUtil().purchase(p.product,enn:p.enn,callBack: {
                                        self.dataCounter.countedDiamond += p.coin
                                        UserDefaults.standard.set(self.dataCounter.countedDiamond, forKey: Keys.diamond.rawValue)
                                    },callError: {showingAlert=true})
                                }.padding()
                            }
                        }
                    } header: {
                        Text(str.diamond.rawValue)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    HStack{
                        BackKeyView(callBack: {self.appState.isPurchaseView.toggle()})
                        Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedCoin)")
                        Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedDiamond)")
                    }
                    
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(str.purchaseError.rawValue))
            }
        }
    }
}
