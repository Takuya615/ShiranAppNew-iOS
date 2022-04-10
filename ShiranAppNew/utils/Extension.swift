
import Foundation
//SkinClassを丸ごと保存・とりだしができる
extension UserDefaults {
  func setEncoded<T: Encodable>(_ value: T, forKey key: String) {
    guard let data = try? JSONEncoder().encode(value) else {
       print("Can not Encode to JSON.")
       return
    }
    set(data, forKey: key)
  }
  
  func decodedObject<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
    guard let data = data(forKey: key) else {
      return nil
    }
    return try? JSONDecoder().decode(type, from: data)
  }
}
