////
////  CharacterView.swift
////  ShiranAppNew
////
////  Created by user on 2022/02/19.
////
//
//import SwiftUI
//
////キャラクター
//struct CharacterView: View {
//    
//    @ObservedObject var cM = CharacterModel()
//    @State var level: Int = UserDefaults.standard.integer(forKey: Keys.level.rawValue)
//    
//    var body: some View {
//        NavigationView{
//            List(cM.characters){ item in
//                if level >= item.level {
//                    Button(action: {
//                        self.cM.itemOpen = true
//                        //self.itemTap = true
//                    }, label: {
//                        HStack{
//                            Image(item.image,bundle: .main)
//                                .resizable()
//                                .frame(width: 90.0, height: 90.0, alignment: .leading)
//                            VStack(alignment: .center){
//                                Text(item.name).font(.title)
//                            }
//                        }
//                    }).sheet(isPresented: self.$cM.itemOpen){
//                        actCharacterView(char: item, cM: self.cM)
//                    }
//                }else{
//                    HStack{
//                        Image(systemName: "questionmark.circle.fill")
//                            .resizable()
//                            .frame(width: 80.0, height: 80.0, alignment: .leading)
//                        Text(str.characterViewText1.rawValue + String(item.level) + str.characterViewText2.rawValue).font(.title)
//                    }
//                }
//                
//            }
//            /*.onAppear(perform: {
//             if !self.appState.coachOpenChar{
//             dialogPresentation.show(content: .contentDetail3(isPresented: $dialogPresentation.isPresented))
//             }
//             })*/
//            .navigationTitle(str.suketto.rawValue)
//            .navigationBarTitleDisplayMode(.inline)
//        }.navigationViewStyle(StackNavigationViewStyle())
//        //.customDialog(presentaionManager: dialogPresentation)
//        
//    }
//}
//
