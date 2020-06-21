//
//  StoreVC.swift
//  Foods 
//
//  Created by bennoui ihab on 5/14/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit

class StoreVC: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource{
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        IAPServices.instaces.delegate = self
        IAPServices.instaces.loadProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
        
    }
    
    @IBAction func restorePurchases(_ sender: Any) {
        let alertVC = UIAlertController(title: "Restore Purchase", message: "Do you want to restore any in-app purchases you've previously purchased ?", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Restore", style: .default) { (action) in
            IAPServices.instaces.restorePurchases()
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertVC.addAction(action)
        alertVC.addAction(CancelAction)
        
        present(alertVC, animated: true , completion:  nil)
    }
    

    @objc func showAlert(){
        let alert = UIAlertController(title: "SUCCESS", message: "Your Purchase was successfully restored", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert , animated:  true , completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FoodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell else {return UICollectionViewCell() }
        let item = FoodItems[indexPath.row]
        cell.configureCell(item: item)
        return cell 
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailVC  else { return }
        let item = FoodItems[indexPath.row]
        detailVC.intiData(ForItem: item) 
        present(detailVC, animated: true ,completion:  nil)
    }
}
 
extension StoreVC : IAPServiceDelegate {
    func iapProductsLoaded(){
        print("IAP PRODUCTS LOADED!")
    }
}
