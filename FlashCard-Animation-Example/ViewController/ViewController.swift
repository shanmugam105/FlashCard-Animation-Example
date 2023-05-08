//
//  ViewController.swift
//  FlashCard-Animation-Example
//
//  Created by Sparkout on 05/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func checkOfferTapped(_ sender: Any) {
        let vc: UIViewController = storyboard?.instantiateViewController(withIdentifier: "SpecialOfferViewController") as! SpecialOfferViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
    }
}
