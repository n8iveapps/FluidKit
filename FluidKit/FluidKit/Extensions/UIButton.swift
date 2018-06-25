//
//  UIButton.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/26/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

public extension UIButton {
  ///Image UIButton content mode
  @IBInspectable public var imageViewContentMode:UIViewContentMode {
    get { if let iv = self.imageView { return iv.contentMode } else { return .scaleAspectFit } }
    set { self.imageView?.contentMode = newValue }
  }
  
  /// This method sets an image and title for a UIButton and
  ///   repositions the titlePosition with respect to the button image.
  ///
  /// - Parameters:
  ///   - image: Button image
  ///   - title: Button title
  ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
  ///   - additionalSpacing: Spacing between image and title
  ///   - state: State to apply this behaviour
  @objc public func set(image: UIImage?, title: String, titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
    imageView?.contentMode = .center
    setImage(image, for: state)
    positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
    titleLabel?.contentMode = .center
    setTitle(title, for: state)
  }
  
  /// This method sets an image and an attributed title for a UIButton and
  ///   repositions the titlePosition with respect to the button image.
  ///
  /// - Parameters:
  ///   - image: Button image
  ///   - title: Button attributed title
  ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
  ///   - additionalSpacing: Spacing between image and title
  ///   - state: State to apply this behaviour
  @objc public func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: UIViewContentMode, width spacing: CGFloat, state: UIControlState){
    imageView?.contentMode = .center
    setImage(image, for: state)
    adjust(title: title, at: position, with: spacing)
    titleLabel?.contentMode = .center
    setAttributedTitle(title, for: state)
  }
  
  
  // MARK: Private Methods
  private func adjust(title: NSAttributedString, at position: UIViewContentMode, with spacing: CGFloat) {
    let imageRect: CGRect = self.imageRect(forContentRect: frame)
    let titleSize = title.size()
    arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
  }
  
  private func adjust(title: NSString, at position: UIViewContentMode, with spacing: CGFloat) {
    let imageRect: CGRect = self.imageRect(forContentRect: frame)
    // Use predefined font, otherwise use the default
    let titleFont: UIFont = titleLabel?.font ?? UIFont()
    let titleSize: CGSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont])
    arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
  }
  
  private func positionLabelRespectToImage(title: String, position: UIViewContentMode, spacing: CGFloat) {
    let imageRect: CGRect = self.imageRect(forContentRect: frame)
    // Use predefined font, otherwise use the default
    let titleFont: UIFont = titleLabel?.font ?? UIFont()
    let titleSize: CGSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont])
    arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
  }
  
  private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: UIViewContentMode, withSpacing spacing: CGFloat) {
    var titleInsets: UIEdgeInsets
    var imageInsets: UIEdgeInsets
    switch (position) {
    case .top:
      titleInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
      imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
    case .bottom:
      titleInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
      imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
    case .left:
      titleInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
      imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
    case .right:
      titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
      imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    default:
      titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    titleEdgeInsets = titleInsets
    imageEdgeInsets = imageInsets
  }
  
  
}
