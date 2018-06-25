//
//  FKLabel.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/26/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

@IBDesignable
open class FKLabel: UILabel {
  
  @IBInspectable public var leftTextInset: CGFloat {
    set { textInsets.left = newValue }
    get { return textInsets.left }
  }
  
  @IBInspectable public var rightTextInset: CGFloat {
    set { textInsets.right = newValue }
    get { return textInsets.right }
  }
  
  var textInsets = UIEdgeInsets.zero {
    didSet { invalidateIntrinsicContentSize() }
  }
  
  override open func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
    let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
    let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
    return UIEdgeInsetsInsetRect(textRect, invertedInsets)
  }
  
  override open func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
  }
}

