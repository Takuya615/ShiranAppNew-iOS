
import SwiftUI

struct HomeView: View{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataCounter: DataCounter
    @State var isOpenSideMenu = false
    
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        let height = bounds.height
        NavigationView{
            VStack{
                HStack{
                    VStack{
                        Text(str.count_retry.rawValue)
                            .font(.system(size: 20, weight: .black, design: .default))
                            .foregroundColor(.blue)
                        
                        Text(String(self.dataCounter.continuedRetryCounter))
                            .font(.system(size: 50, weight: .black, design: .default))
                            .frame(width: 100, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                    }
                    VStack{
                        Text(str.count_continue.rawValue)
                            .font(.system(size: 20, weight: .black, design: .default))
                            .foregroundColor(.blue)
                        Text(String(self.dataCounter.continuedDayCounter))
                            .font(.system(size: 50, weight: .black, design: .default))
                            .frame(width: 100, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                    }
                }
                ZStack{
                    Image(uiImage:BodyRender.showRender())
                        .resizable()
                        .frame(width:width/2, height: height*0.6)
                    Rectangle()
                        .onTapGesture {self.appState.isItemSelectView = true}
                        .foregroundColor(Color.gray.opacity(0.1))
                        .frame(width:width/2, height: height*0.6)
                }
                if self.appState.showWanWan {
                    Image("char_dog")
                        .resizable()
                        .frame(width: 80.0, height: 80.0, alignment: .leading)
                }
            }
            .onAppear(perform: {
                self.dataCounter.countedLevel = UserDefaults.standard.integer(forKey: Keys.level.rawValue)//データ更新
                self.dataCounter.continuedDayCounter = UserDefaults.standard.integer(forKey: Keys.continuedDay.rawValue)
                self.dataCounter.continuedRetryCounter = UserDefaults.standard.integer(forKey: Keys.retry.rawValue)
                if CharacterModel.useTaskHelper() > 1.0 {
                    self.appState.showWanWan = true
                }else{
                    self.appState.showWanWan = false
                }
            })
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    toolbarItemView()
                }
                ToolbarItem(placement: .navigationBarLeading){
                    HStack{
                        Text(UserDefaults.standard.string(forKey: Keys.myName.rawValue) ?? "")
                        Text("  Lv. \(self.dataCounter.countedLevel)  ")
                        Image("coin").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedCoin)")
                        Image("diamonds").resizable().frame(width: 30.0, height: 30.0, alignment: .leading)
                        Text(" \(self.dataCounter.countedDiamond)")
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
