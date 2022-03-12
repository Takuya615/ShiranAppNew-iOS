//
//  DialogPresentation.swift
//  ShiranAppNew
//
//  Created by user on 2021/10/27.
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
    @State var page: Bool = false
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
                       label: {Text("❎閉じる")})
            }
            if !page {
                Text("デイリーチャレンジ").font(.title)
                Image("enemy1")
                    .resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .leading)
                Text("毎日、その日の")
                Text("はじめの１回だけ").foregroundColor(.red)
                Text("モンスターがあらわれます")
                Button(action: { page = true }, label: {Text("\nつぎへ\n")})
            }else{
                Text("デイリーチャレンジ").font(.title)
                Image("enemy1")
                    .resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .leading)
                Text("\n彼らはあなたの")
                Text("なまけ心の化身です").foregroundColor(.red)
                Text("今すぐ撃退しましょう！！\n")
                Button(action: { page = false }, label: {Text("\nまえへ\n")})
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
                       label: {Text("❎とじる")})
            }
            if page1 == 3 {
                Text("クエスト").font(.title)
                //Text("\nクエストをこなすと、コインや経験値を集めることもできます。")
                Text("\nデイリーのほか、クエスト（ミニゲーム）で遊ぶこともできます。\n")//.foregroundColor(.red)
                Text("\n↓ の「クエスト」をタップ\n").foregroundColor(.red)
                Button(action: { page1 = 1 }, label: {Text("\nもどる\n")})
                
            }else if page1 == 2{
                Text("難易度の調整").font(.title)
                Text("\nバーピーはカンタンすぎる？\n右上のメニューボタン→設定で難易度を変えることもできます。").font(.body)
                Button(action: { page1 = 3 }, label: {Text("\n次へ\n")})
            }else if page1 == 1{
                Text("おめでとう！！").font(.title)
                Text("\n今日のあなたは、\nじぶんの怠惰を克服しました！\n\n短い時間でも毎日こなして、まずは「毎日する」という意識をクセにしましょう").font(.body)
                Button(action: { page1 = 2 }, label: {Text("\n次へ\n")})
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
