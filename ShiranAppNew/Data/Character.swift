//
//  Character.swift
//  ShiranAppNew
//
//  Created by user on 2021/09/23.
//

import SwiftUI

class Character: Identifiable {
    var id = UUID()     // ユニークなIDを自動で設定¥
    var level: Int
    var score: Int
    var image: String
    var name: String
    var scr: String
    init(level: Int,score: Int,image: String,name: String,scr: String){
        self.level = level
        self.score = score
        self.image = image
        self.name = name
        self.scr = scr
    }
}
class CharacterModel: ObservableObject {
    
    func useCharacter(item: Character) -> Bool {
        let user = UserDefaults.standard
        //let charText = user.object(forKey:item.image) as? String
        //if charText == nil {return false}
        let isUsed = user.bool(forKey: "used\(item.image)")
        if !isUsed {
            //DataCounter().levelUp(score: item.score)
            user.set(true, forKey: "used\(item.image)")
            return true
        }
        return false
    }
    
    func useTaskHelper() -> Float{
        let user = UserDefaults.standard
        guard let wanwan = user.object(forKey: "char_dog") as? Date else {return 1.0}
        let now = Date()
        let cal = Calendar(identifier: .gregorian)
        let nowDC = Calendar.current.dateComponents([.hour,.minute], from: now)
        let setDC = Calendar.current.dateComponents([.hour,.minute], from: wanwan)
        let diff = cal.dateComponents([.minute], from: setDC, to: nowDC)
        if abs(diff.minute!) < 16 { return 1.2 }
        return 1.0
    }
    
    @Published var itemOpen = false
    @Published var characters: [Character] = [
        Character(level: 1, score: 300, image: "char_kame", name: "かめ",
                  scr: """


・毎日しようと思っても、つい忘れてしまう方
・習慣化に慣れていない方
・できるだけラクしたいという方

に特に必須のテクニックを、カメは教えてくれます。


Exp ＋３００p
"""),
        Character(level: 2,score: 0, image: "char_dog", name: "わんわん",
                  scr: """

こんな人に特にオススメ
・手をつける前に、ついグズグズと悩んでしまいがちな方
・時間感覚に敏感な方
・先延ばしにしがちな方
・犬が好きな方


デイリーのスコア 1.2倍
"""),
        Character(level: 3,score: 800, image: "char_rabbit", name: "ニト",
                  scr: """

なにかを始める前に、’段取り’や’効率’をあれこれ意識してしまって、「めんどくさい」と感じたことはありませんか？？
そんな方には、特に相性のいい組み合わせかもしれません。

デイリーでする運動の種類を１つに絞ります。


Exp ＋8００p

""")
    ]
    
    
}



struct actCharacterView: View {
    
    var char: Character
    @ObservedObject var cM: CharacterModel
    
    @State var text: String = ""
    @State var scoreUp: Bool = false
    @State var page = 1
    @State var nowPage = 1
    @State var charaView = Spacer()
    
    
    var body: some View{
        VStack{
            switch char.name {
            case "わんわん": wanwan(nowPage: nowPage, char: char,cM: cM).onAppear(perform: {page = 2})
            case "ニト": nito(nowPage: nowPage, char: char,cM: cM).onAppear(perform: {page = 6})
            default: kame(nowPage: nowPage, char: char,cM: cM).onAppear(perform: {page = 5})
            }
            
            Spacer()
            HStack{
                Spacer()
                if nowPage > 1 {
                    Button(action: {nowPage -= 1}, label: {Image(systemName: "arrowtriangle.left.fill")})
                        .padding()
                }
                Spacer()
                Text("\(nowPage) / \(page+1)").padding()
                Spacer()
                if nowPage < page+1 {
                    Button(action: {nowPage += 1}, label: {Image(systemName: "arrowtriangle.right.fill")})
                        .padding()
                }
                Spacer()
            }
        }
    }
    
    /*struct a:View{
        var nowPage:Int
        var char: Character
        @ObservedObject var cM: CharacterModel
        var body: some View{
            
        }
    }*/
    
