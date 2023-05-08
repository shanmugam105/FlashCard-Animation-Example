//
//  SpecialOfferViewController.swift
//  FlashCard-Animation-Example
//
//  Created by Sparkout on 08/05/23.
//

import UIKit


class SpecialOfferViewController: UIViewController {
    @IBOutlet weak var flashCardView: FlashCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashCardView.configureCard(delegate: self)
    }
}

extension SpecialOfferViewController: FlashCardViewDelegate {
    func dismissCard(on direction: UIPanGestureRecognizer.GestureDirection) {
        self.dismiss(animated: true)
    }
    
    func didCardSwiping(on direction: UIPanGestureRecognizer.GestureDirection) {
        print(direction)
    }
    
    func didCardTapped() {
        print("Tapped")
    }
}
