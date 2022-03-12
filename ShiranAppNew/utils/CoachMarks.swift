//
//  CoachMarks.swift
//  ShiranApp
//
//  Created by user on 2021/08/27.
//

import Foundation
import SwiftUI
import Instructions

struct CoachMarkView: UIViewControllerRepresentable {
    @EnvironmentObject var appState: AppState
    func makeUIViewController(context: Context) -> UIViewController {
        return cmViewController(coachMarkView: self)
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}


class cmViewController: UIViewController, CoachMarksControllerDataSource {
    
    var coachController = CoachMarksController()
    // コーチマークを表示したいUIView
    var firstButton: UIButton!
    var secondButton: UIButton!
    var thirdButton: UIButton!
    private var messages: [String]!
    private var views: [UIButton]!
    private var rect: CGRect!
    private var cmNumber: String = ""
    
    var coachMarkView: CoachMarkView
    init(coachMarkView: CoachMarkView){
        self.coachMarkView = coachMarkView
        super.init(nibName: nil, bundle: nil)
        self.rect = self.view.bounds
        self.setOne()
        //if !self.coachMarkView.appState.coachMark3{}
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coachController.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.coachController.start(in: .window(over: self))//.currentWindow(of: self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.coachController.stop(immediately: true)
        self.coachMarkView.appState.coachMarkf = false
        //UserDefaults.standard.set(true, forKey: cmNumber)//CoachMark
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
                coachViews.bodyView.hintLabel.text = self.messages[index] // ここで文章を設定
        coachViews.bodyView.nextLabel.text = str.ok.rawValue // 「次へ」などの文章

                return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1//self.messages.count
    }
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        //self.coachController.overlay.backgroundColor = UIColor.init(.blue)//(white: 000000, alpha: 0.3)
        return self.coachController.helper.makeCoachMark(for: self.views[index], pointOfInterest: nil, cutoutPathMaker: nil)
                // for: にUIViewを指定すれば、マークがそのViewに対応します
    }
    
    func setOne(){
        messages = [str.tap.rawValue]
        self.firstButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        self.firstButton.layer.cornerRadius = 30.0
        let bf = self.firstButton.frame
        self.firstButton.layer.position = CGPoint(x: rect.width - bf.width/2 - 16, y: rect.height - bf.height/2 - 55)
        views = [firstButton]
        //cmNumber = "CoachMark1"
        //self.coachMarkView.appState.coachMark1 = true
    }
}
