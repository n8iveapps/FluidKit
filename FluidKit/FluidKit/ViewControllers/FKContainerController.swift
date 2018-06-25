//
//  FKContainerController.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

open class FKContainerController: UIViewController {
  
  
  /// The view controllers currently managed by the container view controller.
  open var viewControllers:[UIViewController] = []
  
  /// The gesture recognizer responsible for changing view controllers. (read-only)
  open private(set) var interactiveTransitionGestureRecognizer:UIGestureRecognizer?
  
  /// The view enclosing all child views
  public var contentView:UIView = UIView(frame: .zero)
  
  /// This maps safeAreaInsets for iOS9+
  public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.contentView)
  }
  
  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  open override func viewSafeAreaInsetsDidChange() {
    self.recalculateInsets()
    self.layoutSubviews()
  }
  
  
  open override func viewWillLayoutSubviews() {
    self.layoutSubviews()
  }
  
  open func layoutSubviews() {
    self.contentView.frame = CGRect(x: self.contentInsets.left, y: self.contentInsets.top, width: (self.view.bounds.width - (self.contentInsets.left + self.contentInsets.right)), height: (self.view.bounds.height - (self.contentInsets.top + self.contentInsets.bottom)))
  }
  
  private func recalculateInsets() {
    if #available(iOS 11.0, *) {
      //self.contentInsets = UIEdgeInsets(top: max(self.contentInsets.top, self.view.safeAreaInsets.top), left: max(self.contentInsets.left, self.view.safeAreaInsets.left), bottom: max(self.contentInsets.bottom, self.view.safeAreaInsets.bottom), right: max(self.contentInsets.right, self.view.safeAreaInsets.right))
      self.contentInsets = self.view.safeAreaInsets
    }
  }
  
  /// Override to initialize your own animator
  open func transitionAnimator(from currentViewController:UIViewController, to nextViewController:UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return nil
  }
  
  /// Override to initialize your own interaction controller
  open func interactionController(animator:UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return nil
  }
  
  
  
  open func transition(from currentViewController:UIViewController?, to nextViewController:UIViewController, completion:((_ completed: Bool) -> ())?) {
    
    let toView = nextViewController.view
    toView?.translatesAutoresizingMaskIntoConstraints = true
    toView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    toView?.frame = self.contentView.bounds
    
    guard let fromViewController = currentViewController else {
      self.contentView.addSubview(toView!)
      self.addChildViewController(nextViewController)
      nextViewController.didMove(toParentViewController: self)
      completion?(true)
      return
    }
    
    guard let animator = self.transitionAnimator(from: fromViewController, to: nextViewController) else {
      // No animator implemented
      self.contentView.addSubview(toView!)
      self.addChildViewController(nextViewController)
      nextViewController.didMove(toParentViewController: self)
      completion?(true)
      return
    }
    
    let context = FKViewControllerContextTransitioning(fromViewController: fromViewController, toViewController: nextViewController)
    context.isAnimated = true
    context.completionBlock = { didComplete in
      if didComplete {
        fromViewController.view.removeFromSuperview()
        fromViewController.willMove(toParentViewController: nil)
        self.addChildViewController(nextViewController)
      } else {
        toView?.removeFromSuperview()
      }
      completion?(didComplete)
      animator.animationEnded?(didComplete)
    }
    
    guard let interactionController = self.interactionController(animator: animator) else {
      animator.animateTransition(using: context)
      return
    }
    
    context.isInteractive = true
    interactionController.startInteractiveTransition(context)
    
  }
}

