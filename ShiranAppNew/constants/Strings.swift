//
//  Strings.swift
//  ShiranAppNew
//
//  Created by user on 2022/02/19.
//

//import Foundation

enum str: String {
    case home = "ホーム"
    case quest = "クエスト"
    case suketto = "スケット"
    case shop = "ショップ"
    case count_retry = "リトライ数"
    case count_continue = "継続日数"
    case set = "設定"
    case detailApp = "アプリ詳細"
    case privacy_policy = "プライバシーポリシー"
    case twitter = "ツイッター"
    case opinion = "ご意見"
    case reset = "リセット"
    case oneDayReset = "１日リセット"


    case coachMarck2text = "カベに立てかけ、\n↓のSTARTをタップ\n（初回は時間が5秒だけです)"
    case back = "< Back"
    case ok = "OK"
    case tap = "タップ"
    case score = "Score"
    case start = "START"
    case rest = "  きゅうけい"
    case score2 = "スコア"
    
    case questViewText1 = "あと⭐️"
    case questViewText2 = "コでステージ解放"
    case stage = "ステージ"
    case tryChallenge = "チャレンジしますか？"
    case quite = "やめる"
    case challenge = "チャレンジ"
    
    case characterViewText1 = "レベル"
    case characterViewText2 = "で解放"

    case doYouBuyIt = "このアイテムを購入しますか？？"
    case purchase = "購入"
    case noManey = "お金が足りません..."
    case modoru = "もどる"
    
    case normal = "ノーマル"
    case hard = "ハード"
    case veryHard = "ベリーハード"
    case settingDifficulty = "\nデイリーの難易度を設定します\n"
    case selectDifficulty = "難易度を選択"

    case userOpinion1 = "※このメッセージは個人を特定できるものではありません。そのため、返信も致しかねます。"
    case userOpinion2 = "\n✉️ ご意見・ご感想"
    case userOpinion3 = "「もっとこうして欲しい」「こうなったら嬉しい」といった、みなさまのご要望をお聞かせください。\n"
    case sendMail = "送信"
    case userOpinionError = "エラー：通信環境をお確かめのうえ、もう一度お願いします。"
    case messageTo = "運営"
    case messageFrom = "ユーザー"
    case messageTitle = "クライアント　フィードバック"
    
    case mailAdress = "メールアドレス"
    case password = "パスワード"
    case noInput = "メールもしくはパスワードが未入力です"
    case makeNewAccount = "新規アカウント作成"
    case login = "ログイン"
    case selectName = "ニックネームを決めてください"
    case fixName = "名前を入力してください"
    case sendMailError = "不明なエラー\n通信環境の良いところで、もう１度お試しください"
    case sameNameError = "同じ名前を使っているユーザーがみつかりました\n別の名前に変更してください"
    case select = "決定"
    
    case close = "❎閉じる"
    case forword = "\nまえへ\n"
    case next = "\nつぎへ\n"
    case daylyChallenge = "デイリーチャレンジ"
    case dialog1_1_1 = "毎日、その日の"
    case dialog1_1_2 = "はじめの１回だけ"
    case dialog1_1_3 = "モンスターがあらわれます"
    case dialog1_2_1 = "\n彼らはあなたの"
    case dialog1_2_2 = "なまけ心の化身です"
    case dialog1_2_3 = "今すぐ撃退しましょう！！\n"
    case dialog2_1_1 = "\nデイリーのほか、クエスト（ミニゲーム）で遊ぶこともできます。\n"
    case dialog2_1_2 = "\n↓ の「クエスト」をタップ\n"
    case dialog2_2_1 = "難易度の調整"
    case dialog2_2_2 = "\nバーピーはカンタンすぎる？\n右上のメニューボタン→設定で難易度を変えることもできます。"
    case dialog2_3_1 = "おめでとう！！"
    case dialog2_3_2 = "\n今日のあなたは、\nじぶんの怠惰を克服しました！\n\n短い時間でも毎日こなして、まずは「毎日する」という意識をクセにしましょう"
    
    case dialogBossText = "STARTすると、下にテキHPがでます\n０になるまで運動しましょう"
    
    
    case modeNormal = "　\n　ノーマルモード\n　好きな運動してください。AIが体の動きから自動でスコアを計算してくれます。\n自分で自由に行えるという点が、このモードのいいところです。"
    case modeHard = "　\n　ハードモード\n　バーピージャンプでスコアをかせげるモードです。このアプリ本来の難易度です。\nスコアがノーマルモードの２倍になります。"
    case modeVeryHard = "　\n　ベリーハードモード\n　かかえこみバーピージャンプに挑戦するモードです。ハードモードより高く跳ばなければ得点になりません。\nスコアがノーマルモードの３倍です。\n普段からトレーニングをされており、デイリーの制限時間を早く伸ばしたいという方にお勧めです。"
    
    case expTitle1 = "あそびかた"
    case expTitle2 = "アプリの流れ"
    case expTitle3 = "HIITってなに？？"
    case expTitle4 = "HIITのメリット"
    case expTitle5 = "なぜ半年？？"

    case exp1 = """
    これは半年で４分間のHIITを
    習慣にするためのアプリです。
    
    """
    case exp2 =
    """
    
    毎日、運動した記録をつけるだけ
    """
    case exp2_2 =
    """
        
        初日はたったの５秒からスタート。
        
        ５秒　６秒　７秒　・・・　２４０秒
        
        いつの間にか４分間のHIITができるようにまで、成長しています。
        
        """
    case exp3 =
    """
        
        ハイ インテンシティ インターバル トレーニングの略で、
        
        　　　20秒　ハードな運動
        　　　　　　　↓
        　　　10秒　休む
        　　　　　　　↓
        　　　20秒　ハードな運動
        　　　　　　　↓
        　　　10秒　休む
        を繰り返す方法のことです。
        
        1分 HIITは、45分 ランニングに匹敵する身体機能アップ効果が確認されています。
        近年、もっとも効率の良い運動として注目を浴びています。
        
        """
    
    case exp4 =
    """

        以下のような効果が科学的に確認されています。
        ①　ダイエット効果が高い！
        ②　空腹感がやわらぐ！
        ③　寿命が伸びる！
        ④　若返る！
        ⑤　疲れにくい体になる！
        ⑥　鬱や不安症にも効く！
        ⑦　心肺機能が向上！
        ⑧　基礎代謝が上がる！



        """
    case exp5 =
    """

        習慣は日を重ねれば重ねるほど強固になります。
        これまで運動を全くしてこなかった人でも、より確実に身につけられるよう半年間としています。

        ロンドン大学の研究によると、運動のような負担の大きなタスクを習慣にするには時間がかかり、最大254日（８ヶ月強）かかる人もいたそうです。

        焦りは禁物
        """
    
}
