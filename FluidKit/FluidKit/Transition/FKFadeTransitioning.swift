//
//  FKFadeTransitioning.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

open class FKFadeTransitioning:NSObject, UIViewControllerAnimatedTransitioning {
  
  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.4
  }
  
  open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toView = transitionContext.view(forKey: .to) else {
      return
    }
    let containerView = transitionContext.containerView
    toView.alpha = 0
    containerView.addSubview(toView)
    UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
      toView.alpha = 1
    }) { finished in
      transitionContext.completeTransition(finished)
    }
  }
}
