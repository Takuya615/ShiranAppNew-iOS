//
//  LoginView.swift
//  aaa
//
//  Created by user on 2021/06/17.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    //@StateObject private var appControl = AppControl.shared
    var body: some View {
        Group{
            if self.appState.isPrivacyPolicy {
                PrivacyPolicyView()
            }else if self.appState.isNamed{
                NameSettingView()
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
                        self.appState.errorStr = "メールもしくはパスワードが未入力です"
                    }else{
                        appState.signup(email: email, password: password)
                        appState.isLoading = true
                    }
                },
                       label: {Text("新規アカウント作成")
                })
                Spacer()
                Button(action: {
                    if(email.isEmpty || password.isEmpty){
                        self.appState.errorStr = "メールもしくはパスワードが未入力です"
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


struct NameSettingView: View {
    @EnvironmentObject var appState: AppState
    @State private var name = ""
    
    var body: some View {
        VStack{
            HStack{
                            Button(action: {self.appState.isNamed = false},
                                   label: {Text("  ＜Back").font(.system(size: 20))
                            })
                            Spacer()
                        }
            Spacer()
            
            if appState.isLoading == true {
                ProgressView("")
            }
            
            Text("\(appState.errorStr)").foregroundColor(.red).font(.body)
            
            TextField("ニックネームを決めてください", text: $name)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
            
            HStack{
                Spacer()
                Button(action: {
                    if name.isEmpty {appState.errorStr = "名前を入力してください"; return}
                    appState.isLoading = true
                    let db = Firestore.firestore()
                    
                    db.collection("users").whereField("name", isEqualTo: name)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                appState.errorStr = "不明なエラー\n通信環境の良いところで、もう１度お試しください"
                                print("エらーError getting documents: \(err)")
                            } else {
                                if querySnapshot!.documents.isEmpty {
                                    appState.saveDetails(name: name)
                                }else {
                                    appState.isLoading = false
                                    appState.errorStr = "同じ名前を使っているユーザーがみつかりました\n別の名前に変更してください"
                                }
                                
                            }
                    }
                    
                },
                       label: {Text("決定")})
            }.padding(.trailing)
            Spacer()
        }
    }
}
