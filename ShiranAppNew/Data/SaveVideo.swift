//
//  SaveVideo.swift
//  ShiranApp
//
//  Created by user on 2021/08/24.
//

import Foundation
import Firebase
import AVFoundation
//import AssetsLibrary


class SaveVideo{
    func saveData(score: Int){
        //日時の指定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale =  Locale(identifier: "ja_JP")
        let date = dateFormatter.string(from: Date())
        
        let dateList: [String]? = UserDefaults.standard.array(forKey: DataCounter().listD) as? [String]
        let scoreList:[Int]? = UserDefaults.standard.array(forKey: DataCounter().listS) as? [Int]
        
        if var dateList = dateList, var scoreList = scoreList {
            dateList.append(date)
            scoreList.append(score)
            print("リストseve data \(dateList)  score \(scoreList)")
            UserDefaults.standard.setValue(dateList, forKey: DataCounter().listD)
            UserDefaults.standard.setValue(scoreList, forKey: DataCounter().listS)
        }else {
            print("リストが nil になっている")
            UserDefaults.standard.setValue([date], forKey: DataCounter().listD)
            UserDefaults.standard.setValue([score], forKey: DataCounter().listS)
        }
        
    }
    //Firebase
    func saveData2(score: Int){
        guard let auth = Auth.auth().currentUser else{return}
        let uid = String(auth.uid)//uidの設定
        //日時の指定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SSS"
        dateFormatter.locale =  Locale(identifier: "ja_JP")
        let date = dateFormatter.string(from: Date())
        
        let db = Firestore.firestore()
        db.collection(uid).document(date).setData([
            "date": date,
            "url": "",
            "score": score
        ]) { err in
            if let err = err {
                print("URLと日時　Error adding document: \(err)")
            } else {
                print("URLと日時　Document added")
            }
        }
    }
    /*
    //動画とそのURLをStoreに保存するメソッド
    func saveVideo(outputFileURL: URL){
        let uid = String(Auth.auth().currentUser!.uid)//uidの設定
        //日時の指定
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMddHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        //let date = dateFormatter.string(from: Date())
        //ビデオ保存用
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SSS"
        dateFormatter.locale =  Locale(identifier: "ja_JP")
        let date = dateFormatter.string(from: Date())
        
        //FireBase  Storage
        //let localFile = URL(string: "path/to/image")!
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let riversRef = storageRef.child("\(uid) /\(date).mov")
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/mov"
        
        // Upload the file to the path "images/rivers.jpg"
        riversRef.putFile(from: outputFileURL, metadata: metadata) { metadata, error in
          riversRef.downloadURL { (url, error) in
            guard url != nil else {// Uh-oh, an error occurred! エラーした場合の記述
                print("エラー　URL生成しっぱい　\(String(describing: error))")
                return
            }
            
            //ここでURLを保存できそう！！！
            let db = Firestore.firestore()
            db.collection(uid).document(date).setData([
                "date": date,
                "url": url!.absoluteString
            ]) { err in
                if let err = err {
                    print("URLと日時　Error adding document: \(err)")
                } else {
                    print("URLと日時　Document added")
                }
            }
            
            
            
          }
        }
            
        
    }*/
    
}
