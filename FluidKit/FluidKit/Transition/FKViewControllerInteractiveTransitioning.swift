//
//  FKViewControllerInteractiveTransitioning.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/4/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

open class FKViewControllerInteractiveTransitioning: NSObject, UIViewControllerInteractiveTransitioning {
  
  private weak var transitionContext:UIViewControllerContextTransitioning?
  private(set) public var isInteracting:Bool = false
  private var displayLink:CADisplayLink?
  
  weak var animator:UIViewControllerAnimatedTransitioning?
  
  public var duration:CGFloat {
    if let dur = self.animator?.transitionDuration(using: self.transitionContext) {
      return CGFloat(dur)
    }
    return 0.4
  }
  
  private(set) public var percentComplete:CGFloat = 0
  public var completionSpeed:CGFloat = 1
  public var animationCurve:UIViewAnimationCurve = .linear
  
  public init(animator:UIViewControllerAnimatedTransitioning) {
    super.init()
    self.animator = animator
  }
  
  public func updateInteractiveTransition(percentComplete:CGFloat) {
    self.percentComplete = max(min(percentComplete, 1), 0)
    self.transitionContext?.containerView.layer.timeOffset = CFTimeInterval(self.percentComplete * self.duration)
    self.transitionContext?.updateInteractiveTransition(self.percentComplete)
  }
  
  public func cancelInteractiveTransition() {
    self.transitionContext?.cancelInteractiveTransition()
    self.completeTransition()
  }
  
  public func finishInteractiveTransition() {
    self.transitionContext?.finishInteractiveTransition()
    self.completeTransition()
  }
  
  
  public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
    
  }
  
  private func completeTransition() {
    self.displayLink = CADisplayLink(target: self, selector: #selector(FKViewControllerInteractiveTransitioning.tickAnimation))
    self.displayLink?.add(to: RunLoop.main, forMode: .commonModes)
  }
  
  @objc private func tickAnimation() {
    if let tc = self.transitionContext, let dl = self.displayLink {
      var timeOffset = tc.containerView.layer.timeOffset
      let tick:CFTimeInterval = dl.duration * CFTimeInterval(self.completionSpeed)
      timeOffset += tc.transitionWasCancelled ? -tick : tick
      if ((timeOffset < 0) || (timeOffset > CFTimeInterval(self.duration))) {
        self.displayLink?.invalidate()
        tc.containerView.layer.speed = 1
        if tc.transitionWasCancelled {
          let pausedTime = tc.containerView.layer.timeOffset
          tc.containerView.layer.timeOffset = 0
          tc.containerView.layer.beginTime = 0
          let timeSincePause = tc.containerView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
          tc.containerView.layer.beginTime = timeSincePause
        }
      } else {
        tc.containerView.layer.timeOffset = timeOffset
      }
    }
  }
  
  
}
