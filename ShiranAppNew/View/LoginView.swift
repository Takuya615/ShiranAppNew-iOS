//
//  LoginView.swift
//  aaa
//
//  Created by user on 2021/06/17.
//
/*
import SwiftUI
//import Firebase

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    //@StateObject private var appControl = AppControl.shared
    var body: some View {
        Group{
            if self.appState.isPrivacyPolicy {
                PrivacyPolicyView()
            }else {
                LoginSettingView()
                
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            //.environmentObject(AppState())
    }
}

struct LoginSettingView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack{
            HStack{
                            Button(action: {self.appState.isLogin = false},
                                   label: {Text("  ＜Back").font(.system(size: 20))
                            })
                            Spacer()
                        }
            Spacer()
            
            if appState.isLoading == true {
                ProgressView("")
            }
            
            Text("\(appState.errorStr)").foregroundColor(.red).font(.body)
            
            TextField("メールアドレス", text: $email)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    /*TextField("パスワード", text: $password)
                                .font(.title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.alphabet)*/
            SecureField("パスワード", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title)
                .keyboardType(.alphabet)
                .padding(.bottom)
                    
            HStack{
                Spacer()
                Button(action: {self.appState.isPrivacyPolicy = true}, label: {
                    Text("プライバシーポリシー")
                })
                .padding(.bottom)
                .frame(height: 20.0)
            }.padding([.bottom, .trailing])
                    
            HStack{
                Button(action: {
                    if(email.isEmpty || password.isEmpty){
                        self.appState.errorStr = "アドレスもしくはパスワードが未入力"
                    }else{
                        appState.signup(email: email, password: password)
                        appState.isLoading = true
                    }
                },
                       label: {Text("アカウント作成")
                })
                Spacer()
                Button(action: {
                    if(email.isEmpty || password.isEmpty){
                        self.appState.errorStr = "アドレスもしくはパスワードが未入力"
                    }else{
                    appState.loginMethod(email: email, password: password)
                    appState.isLoading = true
                    }
                },
                       label: {Text("ログイン")})
            }.padding(.trailing)
            Spacer()
                
        }.padding(.all)
    }
}
*/
