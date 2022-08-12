
import SwiftUI

//ショップ
struct ShopView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    //@State var dialogPresentation = DialogPresentation()
    @State var coin = UserDefaults.standard.integer(forKey: Keys.coin.rawValue)
    @State var showAlert = false
    @State var isBought = false
    @State var products: [Skin] = ShopViewModel.getSkins()
    @State var products2: [Body] = ShopViewModel.getBodys()
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    Section {
                        ForEach(0..<products.count, id: \.self){ i in
                            SkinItemView(num:i, p: products[i], callBack: {
                                EventAnalytics.spend_virtual_currency(item: products[i].name, matter: "like", amount: products.count)
                                let buyAny = ShopViewModel.buy(type:"Skin",id: products[i].id, coin: products[i].coin, dia: products[i].dia)
                                if buyAny.1 {self.dataCounter.countedCoin = buyAny.0}
                                else{self.dataCounter.countedDiamond = buyAny.0}
                                delete(id: products[i].id)})
                        }
                    } header: {
                        Text(str.item.rawValue)
                    }
                    Section {
                        ForEach(products2, id: \.self){ p in
                            BodyItemView(p: p, callBack: {
                                EventAnalytics.spend_virtual_currency(item: p.name, matter: "like", amount: products2.count)
                                let buyAny = ShopViewModel.buy(type: "Body", id: p.id, coin: p.coin, dia: p.dia)
                                if buyAny.1 {self.dataCounter.countedCoin = buyAny.0}
                                else{self.dataCounter.countedDiamond = buyAny.0}
                                delete2(id: p.id)})
                        }
                    } header: {
                        Text(str.body.rawValue)
                    }
                }
            }
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
            .onAppear(perform: {EventAnalytics.screen(name: str.shop.rawValue)})
        }.navigationViewStyle(StackNavigationViewStyle())
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
    func delete2(id: Int){
        var num = 0
        for body in products2{
            if body.id == id {
                products2.remove(at: num)
            }
            num += 1
        }
    }
}


struct SkinItemView: View {
    var num: Int
    var p: Skin
    var callBack: ()->Void
    @State var isBought = false
    @EnvironmentObject var appState: AppState
    var body: some View {
            Button(action: {
                isBought.toggle()
            }, label: {
                HStack{
                    Image(p.image,bundle: .main)
                        .resizable()
                        .frame(width: 90.0, height: 90.0, alignment: .center)
                    VStack{
                        Text(p.name).font(.title)
                        if(p.dia != nil){
                            HStack(alignment: .center){
                                Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                                Text(String(p.dia!)).font(.title)
                            }
                        }else{
                            HStack(alignment: .center){
                                Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                                Text(String(p.coin)).font(.title)
                            }
                        }
                    }
                }
            })
            .alert(isPresented: $isBought) {
                if ShopViewModel.checkCanBuy(price: p.coin, dia: p.dia){
                    return Alert(title: Text(str.doYouBuyIt.rawValue),
                                 message: Text(p.name),
                                 primaryButton: .cancel(Text(str.quite.rawValue)),
                                 secondaryButton: .default(Text(str.purchase.rawValue),
                                                           action: {callBack()}))
                }else{
                    //self.appState.isPurchaseView = true;EventAnalytics.screen(name: str.in_app_purchase.rawValue)
                    return Alert(title: Text(str.noMoney.rawValue),
                                 dismissButton: .default(Text(str.modoru.rawValue),action: {}))
                }
            }
//        if num == 0{　　アイテムを一つずつしか買えなくするUI
//        }else{
//            HStack{
//                Image(systemName: "questionmark.circle.fill")
//                    .resizable()
//                    .frame(width: 40.0, height: 40.0, alignment: .leading)
//                Text(p.name).font(.title)
//            }
//        }
    }
}
struct BodyItemView: View {
    var p: Body
    var callBack: () -> Void
    @State var isBought = false
    @EnvironmentObject var appState: AppState
    var body: some View {
        Button(action: {
            isBought.toggle()
        }, label: {
            HStack{
                Image(uiImage:RenderUtil.showRender(skin: 0, body: p.id))
                    .resizable()
                    .frame(width: 50.0, height: 100.0, alignment: .leading)
                VStack{
                    Text(p.name).font(.title)
                    if(p.dia != nil){
                        HStack(alignment: .center){
                            Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                            Text(String(p.dia!)).font(.title)
                        }
                    }else{
                        HStack(alignment: .center){
                            Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                            Text(String(p.coin)).font(.title)
                        }
                    }
                }
            }
        })
        .alert(isPresented: $isBought) {
            if ShopViewModel.checkCanBuy(price: p.coin, dia: p.dia){
                return Alert(title: Text(str.doYouBuyIt.rawValue),
                             message: Text(p.name),
                             primaryButton: .cancel(Text(str.quite.rawValue)),
                             secondaryButton: .default(Text(str.purchase.rawValue),
                                                       action: {callBack()}))
            }else{
                return Alert(title: Text(str.noMoney.rawValue),
                             dismissButton: .default(Text(str.modoru.rawValue),action: {}))
            }
        }
    }
}

