//
//  ViewController.swift
//  FlashCard-Animation-Example
//
//  Created by Sparkout on 05/05/23.
//

import UIKit

class ViewController: UIViewController, FlashCardViewDelegate {
    
    @IBOutlet weak var flashCardView: FlashCardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        flashCardView.configureCard(delegate: self)
        flashCardView.backgroundColor = .lightGray
    }
    
    func dismissCard(on direction: UIPanGestureRecognizer.GestureDirection) {
        print(#function, direction)
    }
    
    func didCardSwiping(on direction: UIPanGestureRecognizer.GestureDirection) {
        print(#function, direction)
    }
}
