

import SwiftUI

struct BackKeyView: View {
    var callBack: ()->Void
    var body: some View {
        VStack {
            HStack{
                Button(action: {callBack()},
                       label: {Text(str.back.rawValue).font(.system(size: 20))
                }).padding()
                Spacer()
            }
            
        }
    }
}
