
import SwiftUI

struct UserOpinionView: View {
    @EnvironmentObject var appState: AppState
    @State var text: String = ""
    @State var progress = false
    @State var attention: String = str.userOpinion1.rawValue
    var body: some View {
        VStack {
            BackKeyView(callBack: {self.appState.isOpinionView.toggle()})
            Text(str.userOpinion2.rawValue).font(.title)
            Text(str.userOpinion3.rawValue).font(.body)
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
                        Text(str.sendMail.rawValue)
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
            
        }
        .onTapGesture(perform: { UIApplication.shared.closeKeyboard()})
        .onAppear(perform: {EventAnalytics.screen(name: str.opinion.rawValue)})
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
        builder.header.to = [MCOAddress(displayName:str.messageTo.rawValue, mailbox: master_mail) as Any]
        builder.header.from = MCOAddress(displayName: str.messageFrom.rawValue, mailbox: master_mail)
        builder.header.subject = str.messageTitle.rawValue
        builder.htmlBody = message
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data!)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                self.progress = false
                self.attention = str.userOpinionError.rawValue
                //NSLog("エラーError sending email: \(String(describing: error))")
            } else {
                self.appState.isOpinionView = false
                //NSLog("せいこう！！Successfully sent email!")
            }
        }
    }
}

