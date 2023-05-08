//
//  FlashCard.swift
//  FlashCard-Animation-Example
//
//  Created by Sparkout on 08/05/23.
//

import UIKit

public protocol FlashCardViewDelegate where Self: UIViewController {
    func didCardTapped()
    func dismissCard(on direction: UIPanGestureRecognizer.GestureDirection)
    func didCardSwiping(on direction: UIPanGestureRecognizer.GestureDirection)
}

extension FlashCardViewDelegate {
    func didCardTapped(){}
    func didCardSwiping(on direction: UIPanGestureRecognizer.GestureDirection){}
}

public class FlashCardView: UIView {
    private var screenSize: CGSize = UIScreen.main.bounds.size
    private weak var delegate: FlashCardViewDelegate?
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pangestureRecogniser: UIPanGestureRecognizer = .init(target: self, action: #selector(didPan))
        pangestureRecogniser.require(toFail: pangestureRecogniser)
        return pangestureRecogniser
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapgestureRecogniser: UITapGestureRecognizer = .init(target: self, action: #selector(didTapped))
        tapgestureRecogniser.numberOfTapsRequired = 1
        return tapgestureRecogniser
    }()
    
    public func configureCard(delegate: FlashCardViewDelegate?) {
        self.delegate = delegate
        self.layer.masksToBounds = true
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.didCardTapped()
    }
    
    @objc private func didPan(_ gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view, let delegate else { return }
        let swipeDirection = gesture.horizontalDirection(target: delegate.view)
        if gesture.state == .ended {
            let padding: CGFloat = 40
            if swipeDirection == .Left || swipeDirection == .Right {
                let leadingPadding: CGFloat = padding
                let trailingPadding: CGFloat = screenSize.width - padding
                if gestureView.center.x < leadingPadding || gestureView.center.x > trailingPadding {
                    delegate.dismissCard(on: swipeDirection)
                    return
                }
            } else if swipeDirection == .Up || swipeDirection == .Down {
                let topPadding: CGFloat = padding
                let bottomPadding: CGFloat = screenSize.height - padding
                if gestureView.center.y < topPadding || gestureView.center.y > bottomPadding {
                    delegate.dismissCard(on: swipeDirection)
                    return
                }
            }
            UIView.animate(withDuration: 0.2) {
                gestureView.center = delegate.view.center
                gestureView.transform = CGAffineTransform.identity
            }
            return
        }
        delegate.didCardSwiping(on: swipeDirection)
        let translation = gesture.translation(in: delegate.view)
        if translation.x == 0, translation.y == 0 { return }
        let translationX: CGFloat = gestureView.center.x + translation.x
        let translationY: CGFloat = gestureView.center.y + translation.y
        gestureView.center = CGPoint(x: translationX, y: translationY)
        // Tilt the angle
        var angleDeg: CGFloat = min(abs(translationX) / gestureView.bounds.size.width * 90, 5)
        if swipeDirection == .Left, translationX < delegate.view.center.x {
            angleDeg *= -1
        } else if swipeDirection == .Right, translationX > delegate.view.center.x {
            angleDeg *= 1
        } else {
            angleDeg = 0
        }
        UIView.animate(withDuration: 0.2) {
            let rotate = CGAffineTransform(rotationAngle: angleDeg / 180 * .pi)
            gestureView.transform = rotate
            gesture.setTranslation(CGPoint.zero, in: delegate.view)
        }
    }
}


extension UIPanGestureRecognizer {

    public enum GestureDirection {
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
