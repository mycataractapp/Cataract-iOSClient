//
//  UIListViewAnimation.swift
//  Pacific
//
//  Created by Minh Nguyen on 1/9/18.
//  Copyright © 2018 Langtutheky. All rights reserved.
//

import UIKit

class UIListViewAnimation
{
    var scrollPosition = UIListViewScrollPosition.top
    var slideDirection = UIListViewSlideDirection.forward
    var indexPath : IndexPath
    var allowsAnimation : Bool
    var isGestureRecognized : Bool
    private var _state = UIListViewAnimationState.possible
    
    init(indexPath: IndexPath, at scrollPosition: UIListViewScrollPosition, allowsAnimation: Bool, isGestureRecognized : Bool)
    {
        self.indexPath = indexPath
        self.scrollPosition = scrollPosition
        self.allowsAnimation = allowsAnimation
        self.isGestureRecognized = isGestureRecognized
    }
    
    init(indexPath: IndexPath, from slideDirection: UIListViewSlideDirection, allowsAnimation: Bool, isGestureRecognized : Bool)
    {
        self.indexPath = indexPath
        self.slideDirection = slideDirection
        self.allowsAnimation = allowsAnimation
        self.isGestureRecognized = isGestureRecognized
    }
    
    var state : UIListViewAnimationState
    {
        get
        {
            let state = self._state
            
            return state
        }
    }
    
    func begin()
    {
        if (self._state == UIListViewAnimationState.possible)
        {
            self._state = UIListViewAnimationState.began
        }
    }
    
    func end()
    {
        if (self._state == UIListViewAnimationState.began)
        {
            self._state = UIListViewAnimationState.ended
        }
    }
    
    func cancel()
    {
        self._state = UIListViewAnimationState.cancelled
    }
}
