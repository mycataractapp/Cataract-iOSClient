//
//  UIPageViewAnimation.swift
//  Pacific
//
//  Created by Minh Nguyen on 1/9/18.
//  Copyright © 2018 Langtutheky. All rights reserved.
//

import UIKit

class UIPageViewAnimation : NSObject
{
    var scrollPosition = UIPageViewScrollPosition.left
    var slideDirection = UIPageViewSlideDirection.forward
    var indexPath : IndexPath
    var allowsAnimation : Bool
    var isGestureRecognized : Bool
    private var _state = UIPageViewAnimationState.possible
    
    init(indexPath: IndexPath, at scrollPosition: UIPageViewScrollPosition, allowsAnimation: Bool, isGestureRecognized : Bool)
    {
        self.indexPath = indexPath
        self.scrollPosition = scrollPosition
        self.allowsAnimation = allowsAnimation
        self.isGestureRecognized = isGestureRecognized
    }
    
    init(indexPath: IndexPath, from slideDirection: UIPageViewSlideDirection, allowsAnimation: Bool, isGestureRecognized : Bool)
    {
        self.indexPath = indexPath
        self.slideDirection = slideDirection
        self.allowsAnimation = allowsAnimation
        self.isGestureRecognized = isGestureRecognized
    }
    
    var state : UIPageViewAnimationState
    {
        get
        {
            let state = self._state
            
            return state
        }
    }
    
    func begin()
    {
        if (self._state == UIPageViewAnimationState.possible)
        {
            self._state = UIPageViewAnimationState.began
        }
    }
    
    func end()
    {
        if (self._state == UIPageViewAnimationState.began)
        {
            self._state = UIPageViewAnimationState.ended
        }
    }
    
    func cancel()
    {
        self._state = UIPageViewAnimationState.cancelled
    }
}