    //各キャラのView
    struct kame:View{
        var nowPage:Int
        var char: Character
        @ObservedObject var cM: CharacterModel
        var body: some View{
            switch nowPage {
            case 1: charaIntro(char: self.char,cM: cM)
            case 2: messageView(title: "ステップ１",message: "A４コピー用紙とペンを用意してください")
            case 3: paintLikeThis(char: self.char)
            case 4: messageView(title: "ステップ3",message: "かいた紙を運動するスペースの床に貼り付けます。")
            case 5: messageView(title: "解説", message: "これはポジティブキューと呼ばれるテクニックの１つです。\n忙しい日でも張り紙を見て、毎日すべきことを思い出せます。\n\nまた、しばらく続けていると脳が「ここに移動したら運動する」ということを覚え、気持ちの面でラクに運動を始められるようになっていきます。")
            default: finish(char:char, cM: cM)
            }
        }
    }
    struct wanwan:View{
        var nowPage:Int
        var char: Character
        @ObservedObject var cM: CharacterModel
        var body: some View{
            switch nowPage {
            case 1: charaIntro(char: self.char,cM: cM)
            case 2: datePicker(char: char)
            //case 3: messageView(title: "", message: "")
            //case 4: messageView(title: "ステップ3",message: "")
            default: finish(char:char,cM: cM)
            }
        }
    }
    struct nito:View{
        var nowPage:Int
        var char: Character
        @ObservedObject var cM: CharacterModel
        var body: some View{
            switch nowPage {
            case 1: charaIntro(char: self.char,cM: cM)
            case 2: messageView(title: "ステップ１",message: "A４コピー用紙とペンを用意してください")
            case 3: messageView(title: "ステップ2",message: "家の中でするエクササイズをできる限り書き出します。\n\n例）スクワット,腹筋...")
            case 4: messageView(title: "ステップ3",message:      "その中から好きなものを選び、「デイリーでは毎回このエクササイズをする！」と決めましょう。")
            case 5: messageView(title: "ステップ４", message:
                    "週ごとに種目を変えるのもオススメです。\n\n例えば、今週はスクワット、来週はニートゥーハンドをする。など\n\n予定を決めたら紙に書き出して、すぐに確認できるようにしましょう")
            case 6: messageView(title: "解説",message:
                    "ポイントはあらかじめその日に何をするか決めておくことです。\n\n人は次に何をすべきなのか、あいまいになると、めんどくさく感じて、その行動を中断してしまうクセがあります。\n\n迷いを無くしてスムーズに行動に移せるように、備えましょう")
            //case 7: messageView(title: "解説", message: "迷いを無くしてスムーズに行動に移せるように、備えましょう")
            default: finish(char:char,cM: cM)
            }
        }
    }
    
