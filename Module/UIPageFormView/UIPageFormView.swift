//
//  UIPageFormView.swift
//  Pacific
//
//  Created by Minh Nguyen on 5/22/18.
//  Copyright © 2018 Minh Nguyen. All rights reserved.
//

import UIKit

enum UIPageFormViewNavigationDirection : Int
{
    case forward
    case reverse
}

class UIPageFormView : UIView
{
    private var _currentView : UIView?
    
    func setView(_ view: UIView, direction: UIPageFormViewNavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil)
    {
        if (self._currentView !== view)
        {
            self.addSubview(view)
            
            if (direction == UIPageFormViewNavigationDirection.forward)
            {
                view.frame.origin.x = self.frame.width
            }
            else
            {
                view.frame.origin.x = -self.frame.width
            }
            
            if (animated && self._currentView != nil)
            {
                UIView.animate(withDuration: 0.25, animations:
                {
                    self.animate(view, to: direction)
                })
                { (isCompleted) in
                    
                    self.complete(isCompleted: isCompleted, view: view, completion: completion)
                }
            }
            else
            {
                self.animate(view, to: direction)
                self.complete(isCompleted: true, view: view, completion: completion)
            }
        }
    }
    
    private func animate(_ view: UIView, to direction: UIPageFormViewNavigationDirection)
    {
        if (self._currentView != nil)
        {
            if (direction == UIPageFormViewNavigationDirection.forward)
            {
                self._currentView!.frame.origin.x = -self.frame.width
            }
            else
            {
                self._currentView!.frame.origin.x = self.frame.width
            }
        }
        
        view.frame.origin.x = 0
    }
    
    private func complete(isCompleted: Bool, view: UIView, completion: ((Bool) -> Void)? = nil)
    {
        if (isCompleted)
        {
            if (self._currentView != nil)
            {
                self._currentView!.removeFromSuperview()
            }
            
            self._currentView = view
        }
        else
        {
            view.removeFromSuperview()
        }
        
        if (completion != nil)
        {
            completion!(isCompleted)
        }
    }
}
