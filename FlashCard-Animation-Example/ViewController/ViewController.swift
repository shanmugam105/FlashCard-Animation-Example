//
//  ViewController.swift
//  FlashCard-Animation-Example
//
//  Created by Sparkout on 05/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    let textLimit: Int = 10
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textField.addDoneButtonOnKeyboard()
        textField.addShowPasswordButton()
    }
    @IBAction func checkOfferTapped(_ sender: Any) {
        let vc: UIViewController = storyboard?.instantiateViewController(withIdentifier: "SpecialOfferViewController") as! SpecialOfferViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let currentText = textView.text.utf8
        let currentTotalCount: Int = currentText.count
        print("Current Total Count", currentTotalCount)
        if currentTotalCount > textLimit {
            var newTextLimit: Int = textLimit
            let allowedTextCollection = currentText.prefix(newTextLimit)
            var allowedText: String = String(decoding: allowedTextCollection, as: UTF8.self)

            if let allowedTextLast = allowedText.last,
               !String(allowedTextLast).isReadableByHuman() {
                let validText = allowedText.dropLast(1)
                newTextLimit = validText.utf8.count
                let allowedTextCollection = currentText.prefix(newTextLimit)
                allowedText = String(decoding: allowedTextCollection, as: UTF8.self)
            }
            
            
            let exeededCount = currentTotalCount - newTextLimit
            let exeededTextCollection: [UInt8] = currentText.suffix(exeededCount)
            let exeededText: String = String(decoding: exeededTextCollection, as: UTF8.self)
            
            let attribute1 = NSMutableAttributedString(string: allowedText)
            let attribute2 = NSMutableAttributedString(string: exeededText, attributes: [.backgroundColor: UIColor.red])
            attribute1.append(attribute2)
            textView.attributedText = attribute1
        }
    }
}

extension String {
    func isReadableByHuman() -> Bool {
        return self.range(of: "\u{FFFD}", options: .literal) == nil
    }
}

extension UITextField {
    func addShowPasswordButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye_close"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: self.frame.size.width - 25.0, y: 5.0, width: 25.0, height: 25.0)
        button.addTarget(self, action: #selector(self.updatePasswordBtn), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
        self.isSecureTextEntry = true
    }
    
    @objc private func updatePasswordBtn(_ sender: UIButton) {
        self.isSecureTextEntry.toggle()
        let icon = UIImage(named: self.isSecureTextEntry ? "eye_close" : "eye_open")
        sender.setImage(icon, for: .normal)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(UITextField.resignFirstResponder)
        )
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        inputAccessoryView = doneToolbar
    }
}
