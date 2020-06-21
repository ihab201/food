//
//  IAPServices .swift
//  Foods
//
//  Created by bennoui ihab on 5/25/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import Foundation
import StoreKit

protocol IAPServiceDelegate {
    func iapProductsLoaded()
}

class IAPServices :NSObject, SKProductsRequestDelegate {
    
    static let instaces = IAPServices()
    
    var delegate : IAPServiceDelegate?
    
    //Variables : 
    var products = [SKProduct]()
    var productsIds = Set<String>()
    var productRequest = SKProductsRequest()
    var nonConsumablePurchaseWasMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func loadProducts(){
        ProductsIdsToStringSet()
        requestProducts(forIDs: productsIds)
    }
    
    func ProductsIdsToStringSet(){
        let ids = [IAP_HIDE_ADS_ID , IAP_MEAL_ID]
        
        for id in ids {
            productsIds.insert(id)
        }
         
    }
    
    func requestProducts(forIDs ids: Set<String>){
        productRequest.cancel()
        productRequest = SKProductsRequest(productIdentifiers: ids)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        if products.count == 0 {
            requestProducts(forIDs: productsIds)
        }else {
            
        }
         delegate?.iapProductsLoaded()
      }
    
    func attemptPurchasesForItemWith(productIndex : Product){
        let product = products[productIndex.rawValue]
        let payment = SKPayment(product : product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPServices: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased :
                SKPaymentQueue.default().finishTransaction(transaction)
                complete(transaction: transaction)
                sendNotificationFor(status: .purchased, withIdentifier: transaction.payment.productIdentifier)
                debugPrint("purchased was successful!")
                break
            case .failed :
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotificationFor(status: .failed, withIdentifier: nil)
                break
            case .deferred :
                break
            case .restored :
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .purchasing :
                break
            @unknown default: break
                
            }
        }
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        sendNotificationFor(status: .restored, withIdentifier: nil)
        setNonConsumablePurchase(true)
    }
    
    func complete(transaction : SKPaymentTransaction){
        switch transaction.payment.productIdentifier {
        case IAP_MEAL_ID:
            break
        case IAP_HIDE_ADS_ID :
            setNonConsumablePurchase(true)
            break
        default: break
        }
    }
    func setNonConsumablePurchase(_ status : Bool){
        UserDefaults.standard.set(status, forKey: "nonConsumablePurchaseWasMade")
    }
    
    func sendNotificationFor(status : PurchaseStatus , withIdentifier identifier : String?){
        switch status {
        case .purchased:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServicePurchaseNotification), object: identifier)
            break
        case .restored :
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
            break
        case .failed :
            NotificationCenter.default.post(name:NSNotification.Name(IAPServiceFailureNotification), object: nil)
            break

        }
    }
     
}
