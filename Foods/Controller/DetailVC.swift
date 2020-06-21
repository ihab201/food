//
//  DetailVC.swift
//  Foods
//
//  Created by bennoui ihab on 5/19/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var ItemImageView : UIImageView!
    @IBOutlet weak var ItemNameLbl : UILabel!
    @IBOutlet weak var ItemPriceLbl : UILabel!
    @IBOutlet weak var ADView : UIView!
    @IBOutlet weak var BuyItemBtn : UIButton!
    @IBOutlet weak var hideAdsBtn : UIButton!

    public private(set) var item : Item!
    private(set) var hiddenStatus : Bool = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    
   func intiData(ForItem item : Item) {
    self.item = item 
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ItemImageView.image = item.image
        ItemNameLbl.text = item.name
        ItemPriceLbl.text = String(describing: item.price)
        BuyItemBtn.setTitle("BUY the Item for $\(item.price)", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchased(_:)), name: NSNotification.Name(IAPServicePurchaseNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailure), name: NSNotification.Name(IAPServiceFailureNotification), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ADView.isHidden = hiddenStatus
        hideAdsBtn.isHidden = hiddenStatus
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handlePurchased(_ notification : Notification){
        guard let productID = notification.object as? String else { return }
        
        switch productID {
        case IAP_MEAL_ID:
            BuyItemBtn.isEnabled = true
            debugPrint("Meal succeffuly Purshased.")
            break
        case IAP_HIDE_ADS_ID :
            ADView.isHidden = true
            hideAdsBtn.isHidden = true 
            debugPrint("ads hidee success!")
            break
        default: break
        }
        
    }
    
    @objc func handleFailure(){
        BuyItemBtn.isEnabled = true
        debugPrint("purshase Failed.")
    }
    
    @IBAction func BuyBtnWasPressed(_ sender: Any) {
        BuyItemBtn.isEnabled = false
        IAPServices.instaces.attemptPurchasesForItemWith(productIndex: .meal)
    }
    
    @IBAction func HideAdsBtnWasPressed(_ sender: Any) {
        IAPServices.instaces.attemptPurchasesForItemWith(productIndex: .hideAds)
    }
    
    @IBAction func CloseBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil) 
    }
    
    
    
}
