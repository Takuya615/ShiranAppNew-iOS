

import Foundation
enum Keys: String {
    // Key
    
    case firstUseBounus = "getDiamonds"
    
    //RemoteConfig
    case exist_quest = "exist_quest"
    case exist_interval_heart = "exist_interval_heart"
    
    case rcLevel = "edit_level"
    case rcAddTT = "edit_task_time"
    case rcCoinRate = "edit_coin_rate"
    case rcQTime = "edit_quest_time"
    case rcQGoal = "edit_quest_goal"
    case rcQReHeart = "edit_quest_re_heart_interval"//"RemoteConfig_Quest_interval_time_for_recover_heart"    
    //case rcDiaRate = "RemoteConfig_diamond_rate"
    //case rcQMaxHeart = "RemoteConfig_Quest_max_heart"
    
    
    //tutorial
    case CoachMark1 = "CoachMark1"
    case CoachMark2 = "CoachMark2"
    case CoachMark3 = "CoachMark3"
    case CoachMark4 = "CoachMark4"
    case OpenQuest = "OpenQuest"
    case OpenChar = "OpenChar"
    case OpenShop = "OpenShop"
    case CoachMarkf = "CoachMarkf"
    
    case daylyState = "DailyState"
    case totalDay = "totalDay"
    case continuedDay = "cDay"
    case continuedWeek = "wDay"
    case retry = "retry"
    case _LastTimeDay = "LastTimeDay"
    case taskTime = "TaskTime"
    
    case listD = "dateList"
    case listS = "scoreList"
    
    case level = "Level"
    case difficult = "difficultyLevel"
    case scoreMax = "MomentaryMaxScore"
    case exp = "ExperiencePoint"
    case expTT = "ExpForTaskTime"
    case coin = "Coin"
    case diamond = "Diamond"
    case bossNum = "BOSS_ListNumber"
    case myName = "MyName"
    
    //quest
    case questNum = "QuestNumber"
    case questType = "QuestType"
    case qGoal = "QuestGoalScore"
    case qTime = "QuestTime"
    case qsl = "QuestStarsList"
    case updatedStage = "updatedStage"
    case chargTime = "ChargLong"
    case lastOpenedScreen = "LastOpenedScreen"
    
    //skin
    //case boughtSkin = "BoughtSkinNumber"
    case yourItem = "YourItems"
    case selectSkin = "SelectSkin"
    
    //body
    case yourBodys = "YourBodys"
    case selectBody = "SelectBody"
    
}
