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
        showCard()
    }
}

extension ViewController {
    func showCard() {
        lazy var baseView: UIView = {
            let view: UIView = .init()
            let pangestureRecogniser: UIPanGestureRecognizer = .init(target: self, action: #selector(didPan))
            pangestureRecogniser.require(toFail: pangestureRecogniser)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addGestureRecognizer(pangestureRecogniser)
            view.isUserInteractionEnabled = true
            view.backgroundColor = .lightGray
            view.cornerRadius()
            return view
        }()
        
        self.view.addSubview(baseView)
        let padding: CGFloat = 30
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: padding * 2),
            baseView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            baseView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
            baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -padding * 2),
        ])
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self else { return }
                gestureView.center = self.view.center
                gestureView.transform = CGAffineTransform.identity
            }
        }

        let translation = gesture.translation(in: self.view)
        if translation.x == 0, translation.y == 0 { return }
        let translationX: CGFloat = gestureView.center.x + translation.x
        let translationY: CGFloat = gestureView.center.y + translation.y
        gestureView.center = CGPoint(x: translationX, y: translationY)
        
        let swipeDirection = gesture.horizontalDirection(target: self.view)
        
        // Tilt the angle
        var angleDeg: CGFloat = min(translationX / gestureView.bounds.size.width * 90, 5)
        
        if swipeDirection == .Left {
            angleDeg *= -1
        }
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let self else { return }
            let rotate = CGAffineTransform(rotationAngle: angleDeg / 180 * .pi)
            gestureView.transform = rotate
            gesture.setTranslation(CGPoint.zero, in: self.view)
        }
    }
}

extension UIView {
    func cornerRadius(radius: CGFloat = 8.0) {
        self.layer.cornerRadius = radius
    }
}

extension CGFloat {
    func toRadian() -> Self {
        self * .pi / 180
    }
}

extension UIPanGestureRecognizer {

    enum GestureDirection {
        case Up
        case Down
        case Left
        case Right
    }

    /// Get current vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func verticalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .Down : .Up
    }

    /// Get current horizontal direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func horizontalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .Right : .Left
    }

    /// Get a tuple for current horizontal/vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func versus(target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(target: target), self.verticalDirection(target: target))
    }

}
