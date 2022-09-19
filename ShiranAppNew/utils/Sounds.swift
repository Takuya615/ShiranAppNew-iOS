
//import Foundation
import AudioToolbox


class SystemSounds{
    
    static func beginVideoRecording(){
        var soundIdRing:SystemSoundID = 1117
        if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    
    //タイプライター　達成BGM
    static func typeWriter(){AudioServicesPlaySystemSound(1035)}
    //ビート
    static func beat(){ AudioServicesPlaySystemSound(1057)}
    //こうか（ミッション失敗）
    static func fallDown(){AudioServicesPlaySystemSound(1024)}
    // バイブレータ
    static func buttonVib() {AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))}
    
    // mp3 ファイルの再生
    //@IBAction
    static func buttonSampleWav() {
        var soundIdRing:SystemSoundID = 0
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "cheers", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    
    static func countDown() {
        var soundIdRing:SystemSoundID = 1
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "countdown", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    static func score_up(){
        var soundIdRing:SystemSoundID = 2
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "score_up", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    
    static func attack(){
        var soundIdRing:SystemSoundID = 3
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "attack", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    static func success(){
        var soundIdRing:SystemSoundID = 4
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "success", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    static func failure(){
        var soundIdRing:SystemSoundID = 5
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "failure", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    static func subjugation(){//討伐音
        var soundIdRing:SystemSoundID = 6
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "subjugation", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    static func warning(){
        var soundIdRing:SystemSoundID = 7
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "warning", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    static func bpm120(){
        var soundIdRing:SystemSoundID = 8
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "bpm120", ofType:"wav")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
}
