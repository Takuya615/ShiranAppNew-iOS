//
//  Pictgram.swift
//  ShiranAppNew
//
//  Created by 津村拓哉 on 2022/04/10.
//

import SwiftUI

struct Pictogram: View {
    var w: CGFloat
    var h: CGFloat
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let faceImage: String = UserDefaults.standard.decodedObject(Skin.self, forKey: Keys.selectSkin.rawValue)?.image ?? ""
        //        let bounds = UIScreen.main.bounds
        //        let w = bounds.width
        //        let h = bounds.height
        let ps: CGFloat = 20
        let c = ps/2
        let lw: CGFloat = 15
        //        let leftShoulder=CGPoint(x: w*0.71, y: h*0.25)
        //        let rightShoulder=CGPoint(x: w*0.29, y: h*0.25)
        let leftShoulder=CGPoint(x: w*0.75, y: h*0.25)
        let rightShoulder=CGPoint(x: w*0.25, y: h*0.25)
        let leftShoulder2=CGPoint(x: w*0.68, y: h*0.25)
        let rightShoulder2=CGPoint(x: w*0.32, y: h*0.25)
        
        let leftElbow=CGPoint(x: w*0.8, y: h*0.38)
        let rightElbow=CGPoint(x: w*0.2, y: h*0.38)
        let leftWrist=CGPoint(x: w*0.85, y: h*0.51)
        let rightWrist=CGPoint(x: w*0.15, y: h*0.51)
        
        let leftHip=CGPoint(x: w*0.68, y: h*0.55)
        let rightHip=CGPoint(x: w*0.32, y: h*0.55)
        
        let leftKnee=CGPoint(x: w*0.7, y: h*0.7)
        let rightKnee=CGPoint(x: w*0.3, y: h*0.7)
        let leftAnkle=CGPoint(x: w*0.7, y: h*0.9)
        let rightAnkle=CGPoint(x: w*0.3, y: h*0.9)
        
        
        ZStack{
            if !faceImage.isEmpty{
                Image(decorative:faceImage)
                    .resizable()
                    .offset(x: 3, y:-h*0.36)
                    .frame(width: w/3, height: w/3, alignment: .center)
            }
            Path { path in
                path.addEllipse(in:CGRect(
                    x:60, y: -h*0.01,
                    width: w/3, height: w/3))
            }
            .fill(Color.blue)
            
            Path { path in
                path.addEllipse(in:CGRect(
                    x:60, y: -h*0.01,
                    width: w/3, height: w/3))
            }
            .fill(Color.blue)
            let bet = CGPoint(
                x: (leftHip.x+rightHip.x)/2,
                y: (leftHip.y+rightHip.y)/2)
            let lb = CGPoint(
                x: bet.x+20.0,
                y: bet.y)
            let rb = CGPoint(
                x: bet.x-20.0,
                y: bet.y)
            Path { path in
                path.move(to: rightHip)
                path.addLine(to: leftHip)
            }
            .stroke(lineWidth: 40.0)
            .fill(Color.blue)
            
            
            PictoPart(
                size: 20,
                p1: rightShoulder,
                p2: rightElbow,
                p3: rightWrist)
            PictoPart(
                size: 20,
                p1: leftShoulder,
                p2: leftElbow,
                p3: leftWrist)
            PictoPart(
                size: 20,
                p1: rb,
                p2: rightKnee,
                p3: rightAnkle)
            PictoPart(
                size: 20,
                p1: lb,
                p2: leftKnee,
                p3: leftAnkle)
            
        }
    }
}
struct PictoPart: View {
    var size: CGFloat
    var p1: CGPoint
    var p2: CGPoint
    var p3: CGPoint
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        //let size: CGFloat = 40.0
        let mid: CGFloat = size*0.5
        let end: CGFloat = mid*0.5
        let p1a = CGPoint(x: p1.x-mid, y: p1.y)
        let p1b = CGPoint(x: p1.x+mid, y: p1.y)
        let p1c = CGPoint(x: p1.x, y: p1.y-end)
        let p1d = CGPoint(x: p1.x, y: p1.y+end)
        let p2a = CGPoint(x: p2.x-end, y: p2.y)
        let p2b = CGPoint(x: p2.x+end, y: p2.y)
        let p2c = CGPoint(x: p2.x, y: p2.y-end)
        let p2d = CGPoint(x: p2.x, y: p2.y+end)
        //let test = CGPoint(x: 100, y: 200)
        
        ZStack{
            Path { path in
                path.move(to: p2)
                path.addLine(to: p1a)
                path.move(to: p2)
                path.addLine(to: p1b)
                path.move(to: p2)
                path.addLine(to: p1c)
                path.move(to: p2)
                path.addLine(to: p1d)
                //path.addLines([test,p1a,p1b,test])
                path.addEllipse(in:CGRect(
                    x:p1.x-size/2, y: p1.y-size/2,
                    width: size, height: size))
                
            }
            .stroke(lineWidth: size)
            .fill(Color.blue)
            //.frame(width: w, height: h)
            
            Path { path in
                path.move(to: p3)
                path.addLine(to: p2a)
                path.move(to: p3)
                path.addLine(to: p2b)
                path.move(to: p3)
                path.addLine(to: p2c)
                path.move(to: p3)
                path.addLine(to: p2d)
                //path.addLines([p2a,p3,p2b])
                path.addEllipse(in:CGRect(
                    x:p2.x-mid/2, y: p2.y-mid/2,
                    width: mid, height: mid))
            }
            .stroke(lineWidth: mid)
            .fill(Color.blue)
            //.frame(width: w, height: h)
            
            Path { path in
                path.addEllipse(in:CGRect(
                    x:p3.x-end/2, y: p3.y-end/2,
                    width: end, height: end))
            }
            .stroke(lineWidth: end)
            .fill(Color.blue)
            //.frame(width: w, height: h)
        }
        
        
        
    }
}


struct Pictogram_Previews: PreviewProvider {
    @EnvironmentObject var dataCounter: DataCounter
    static var previews: some View {
//        PictoPart(
//            size: 60.0,
//            p1: CGPoint(x: 100, y: 100),
//            p2: CGPoint(x: 300, y: 250),
//            p3: CGPoint(x: 200, y: 400)
//        )
                let bounds = UIScreen.main.bounds
                let w = bounds.width
                let h = bounds.height
                Pictogram(w:w/2,h: h/2)
                    .frame(width: w/2, height: h/2, alignment: .center)
    }
}
