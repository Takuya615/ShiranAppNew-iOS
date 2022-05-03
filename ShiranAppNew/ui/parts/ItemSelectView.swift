
import SwiftUI

struct ItemSelectView: View {
    @EnvironmentObject var appState: AppState
    private var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 5), spacing: CGFloat(0.0) ), count: 3)
    @State var skinNo = UserDefaults.standard.integer(forKey:Keys.selectSkin.rawValue)
    @State var bodyNo = UserDefaults.standard.integer(forKey:Keys.selectBody.rawValue)
    
    var body: some View {
        let items: [Int] = UserDefaults.standard.array(forKey: Keys.yourItem.rawValue) as? [Int] ?? [0] as [Int]
        let skins = Skin.skins
        let itemBodys: [Int] = UserDefaults.standard.array(forKey: Keys.yourBodys.rawValue) as? [Int] ?? [0] as [Int]
        VStack {
            BackKeyView(callBack: {self.appState.isItemSelectView.toggle()})
            ItemView(
                image: Image(uiImage:BodyRender.showRender(skin: skinNo, body: bodyNo)),
                callBack: {}, width: 75, height: 150)
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    Section {
                        ForEach((items), id: \.self) { num in
                            ItemView(image: Image(decorative: skins[num].image),
                                     callBack: {
                                UserDefaults.standard.set(num, forKey: Keys.selectSkin.rawValue)
                                skinNo = num
                            }, width: 70, height: 70)
                        }
                    } header: {
                        Text(str.item.rawValue)
                    }
                    Section {
                        ForEach(0 ..< itemBodys.count) { i in
                            ItemView(
                                image: Image(uiImage:BodyRender.showRender(skin: 0, body: itemBodys[i])),
                                callBack: {
                                    UserDefaults.standard.set(itemBodys[i], forKey: Keys.selectBody.rawValue)
                                    bodyNo = itemBodys[i]
                                })
                        }
                    } header: {
                        Text(str.body.rawValue)
                    }
                }
            }
        }
    }
}
struct ItemView: View {
    var image: Image
    var callBack: () -> Void
    var width: CGFloat = 40
    var height: CGFloat = 80
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.1))
                .frame(width:width, height: height)
            image
                .resizable()
                .frame(width: width, height: height, alignment: .center)
                .onTapGesture {
                    callBack()
                }
        }
    }
}
