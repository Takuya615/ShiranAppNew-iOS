
import SwiftUI

struct ExplainAppView: View {
    @EnvironmentObject var appState: AppState
    @State private var btn0 = false
    @State private var btn01 = false
    @State private var btn1 = false
    @State private var btn2 = false
    @State private var btn3 = false
    
    var body: some View {
        VStack{
            BackKeyView(callBack: {self.appState.isExplainView.toggle()})
            Spacer()
            Text(str.exp1.rawValue).font(.title)
                .onAppear(perform: { if !appState.coachMark1{btn0 = true}})
            List{
                Button(action: {
                    self.btn0.toggle()
                }, label: {
                    HStack{
                        Text(str.expTitle1.rawValue)
                        Image(systemName: "play.rectangle.fill")
                            .foregroundColor(.red)
                    }
                }).sheet(isPresented: self.$btn0, content: {
                    PlayerView()
                })
                /*Button(action: {
                 self.btn01.toggle()
                 }, label: {
                 HStack{
                 Text("敵モンスターの倒しかた")
                 Image(systemName: "play.rectangle.fill")
                 .foregroundColor(.red)
                 }
                 }).sheet(isPresented: self.$btn01, content: {
                 PlayerView2()
                 })*/
                Button(str.expTitle2.rawValue){
                    self.btn1.toggle()
                }.sheet(isPresented: self.$btn1, content: {
                    Explanation1()
                })
                Button(str.expTitle3.rawValue){
                    self.btn2.toggle()
                }.sheet(isPresented: self.$btn2, content: {
                    Explanation2()
                })
                Button(str.expTitle4.rawValue){
                    self.btn3.toggle()
                }.sheet(isPresented: self.$btn3, content: {
                    Explanation3()
                })
                
            }
            
        }
        
    }
}

struct Explanation1: View {
    var body: some View {
        Text(str.expTitle2.rawValue).font(.title)
        
        Text(str.exp2.rawValue)
            .foregroundColor(.red)
            .bold()
            .font(.system(size: 25, design: .default))
        Text(str.exp2_2.rawValue)
    }
}
struct Explanation2: View {
    var body: some View {
        Text(str.expTitle3.rawValue).font(.title)
        Text(str.exp3.rawValue)
    }
}
struct Explanation3: View {
    var body: some View {
        Text(str.expTitle4.rawValue).font(.title)
        
        Text(str.exp4.rawValue)
    }
}
