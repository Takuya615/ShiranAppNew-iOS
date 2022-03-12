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

struct LoginSettingView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack{
            HStack{
                            Button(action: {self.appState.isLogin = false},
                                   label: {Text(str.back.rawValue).font(.system(size: 20))
                            })
                            Spacer()
                        }
            Spacer()
            
            if appState.isLoading == true {
                ProgressView("")
            }
            
            Text("\(appState.errorStr)").foregroundColor(.red).font(.body)
            
            TextField(str.mailAdress.rawValue, text: $email)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    /*TextField("パスワード", text: $password)
                                .font(.title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.alphabet)*/
            SecureField(str.password.rawValue, text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title)
                .keyboardType(.alphabet)
                .padding(.bottom)
                    
            HStack{
                Spacer()
                Button(action: {self.appState.isPrivacyPolicy = true}, label: {
                    Text(str.privacy_policy.rawValue)
                })
                .padding(.bottom)
                .frame(height: 20.0)
            }.padding([.bottom, .trailing])
                    
            HStack{
                Button(action: {
                    if(email.isEmpty || password.isEmpty){
                        self.appState.errorStr = str.noInput.rawValue
                    }else{
                        appState.signup(email: email, password: password)
                        appState.isLoading = true
                    }
                },
                       label: {Text(str.makeNewAccount.rawValue)
                })
                Spacer()
                Button(action: {
                    if(email.isEmpty || password.isEmpty){
                        self.appState.errorStr = str.noInput.rawValue
                    }else{
                    appState.loginMethod(email: email, password: password)
                    appState.isLoading = true
                    }
                },
                       label: {Text(str.login.rawValue)})
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
                                   label: {Text(str.back.rawValue).font(.system(size: 20))
                            })
                            Spacer()
                        }
            Spacer()
            
            if appState.isLoading == true {
                ProgressView("")
            }
            
            Text("\(appState.errorStr)").foregroundColor(.red).font(.body)
            
            TextField(str.selectName.rawValue, text: $name)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
            
            HStack{
                Spacer()
                Button(action: {
                    if name.isEmpty {appState.errorStr = str.fixName.rawValue; return}
                    appState.isLoading = true
                    let db = Firestore.firestore()
                    
                    db.collection("users").whereField("name", isEqualTo: name)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                appState.errorStr = str.sendMailError.rawValue
                                print("Error getting documents: \(err)")
                            } else {
                                if querySnapshot!.documents.isEmpty {
                                    appState.saveDetails(name: name)
                                }else {
                                    appState.isLoading = false
                                    appState.errorStr = str.sameNameError.rawValue
                                }
                                
                            }
                    }
                    
                },
                       label: {Text(str.select.rawValue)})
            }.padding(.trailing)
            Spacer()
        }
    }
}
