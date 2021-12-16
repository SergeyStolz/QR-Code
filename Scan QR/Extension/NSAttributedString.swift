//
//  NSAttributedString.swift
//  Scan QR
//
//  Created by mac on 16.12.2021.
//

import UIKit

extension UIViewController {
    
    func getSumLabelAtributedString(_ firstStr: String, _ secondStr: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        let firstAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont(name: "Noteworthy Light", size: 24) as Any,
            .foregroundColor: UIColor.white,
        ]
        let secondAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Noteworthy Light", size: 24)?.bold as Any
        ]
        let attributedFirstString = NSAttributedString(string: firstStr, attributes: firstAttributes)
        let attributedSecondString = NSAttributedString(string: secondStr, attributes: secondAttributes)
        attributedString.append(attributedFirstString)
        attributedString.append(attributedSecondString)
        return attributedString
    }
    
    func getUnderline(_ str: String) -> NSAttributedString {
        let underlineAttriString = NSAttributedString(string: str,
                                                      attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        return underlineAttriString
    }
}
