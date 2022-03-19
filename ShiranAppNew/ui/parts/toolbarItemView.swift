//
//  toolbarItemView.swift
//  ShiranAppNew
//
//  Created by user on 2022/03/13.
//

import SwiftUI
struct toolbarItemView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        Menu{
            Button(action: {
                appState.isSettingView = true
            }) {
                Text(str.set.rawValue)
                Image(systemName: "gear")//"gearshape")
            }
            Button(action: {
                appState.isExplainView = true
            }) {
                Text(str.detailApp.rawValue)
                Image(systemName: "info.circle")//"gearshape")
            }
            /*
             if self.appState.isinAccount {
             Button(action: {
             appState.logout()
             }) {
             Text("ログアウト")
             Image(systemName: "person")
             }
             }else{
             Button(action: {
             appState.isLogin = true
             }) {
             Text("アカウント設定")
             Image(systemName: "person")
             }
             }*/
            
            Button(action: {
                appState.isPrivacyPolicy = true
            }) {
                Text(str.privacy_policy.rawValue)
                Image(systemName: "shield")
            }
            Button(action: {
                guard let writeReviewURL = URL(string: "https://twitter.com/G0DhdLNn4SftTjc")
                else { fatalError("Expected a valid URL") }
                UIApplication.shared.open(writeReviewURL)
            }) {
                Text(str.twitter.rawValue)
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
            }
            Button(action: {
                appState.isOpinionView = true
            }) {
                Text(str.opinion.rawValue)
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
            }
            /*
             Button(action: {
             guard let writeReviewURL = URL(string: "https://apps.apple.com/us/app/%E3%81%97%E3%82%89%E3%82%93%E3%83%97%E3%83%AA/id1584268203")
             else { fatalError("Expected a valid URL") }
             UIApplication.shared.open(writeReviewURL)
             }) {
             Text("アプリを評価する")
             Image(systemName: "rectangle.and.pencil.and.ellipsis")
             }*/
            
            
            Button(action: {
                UserDefaults.standard.removeAll()
                exit(0)
            }) {
                Text(str.reset.rawValue)
                Image(systemName: "shield")
            }
            
            Button(action: {
                let LastTimeDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                UserDefaults.standard.set(LastTimeDay, forKey: Keys._LastTimeDay.rawValue)
            }) {
                Text(str.oneDayReset.rawValue)
                Image(systemName: "shield")
            }
            
            /*
             @IBAction func share() {
             //share(上の段)から遷移した際にシェアするアイテム
             let activityItems: [Any] = [shareText, shareUrl]
             let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: [LINEActivity(message: shareText), TwitterActivity(message: shareText)])
             self.present(activityViewController, animated: true, completion: nil)
             }
             */
        }label: {
            Image(systemName: "line.horizontal.3")
                .resizable()
                .frame(width: 25, height: 15, alignment: .topLeading)
        }
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 10))
    }
}
