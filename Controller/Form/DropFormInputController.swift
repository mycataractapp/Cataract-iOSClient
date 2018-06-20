//
//  DropFormInputController.swift
//  Cataract
//
//  Created by Rose Choi on 6/19/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropFormInputController : DynamicController<DropFormInputViewModel>
{
    private var _titleLabel : UILabel!
    private var _colorLabel : UILabel!
    private var _inputController : InputController!
    private var _iconOverviewController : IconOverviewController!
    private var _dropColorStore : DropColorStore!
    
    var titleLabel : UILabel
    {
        get
        {
            if (self._titleLabel == nil)
            {
                self._titleLabel = UILabel()
                self._titleLabel.text = "Choose a name for your drop."
                self._titleLabel.textAlignment = NSTextAlignment.center
            }
            
            let titleLabel = self._titleLabel!
            
            return titleLabel
        }
    }
    
    var colorLabel : UILabel
    {
        get
        {
            if (self._colorLabel == nil)
            {
                self._colorLabel = UILabel()
                self._colorLabel.text = "Choose a color accordingly."
                self._colorLabel.textAlignment = NSTextAlignment.center
            }
            
            let colorLabel = self._colorLabel!
            
            return colorLabel
        }
    }
    
    var inputController : InputController
    {
        get
        {
            if (self._inputController == nil)
            {
                self._inputController = InputController()
            }
            
            let inputController = self._inputController!
            
            return inputController
        }
    }
    
    var iconOverviewController : IconOverviewController
    {
        get
        {
            if (self._iconOverviewController == nil)
            {
                self._iconOverviewController = IconOverviewController()
            }

            let iconOverviewController = self._iconOverviewController!

            return iconOverviewController
        }
    }
    
    var dropColorStore : DropColorStore
    {
        get
        {
            if (self._dropColorStore == nil)
            {
                self._dropColorStore = DropColorStore()
            }
            
            let dropColorStore = self._dropColorStore!
            
            return dropColorStore
        }
    }
    
    var inputControllerSize : CGSize
    {
        get
        {
            var inputControllerSize = CGSize.zero
            inputControllerSize.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
            inputControllerSize.height = self.canvas.draw(tiles: 3)
            
            return inputControllerSize
        }
    }
    
    var iconOverviewControllerSize : CGSize
    {
        get
        {
            var iconOverviewControllerSize = CGSize.zero
            iconOverviewControllerSize.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
            iconOverviewControllerSize.height = self.canvas.draw(tiles: 7)
            
            return iconOverviewControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.colorLabel)
        self.view.addSubview(self.inputController.view)
        self.view.addSubview(self.iconOverviewController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 24)
        self.colorLabel.font = UIFont.systemFont(ofSize: 24)
        
        self.titleLabel.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.titleLabel.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.colorLabel.frame.size.width = self.titleLabel.frame.size.width
        self.colorLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.inputController.render(size: self.inputControllerSize)
        self.iconOverviewController.render(size: self.iconOverviewControllerSize)
        
        self.titleLabel.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.titleLabel.frame.origin.y = (self.canvas.gridSize.height - self.titleLabel.frame.size.height - self.colorLabel.frame.size.height - self.inputControllerSize.height - self.iconOverviewControllerSize.height - self.canvas.draw(tiles: 1.5)) / 2
        
        self.inputController.view.frame.origin.x = self.titleLabel.frame.origin.x
        self.inputController.view.frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + self.canvas.draw(tiles: 0.5)
        
        self.colorLabel.frame.origin.x = self.titleLabel.frame.origin.x
        self.colorLabel.frame.origin.y = self.inputController.view.frame.origin.y + self.inputControllerSize.height + self.canvas.draw(tiles: 0.5)
        
        self.iconOverviewController.view.frame.origin.x = self.titleLabel.frame.origin.x
        self.iconOverviewController.view.frame.origin.y = self.colorLabel.frame.origin.y + self.colorLabel.frame.size.height + self.canvas.draw(tiles: 0.5)
    }
    
    override func bind(viewModel: DropFormInputViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.inputController.bind(viewModel: self.viewModel.inputViewModel)
        self.iconOverviewController.bind(viewModel: self.viewModel.iconOverviewViewModel)
                
        self.dropColorStore.addObserver(self,
                                        forKeyPath: "models",
                                        options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                             NSKeyValueObservingOptions.initial]),
                                        context: nil)
    }
    
    override func unbind()
    {
        self.inputController.unbind()
        self.iconOverviewController.unbind()
                
        super.unbind()
    }
    
    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {
            let indexSet = change![NSKeyValueChangeKey.indexesKey] as! IndexSet
            
            if (self.dropColorStore === object as! NSObject)
            {
                self.iconOverviewController.viewModel.iconViewModels = [IconViewModel]()
                
                for index in indexSet
                {
                    let dropColorModel = self.dropColorStore.retrieve(at: index)
                    let iconViewModel = IconViewModel(color: dropColorModel.color, colorPathByState: dropColorModel.colorPathByState, isSelected: false)
                    
                    self.iconOverviewController.viewModel.iconViewModels.append(iconViewModel)                    
                }
                
                self.iconOverviewController.listView.reloadData()
            }
        }
    }
}
