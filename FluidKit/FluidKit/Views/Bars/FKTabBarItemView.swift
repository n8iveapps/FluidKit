//
//  FKTabBarItemView.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

open class FKTabBarItemView: UICollectionViewCell {
  
  let imageView = UIImageView(frame: CGRect.zero)
  let titleLabel = UILabel(frame: CGRect.zero)
  let badgeView = UILabel(frame: CGRect.zero)
  var showsEmptyBadge = false
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.initUI()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.initUI()
  }
  
  open func initUI() {
    self.backgroundColor = .clear
    self.titleLabel.text = ""
    self.titleLabel.textAlignment = .center
    self.titleLabel.font = UIFont.systemFont(ofSize: 10)
    self.badgeView.text = ""
    self.badgeView.textAlignment = .center
    self.badgeView.font = UIFont.systemFont(ofSize: 10)
    self.imageView.contentMode = .center
    self.addSubview(self.imageView)
    self.addSubview(self.titleLabel)
    self.addSubview(self.badgeView)
  }
  
  open override func layoutSubviews() {
    self.titleLabel.frame = CGRect(x: 5, y: (self.bounds.height - 20), width: (self.bounds.width - 10), height: 16)
    if self.titleLabel.text == "" {
      self.imageView.frame = CGRect(x: 5, y: 10, width: (self.bounds.width - 10), height: (self.bounds.height - 20))
    }
    else {
      self.imageView.frame = CGRect(x: 5, y: 5, width: (self.bounds.width - 10), height: (self.bounds.height - 25))
    }
    if self.badgeView.text == "" {
      self.badgeView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    else {
      self.badgeView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    self.badgeView.layer.cornerRadius = self.badgeView.frame.height / 2
  }
}
