//
//  Sounds.swift
//  ShiranApp
//
//  Created by user on 2021/08/04.
//

import Foundation
import AudioToolbox


class SystemSounds{
    
    static func BeginVideoRecording(){
        var soundIdRing:SystemSoundID = 1117//1118
        if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                    AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                    AudioServicesPlaySystemSound(soundIdRing)
                }
    }
    
    // バイブレータ
    static func buttonVib(_ sender : Any) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    // mp3 ファイルの再生
    //@IBAction
    static func buttonSampleWav(_ sender : Any) {
        var soundIdRing:SystemSoundID = 0
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
            Bundle.main.path(forResource: "cheers", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    
    static func countDown(_ sender : Any) {
        var soundIdRing:SystemSoundID = 1
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
            Bundle.main.path(forResource: "countdown", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    static func score_up(_ sender : Any) {
        var soundIdRing:SystemSoundID = 2
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
            Bundle.main.path(forResource: "score_up", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    
    static func attack(_ sender : Any) {
        var soundIdRing:SystemSoundID = 3
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
            Bundle.main.path(forResource: "attack", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
}
