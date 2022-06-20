
import SwiftUI

struct fabView: View {
    @EnvironmentObject var appState: AppState
    //@EnvironmentObject var dataCounter: DataCounter
    @State var dialogPresentation = DialogPresentation()
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action:{
                    self.appState.isVideo = true
                    self.appState.coachMark1 = true
                    UserDefaults.standard.set(true, forKey: "CoachMark1")
                }, label: {
                    Image(systemName: "flame")//"video.fill.badge.plus")
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                })
                    .frame(width: 60, height: 60, alignment: .center)
                    .background(Color.orange)
                    .cornerRadius(30.0)
                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10.0, trailing: 16.0))
                    .onAppear(perform: {
                        if self.appState.coachMark1 && !self.appState.coachMark3 {
                            dialogPresentation.show(content: .contentDetail1(isPresented: $dialogPresentation.isPresented))
                        }
                        if self.appState.coachMark3 && !self.appState.coachMark4{
                            dialogPresentation.show(content: .contentDetail2(isPresented: $dialogPresentation.isPresented))
                        }
                    })
                /*.fullScreenCover(isPresented: self.$isVideo, content: {
                 VideoCameraView2(isVideo: $isVideo)
                 })*/
            }.customDialog(presentaionManager: dialogPresentation)
        }
    }
}
