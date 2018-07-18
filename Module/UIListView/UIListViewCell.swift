//
//  UIListViewCell.swift
//  Pacific
//
//  Created by Minh Nguyen on 11/24/15.
//  Copyright © 2015 Minh Nguyen. All rights reserved.
//

import UIKit

class UIListViewCell : UIView
{
    var isSelected = false
    var reuseIdentifier : String?
    private var _contentView : UIView!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.autoresizesSubviews = false
    }
    
    convenience init()
    {
        self.init(frame: CGRect.zero)
    }
    
    convenience init(reuseIdentifier: String)
    {
        self.init()
        
        self.reuseIdentifier = reuseIdentifier
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentView : UIView
    {
        get
        {
            if (self._contentView == nil)
            {
                self._contentView = UIView()
                self.insertSubview(self._contentView, at: 0)
            }
            
            let contentView = self._contentView!
            
            return contentView
        }
    }
    
    override func layoutSubviews()
    {
        self.contentView.frame.size = self.frame.size
    }
}
