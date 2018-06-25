//
//  String.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/25/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation
import UIKit

let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,6}"
let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

public extension String {
  /// Checks if the String is a valid email
  func isEmail() -> Bool {
    return emailPredicate.evaluate(with: self)
  }
  
  func height(with maxWidth: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
    return boundingBox.height
  }
  
  func width(with maxHeight: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
    return boundingBox.width
  }
}
