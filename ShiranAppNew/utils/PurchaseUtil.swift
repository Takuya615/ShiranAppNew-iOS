

import StoreKit
import SwiftyStoreKit

enum RegisteredPurchase: String {
    case coin500
    case coin2500
    case coin5000
    case coin10000
    case diamond10
    case diamond50
    case diamond100
    
}
struct CoinPurchace: Identifiable,Codable {
    var id = UUID()
    var coin: Int
    var enn: Int
    var product: String
    
    static var coins: [CoinPurchace] = [
        CoinPurchace(coin: 500, enn: 120, product: RegisteredPurchase.coin500.rawValue),
        CoinPurchace(coin: 2500, enn: 610  , product: RegisteredPurchase.coin2500.rawValue),
        CoinPurchace(coin: 5000, enn: 1220 , product: RegisteredPurchase.coin5000.rawValue),
        CoinPurchace(coin: 10000, enn: 2440, product: RegisteredPurchase.coin10000.rawValue)
    ]
}
struct DiaPurchace: Identifiable,Codable {
    var id = UUID()
    var coin: Int
    var enn: Int
    var product: String
    
    static var dia: [DiaPurchace] = [
        DiaPurchace(coin: 10, enn: 250  ,product: RegisteredPurchase.diamond10.rawValue),
        DiaPurchace(coin: 50, enn: 980 ,product: RegisteredPurchase.diamond50.rawValue),
        DiaPurchace(coin: 100, enn: 1840,product: RegisteredPurchase.diamond100.rawValue)
    ]
}

class PurchaseUtil {
    let appBundleId = "com.Takuya.Tsumura.ShiranAppNew.consumable"
    func getInfo(_ purchase: String) {
        SwiftyStoreKit.retrieveProductsInfo([appBundleId + "." + purchase]) { result in
            if result.retrievedProducts.first != nil {
                let products = result.retrievedProducts.sorted { (firstProduct, secondProduct) -> Bool in
                    return firstProduct.price.doubleValue < secondProduct.price.doubleValue
                }
                for product in products {
                    print(product)
                }
            } else if result.invalidProductIDs.first != nil {
                print(result.invalidProductIDs)
            } else {
                print(result.error.debugDescription)
            }
        }
    }
    
    
    func purchase(_ purchase: String,callBack: @escaping () -> Void,callError: @escaping () -> Void){
        SwiftyStoreKit.purchaseProduct(appBundleId + "." + purchase, atomically: false) { result in
            if case .success(let purchase) = result {
                callBack()
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if case .error(let error) = result {
                print((error as NSError).localizedDescription)
                callError()
            }
        }
    }
    
    @IBAction func restorePurchases(_ sender: Any?) {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            
            for purchase in results.restoredPurchases where purchase.needsFinishTransaction {
                // Deliver content from server, then:
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
            
            //self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    //
    //    @IBAction func verifyReceipt(_ sender: Any?) {
    //
    //        verifyReceipt(completion: { result in
    //            //self.showAlert(self.alertForVerifyReceipt(result))
    //        })
    //    }
    //
    //    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
    //
    //        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
    //        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    //    }
    //
    //    func verifyPurchase(_ purchase: RegisteredPurchase) {
    //
    //        verifyReceipt { result in
    //
    //            switch result {
    //            case .success(let receipt):
    //
    //                let productId = self.appBundleId + "." + purchase.rawValue
    //
    //                switch purchase {
    //                case .autoRenewablePurchase:
    //                    let purchaseResult = SwiftyStoreKit.verifySubscription(
    //                        ofType: .autoRenewable,
    //                        productId: productId,
    //                        inReceipt: receipt)
    //                    //self.showAlert(self.alertForVerifySubscription(purchaseResult))
    //                case .nonRenewingPurchase:
    //                    let purchaseResult = SwiftyStoreKit.verifySubscription(
    //                        ofType: .nonRenewing(validDuration: 60),
    //                        productId: productId,
    //                        inReceipt: receipt)
    //                    //self.showAlert(self.alertForVerifySubscription(purchaseResult))
    //                default:
    //                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
    //                        productId: productId,
    //                        inReceipt: receipt)
    //                    //self.showAlert(self.alertForVerifyPurchase(purchaseResult))
    //                }
    //
    //            case .error:
    //                //self.showAlert(self.alertForVerifyReceipt(result))
    //            }
    //        }
    //    }
}
