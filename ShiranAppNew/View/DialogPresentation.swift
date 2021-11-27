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
    case contentDetail3(isPresented: Binding<Bool>)
    case contentDetail4(isPresented: Binding<Bool>)
    case contentDetail5(isPresented: Binding<Bool>)
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .contentDetail1(let isPresented)://,let isHightLight):
            DialogContent1(isPresented: isPresented)//,isHightLight: isHightLight)
        case .contentDetail2(isPresented: let isPresented):
            DialogContent2(isPresented: isPresented)
        case .contentDetail3(isPresented: let isPresented):
            DialogContent3(isPresented: isPresented)
        case .contentDetail4(isPresented: let isPresented):
            DialogContent4(isPresented: isPresented)
        case .contentDetail5(isPresented: let isPresented):
            DialogContent5(isPresented: isPresented)
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
                Image("enemy1")
                    .resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .leading)
                Text("スライムがあらわれた").font(.title)
                Text("毎日はじめの１回だけ").foregroundColor(.red)
                Text("モンスターがあらわれます")
                
                
                Button(action: { page = true }, label: {Text("\n次へ\n")})
            }else{
                Text("\n彼らは、")
                Text("あなたのなまけ心の化身です").foregroundColor(.red)
                Text("今すぐ撃退しましょう！！\n")
            }
            
            /*Spacer()
            Button(action: {
                isPresented = false
                //isHightLight.toggle()
                appState.isVideo = true
                appState.coachMark3 = true
                UserDefaults.standard.set(true, forKey: "CoachMark3")
            }, label: {
                Image(systemName: "flame")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
            })
                .frame(width: 60, height: 60, alignment: .center)
                    .background(Color.orange)
                    .cornerRadius(30.0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 60.0, trailing: 16.0))*/
            
        }
        .onAppear(perform: { SystemSounds().buttonVib("") })
        .onDisappear(perform: {appState.coachMark3 = true; UserDefaults.standard.set(true, forKey: "CoachMark3")})
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct DialogContent2: View {
    @Binding var isPresented: Bool
    @State var page1 = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {isPresented = false},
                       label: {Text("❎閉じる")})
            }
            if page1 {
                //Text("クエスト").font(.title)
                Text("\nクエストをこなすと、コインや経験値を集めることもできます。")
                Text("\n↓ の「クエスト」をタップ\n").foregroundColor(.red)
                
            }else{
                Text("おめでとう！！").font(.title)
                Text("\n今日のあなたは、\nじぶんの怠惰を克服しました！\n\nしかし、日に日にモンスターも強くなっていきます").font(.body)
                Button(action: { page1 = true }, label: {Text("\n次へ\n")})
            }
            
        }
        .background(Color.white)
        .cornerRadius(8)
        .onDisappear(perform: {appState.coachMark4 = true; UserDefaults.standard.set(true, forKey: "CoachMark4")})
    }
}

struct DialogContent3: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {isPresented = false},
                       label: {Text("❎閉じる")})
            }
            Text("クエスト").font(.title)
            Text("クエストを設定すると、チャレンジボタン🔥から、")
            
        }
        .background(Color.white)
        .cornerRadius(8)
    }
}
struct DialogContent4: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {isPresented = false},
                       label: {Text("❎閉じる")})
            }
            Text("クエスト").font(.title)
            Text("クエストを設定すると、チャレンジボタン🔥から、")
            
        }
        .background(Color.white)
        .cornerRadius(8)
    }
}
struct DialogContent5: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {isPresented = false},
                       label: {Text("❎閉じる")})
            }
            Text("クエスト").font(.title)
            Text("クエストを設定すると、チャレンジボタン🔥から、")
            
        }
        .background(Color.white)
        .cornerRadius(8)
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
