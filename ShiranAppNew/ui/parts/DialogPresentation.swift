//

import SwiftUI

final class DialogPresentation: ObservableObject {
    @Published var isPresented = false
    @Published var dialogContent: DialogContent?
    
    func show(content: DialogContent?){
        if let presentDialog = content {
            dialogContent = presentDialog
            isPresented = true
        }else{
            isPresented = false
        }
    }
}

enum DialogContent: View {
    case contentDetail1(isPresented: Binding<Bool>)//, isHightLight: Binding<Bool>)
    case contentDetail2(isPresented: Binding<Bool>)
    //case contentDetail3(isPresented: Binding<Bool>)
    //case contentDetail4(isPresented: Binding<Bool>)
    //case contentDetail5(isPresented: Binding<Bool>)
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .contentDetail1(let isPresented)://,let isHightLight):
            DialogContent1(isPresented: isPresented)//,isHightLight: isHightLight)
        case .contentDetail2(isPresented: let isPresented):
            DialogContent2(isPresented: isPresented)
            /*case .contentDetail3(isPresented: let isPresented):
             DialogContent3(isPresented: isPresented)
             case .contentDetail4(isPresented: let isPresented):
             DialogContent4(isPresented: isPresented)
             case .contentDetail5(isPresented: let isPresented):
             DialogContent5(isPresented: isPresented)*/
        }
    }
}

struct DialogContent1: View {
    @Binding var isPresented: Bool
    @State var page: Int = 1
    //@Binding var isHightLight: Bool
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    isPresented = false
                    self.appState.coachMarkf = true
                },
                       label: {Text(str.close.rawValue)})
            }
            if page == 1{
                Text(str.daylyChallenge.rawValue).font(.title)
                Image("enemy1")
                    .resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .leading)
                Text(str.dialog1_1_1.rawValue)
                Text(str.dialog1_1_2.rawValue).foregroundColor(.red)
                Text(str.dialog1_1_3.rawValue)
                Button(action: { page = 2 }, label: {Text(str.next.rawValue)})
            }else if page == 2{
                Text(str.daylyChallenge.rawValue).font(.title)
                Image("enemy1")
                    .resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .leading)
                Text(str.dialog1_2_1.rawValue)
                Text(str.dialog1_2_2.rawValue)
                Button(action: { page = 3 }, label: {Text(str.next.rawValue)})
            }else{
                Text(str.daylyChallenge.rawValue).font(.title)
                Image("enemy1")
                    .resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .leading)
                Text(str.dialog1_3_1.rawValue)
                Text(str.dialog1_3_2.rawValue)
                Text(str.dialog1_3_3.rawValue)
                Button(action: { page = 1 }, label: {Text(str.forword.rawValue)})
            }
            
            
        }
        .onAppear(perform: { SystemSounds.buttonVib("") })
        .onDisappear(perform: {appState.coachMark3 = true; UserDefaults.standard.set(true, forKey: "CoachMark3")})
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct DialogContent2: View {
    @Binding var isPresented: Bool
    @State var page1 = 1
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {isPresented = false},
                       label: {Text(str.close.rawValue)})
            }
            if page1 == 1 {
                Text(str.dialog2_1_1.rawValue).font(.title)//.foregroundColor(.red)
                Text(str.dialog2_1_2.rawValue)//.foregroundColor(.red)
                Text(str.dialog2_1_3.rawValue)
                Button(action: { page1 = 2 }, label: {Text(str.next.rawValue)})
                
            }else if page1 == 2{
                Text(str.dialog2_1_1.rawValue).font(.title)
                Text(str.dialog2_2_1.rawValue)
                Text(str.dialog2_2_2.rawValue)
                Text(str.dialog2_2_3.rawValue)
                Button(action: { page1 = 3 }, label: {Text(str.next.rawValue)})
                
            }else if page1 == 3{
                Text(str.dialog2_1_1.rawValue).font(.title)
                Text(str.dialog2_3_1.rawValue)
                Text(str.dialog2_3_2.rawValue)
                Button(action: { page1 = 4 }, label: {Text(str.next.rawValue)})
            }else{
                Text(str.dialog2_4_1.rawValue).font(.title)
                Text(str.dialog2_4_2.rawValue)
                HStack{
                    Button(action: { page1 = 1 }, label: {Text(str.forword.rawValue)})
                    Text("    ")
                    Button(action: { self.appState.isSettingView = true }, label: {Text(str.dialog2_4_button.rawValue)})
                    
                }
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .onDisappear(perform: {appState.coachMark4 = true; UserDefaults.standard.set(true, forKey: "CoachMark4")})
    }
}

struct CustomDialog: ViewModifier {
    @ObservedObject var presentationManager: DialogPresentation
    
    func body(content: Content) -> some View {
        ZStack{
            content
            
            if presentationManager.isPresented {
                Rectangle().foregroundColor(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                
                presentationManager.dialogContent
                    .padding(32)
            }
        }
    }
}

extension View {
    func customDialog(
        presentaionManager: DialogPresentation
    ) -> some View{
        self.modifier(CustomDialog(presentationManager: presentaionManager))
    }
}
