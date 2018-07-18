//
//  DynamicController.swift
//  Pacific
//
//  Created by Minh Nguyen on 2/25/18.
//  Copyright © 2018 Langtutheky. All rights reserved.
//

import UIKit

class DynamicController<ViewModel: DynamicViewModel> :  UIViewController
{
    private var _isBound = false
    private var _canvas : DynamicCanvas!
    private var _viewModel : ViewModel!
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        
        self.view.autoresizesSubviews = false
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isBound : Bool
    {
        get
        {
            let isBound = self._isBound
            
            return isBound
        }
    }
    
    var canvas : DynamicCanvas
    {
        get
        {
            if (self._canvas == nil)
            {
                self._canvas = DynamicCanvas(view: self.view)
            }
            
            let canvas = self._canvas!
            
            return canvas
        }
    }
    
    var viewModel : ViewModel
    {
        get
        {
            let viewModel = self._viewModel!
            
            return viewModel
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        if (self.isBound)
        {
            self._viewModel.reset()
            self._isBound = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil)
        { (UIViewControllerTransitionCoordinatorContext) in
            
            self.resize(to: size)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        let keyValueChange = NSKeyValueChange(rawValue: change![NSKeyValueChangeKey.kindKey] as! UInt)!
        
        if (keyValueChange == NSKeyValueChange.setting)
        {
            self.shouldSetKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
        else if (keyValueChange == NSKeyValueChange.insertion)
        {
            self.shouldInsertKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
        else if (keyValueChange == NSKeyValueChange.removal)
        {
            self.shouldRemoveKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
        else if (keyValueChange == NSKeyValueChange.replacement)
        {
            self.shouldReplaceKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func render(size: CGSize)
    {
        self.view.frame.size = size
    }
    
    func bind(viewModel: ViewModel)
    {
        self._viewModel = viewModel
        self._isBound = true
        self.view.setNeedsLayout()
    }
    
    func unbind()
    {
        self._viewModel = nil
        self._isBound = false
    }
    
    func resize(to size: CGSize){}
    
    func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){}
    
    func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){}
    
    func shouldReplaceKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){}
    
    func shouldRemoveKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){}
}
