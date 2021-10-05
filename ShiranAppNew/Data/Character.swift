//
//  Character.swift
//  ShiranAppNew
//
//  Created by user on 2021/09/23.
//

import SwiftUI

class Character {
    func items() -> [character] {
        return
            [character.init(level: 1, score: 300, image: "char_margin", name: "ランプの魔神",
                            scr: """
運動する場所を１つにしぼる。
スマホを設置する位置を決めて、そこでのみ運動しましょう。

記入例）寝室のカベにスマホを立てかけて、ヨガマットの上で運動する。

Exp ＋３００p
"""),
             character.init(level: 2,score: 0, image: "char_dog", name: "わんわん",
                            scr: """
決まった時間に運動する。
決めた時間から ±15分以内だと、わんわんが力を貸してくれます。

毎回のスコア 1.2倍
"""),
             character.init(level: 3,score: 800, image: "char_rabbit", name: "二兎",
                            scr: """
運動の種類を1つにしぼる。
「今日は何をしようか？」と迷うと、運動がめんどくさく感じることもあります。
定期的に変えてもいいので、あらかじめ運動の種類は１つに決めましょう。

記入例）　この２週間はバーピーだけをする。
Exp ＋8００p

""")
             
            
            ]
    }
    
    
    func useCharacter(item: character) -> Bool {
        let user = UserDefaults.standard
        let charText = user.object(forKey:item.image) as? String
        if charText == nil {return false}
        let isUsed = user.bool(forKey: "used\(item.image)")
        if !isUsed {
            DataCounter().levelUp(score: item.score)
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
}

struct character: Identifiable {
    var id = UUID()     // ユニークなIDを自動で設定¥
    var level: Int
    var score: Int
    var image: String
    var name: String
    var scr: String
    
}


struct actCharacterView: View {
    
    //@Environment(\.presentationMode) var presentationMode
    @State var text: String = ""
    @State private var selectionDate = Date()
    @State var scoreUp: Bool = false
    var char: character
    init(char: character) {
        self.char = char
    }
    
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
        
    }
    
}
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
