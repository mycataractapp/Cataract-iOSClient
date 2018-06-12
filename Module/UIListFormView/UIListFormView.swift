//
//  UIListFormView.swift
//  Pacific
//
//  Created by Minh Nguyen on 5/22/18.
//  Copyright © 2018 Minh Nguyen. All rights reserved.
//

import UIKit

enum UIListFormViewNavigationDirection : Int
{
    case forward
    case reverse
}

class UIListFormView : UIView
{
    private var _currentView : UIView?
    
    func setView(_ view: UIView, direction: UIListFormViewNavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil)
    {
        if (self._currentView !== view)
        {
            self.addSubview(view)
            
            if (direction == UIListFormViewNavigationDirection.forward)
            {
                view.frame.origin.y = self.frame.height
            }
            else
            {
                view.frame.origin.y = -self.frame.height
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
    
    private func animate(_ view: UIView, to direction: UIListFormViewNavigationDirection)
    {
        if (self._currentView != nil)
        {
            if (direction == UIListFormViewNavigationDirection.forward)
            {
                self._currentView!.frame.origin.y = -self.frame.height
            }
            else
            {
                self._currentView!.frame.origin.y = self.frame.height
            }
        }
        
        view.frame.origin.y = 0
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