    //画面要素
    struct charaIntro:View{
        var char: Character
        @ObservedObject var cM: CharacterModel
        var body: some View{
            VStack{
                HStack{Spacer(); Button("\n❌とじる"){cM.itemOpen = false}}.padding()
                Image(self.char.image)
                    .resizable()
                    .frame(width: 150.0, height: 150.0, alignment: .leading)
                Text("")
                Text(self.char.scr)
                Text("")
                //Button(action: {self.itemTap = false}, label: {Text("閉じる")})
                
            }
        }
    }
    struct messageView:View{
        var title: String
        var message: String
        var body: some View{
            VStack{
                Text(title).font(.title).padding()
                Spacer()
                Text(message)
                Spacer()
            }
        }
    }
    //亀のオリジナルView
    struct paintLikeThis:View{
        var char: Character
        var body: some View{
            VStack{
                Text("ステップ２").font(.title)
                Text("紙いっぱいに、次のように、描いてください")
                ZStack{
                    Rectangle()
                        .stroke(Color.black, lineWidth: 5)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 450, alignment: .leading)
                    VStack{
                        Text("毎日ここで").font(.system(.title, design: .serif))
                        Image(char.image).resizable().frame(width: 250, height: 250, alignment: .leading)
                        Text("運動する").font(.system(.title, design: .serif))
                    }
                }
            }.saturation(0.0)
        }
    }
    //わんわんのオリジナルVIew
    struct datePicker: View{
        var char: Character
        @State var selectionDate: Date = Date()
        @State var text = ""
        var body: some View{
            VStack{
                Text("時間の設定").font(.title).padding()
                Text("あらかじめ、デイリーをする時間を設定してください。\n\n設定した時間の＋ー１５分以内だと、デイリースコアが通常の1.2倍").padding()
                DatePicker("時刻", selection: $selectionDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .onAppear(perform: {
                        let setDate = UserDefaults.standard.object(forKey:self.char.image ) as? Date
                        if let setDate:Date = setDate {
                            selectionDate = setDate
                            let setDC = Calendar.current.dateComponents([.hour,.minute], from: setDate)
                            text = "設定時間　\(setDC.hour!):\(setDC.minute!)"
                        }
                        
                    })
                Text(text)
                Button("決定"){
                    let newDC = Calendar.current.dateComponents([.hour,.minute], from: selectionDate)
                    text = "設定時間　\(newDC.hour!):\(newDC.minute!)"
                    UserDefaults.standard.set(selectionDate, forKey: self.char.image)
                }.font(.title).padding()
            }
            
        }
    }
    
    struct finish:View{
        var char: Character
        @ObservedObject var cM: CharacterModel
        @State var scoreUp: Bool = false
        @State var text = ""
        var body: some View{
            VStack{
                HStack{Spacer(); Button("\n❌とじる"){cM.itemOpen = false}}.padding()
                Image(self.char.image)
                    .resizable()
                    .frame(width: 150.0, height: 150.0, alignment: .leading)
                Text("\(char.name)の力を借りますか？？")
                Spacer()
                Button("借りる"){
                    let canUse = cM.useCharacter(item: char)
                    if canUse {
                        EventAnalytics().doneQuest()
                        text = DataCounter().mes(score: char.score, str: "")
                        self.scoreUp = true
                    }else{
                        cM.itemOpen = false
                    }
                    
                }
                .font(.title)
                .padding()
                .alert(isPresented: self.$scoreUp) {
                        if char.score == 0 {
                            return Alert(title: Text("設定されました"))
                        }else{
                            return Alert(
                                title:Text(text),
                                dismissButton: .default(Text("了解"),action: {cM.itemOpen = false})
                            )
                        }
                    }
                Spacer()
            }
        }
    }
    /*
    var body: some View{
        VStack{
            VStack{
                Image(self.char.image)
                    .resizable()
                    .frame(width: 100.0, height: 100.0, alignment: .leading)
                Text("")
                Text(self.char.scr)
                Text("")
                
            }
            .onTapGesture {  UIApplication.shared.closeKeyboard() }
            
            
            switch char.name{
            case "わんわん":
                DatePicker("時刻", selection: $selectionDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .onAppear(perform: {
                        let setDate = UserDefaults.standard.object(forKey:self.char.image ) as? Date
                        if let setDate:Date = setDate {selectionDate = setDate}
                    })
                    
            default:
                TextEditor(text: $text)
                    .frame(width: 300, height: 150)
                    .border(Color.blue, width: 1)
                    .onAppear(perform: {
                        let charText = UserDefaults.standard.object(forKey:self.char.image ) as? String
                        if let charText = charText { text = charText } else {text = "ここに記入"}
                    })
            }
            HStack{
                Spacer()
                Button(action: {
                    
                    switch char.name{
                    case "わんわん":do {
                        UserDefaults.standard.set(selectionDate, forKey: self.char.image)
                        //self.scoreUp = true
                    }
                    case "ニト":do{//最後のキャラが使われたらアナリティクスに知らされる。
                        UserDefaults.standard.set(text, forKey: self.char.image)
                        let plusScore = Character().useCharacter(item: char)
                        if plusScore { self.scoreUp = true}
                        EventAnalytics().lastCharacterReleased()
                    }
                    default:do {
                        UserDefaults.standard.set(text, forKey: self.char.image)
                        let plusScore = Character().useCharacter(item: char)
                        if plusScore { self.scoreUp = true}
                    }
                    }
                    
                    //self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("決定")})
                .font(.title2)
                .padding(.trailing,100)
                .alert(isPresented: self.$scoreUp) {
                    if char.score == 0 {
                        return Alert(title: Text("設定されました"))
                    }else{
                        return Alert(title:Text("Score +\(char.score)"))
                    }
                }
            }
            
        }
        
    }*/
    
}
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
