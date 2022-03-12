//
//  ExplainAppView.swift
//  ShiranAppNew
//
//  Created by user on 2021/09/09.
//

import SwiftUI

struct ExplainAppView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var btn1 = false
    @State private var btn2 = false
    @State private var btn3 = false
    @State private var btn4 = false
    @State private var btn5 = false
    
    var body: some View {
        HStack{
                Button(
                    action:{self.appState.isExplainView = false},
                    label: {Text("  ＜Back").font(.system(size: 20))
                        })
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        Spacer()
                }
        VStack{
            Spacer()
            Text(
                """
                
                これは半年で４分間のHIITを
                習慣にするためのアプリです。
                
                """
            ).font(.title)
            List{
                Button("アプリの流れ"){
                    self.btn1.toggle()
                }.sheet(isPresented: self.$btn1, content: {
                    Explanation1()
                })
                Button("HIITってなに？？"){
                    self.btn2.toggle()
                }.sheet(isPresented: self.$btn2, content: {
                    Explanation2()
                })
                Button("HIITのメリット"){
                    self.btn3.toggle()
                }.sheet(isPresented: self.$btn3, content: {
                    Explanation3()
                })
                Button("なぜ半年？？"){
                    self.btn4.toggle()
                }.sheet(isPresented: self.$btn4, content: {
                    Explanation4()
                })
            
                
                
            }

        }
        
    }
}

struct ExplainAppView_Previews: PreviewProvider {
    static var previews: some View {
        ExplainAppView()
    }
}

/// ２番めのView
struct Explanation1: View {
    var body: some View {
        Text("アプリの流れ").font(.title)
      
        Text("""
            
            ルールはカンタン。
            カメラで毎日、運動した記録をつけるだけ。
            
            
            初日はたったの５秒からスタート。
            ５秒　６秒　７秒　・・・　２４０秒
            いつの間にか４分間のHIITができるようになっています。
            
            
            あとはあなたが続けたいと思えば、
            気づくと引き締まった身体が手に入っています。
            一緒に頑張りましょう。
            """)
    }
}
struct Explanation2: View {
    var body: some View {
        Text("HIITってなに？？").font(.title)
        Text("""
            
            ハイ インテンシティ インターバル トレーニングの略で、
            
            　　　20秒　ハードな運動
            　　　　　　　↓
            　　　10秒　休む
            　　　　　　　↓
            　　　20秒　ハードな運動
            　　　　　　　↓
            　　　10秒　休む
            を繰り返す方法のことです。
            
            1分 HIITは、45分 ランニングに匹敵する身体機能アップ効果が確認されています。
            近年、もっとも効率の良い運動として注目を浴びています。
            本アプリでは、スクワットやバーピーなど、その場ですぐできる運動でHIITにトライしましょう。
            """)
    }
}
struct Explanation3: View {
    var body: some View {
        Text("HIITのメリット").font(.title)
        
        Text("""
            
            以下のような効果が科学的に確認されています。
            ①　ダイエット効果が高い！
            ②　空腹感がやわらぐ！
            ③　寿命が伸びる！
            ④　若返る！
            ⑤　疲れにくい体になる！
            ⑥　鬱や不安症にも効く！
            ⑦　心肺機能が向上！
            ⑧　基礎代謝が上がる！
            
            
            
            """)
    }
}
struct Explanation4: View {
    var body: some View {
        Text("なぜ半年？？").font(.title)
        
        Text("""
            
            習慣は日を重ねれば重ねるほど強固になります。
            これまで運動を全くしてこなかった人でも、より確実に身につけられるよう半年間としています。
            
            ロンドン大学の研究によると、運動のような負担の大きなタスクを習慣にするには時間がかかり、最大254日（８ヶ月強）かかる人もいたそうです。
            
            焦りは禁物
            """)
    }
}