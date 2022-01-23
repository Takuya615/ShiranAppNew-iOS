//
//  UserOpinionView.swift
//  ShiranAppNew
//
//  Created by user on 2022/01/22.
//

import SwiftUI

struct UserOpinionView: View {
    @EnvironmentObject var appState: AppState
    @State var text: String = ""
    @State var progress = false
    @State var attention: String = "※このメッセージは個人を特定できるものではありません。そのため、返信も致しかねます。"
    var body: some View {
        VStack {
            HStack{
                Button(action: {self.appState.isOpinionView = false},
                       label: {Text("  ＜Back").font(.system(size: 20))})
                Spacer()
            }
            Text("\n✉️ ご意見・ご感想").font(.title)
            Text("「もっとこうして欲しい」「こうなったら嬉しい」といった、みなさまのご要望をお聞かせください。\n").font(.body)
            
            TextEditor(text: $text)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 300)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
            Text(attention).font(.subheadline)
            HStack{
                Spacer()
                Button(action: {if !text.isEmpty{sendOpinion(message: text);progress = true}},
                       label: {
                    if progress {
                        ProgressView()
                    }else{
                        Text("送信")
                            .font(.title)
                            .foregroundColor(.pink)
                            .frame(width: 100, height: 40, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.pink, lineWidth: 2)
                            )
                    }
                }).padding(.trailing,40)
            }

            Spacer()
            
        }.onTapGesture(perform: { UIApplication.shared.closeKeyboard()})
        
    }
    
    
    func sendOpinion(message: String){
        let master_mail = "shiran.app.club@gmail.com"
        let smtpSession = MCOSMTPSession()
        //注意　hostname="imap.gmail.com"ならport=993,  hostname="smtp.gmail.com"ならport=465 or 587
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.port = 465
        smtpSession.username = "shiran.app.club@gmail.com"
        smtpSession.password = "toujizu4"
        smtpSession.isCheckCertificateEnabled = false
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        /*smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("コネクトろぐConnectionlogger: \(string)")
                }
            }
        }*/
        
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "運営", mailbox: master_mail) as Any]
        builder.header.from = MCOAddress(displayName: "ユーザー", mailbox: master_mail)
        builder.header.subject = "クライアント　フィードバック"
        builder.htmlBody = message
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data!)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                self.progress = false
                self.attention = "エラー：通信環境をお確かめのうえ、もう一度お願いします。"
                //NSLog("エラーError sending email: \(String(describing: error))")
            } else {
                self.appState.isOpinionView = false
                //NSLog("せいこう！！Successfully sent email!")
            }
        }
    }
}

struct UserOpinionView_Previews: PreviewProvider {
    static var previews: some View {
        UserOpinionView()
    }
}
