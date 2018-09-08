//
//  TestController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/30/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TestController : DynamicController<TestViewModel>
{
    private var _label : UILabel!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self._label.textAlignment = NSTextAlignment.center
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.label)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.label.font = UIFont.systemFont(ofSize: 32)
        
        self.label.frame.size.width = self.canvas.draw(tiles: 5)
        self.label.frame.size.height = self.label.frame.size.width
        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (self.view.frame.size.height - self.label.frame.size.height) / 2        
    }
    
    override func bind(viewModel: TestViewModel)
    {
        super.bind(viewModel: viewModel)
        
        viewModel.addObserver(self,
                              forKeyPath: "title",
                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                   NSKeyValueObservingOptions.initial]),
                              context: nil)
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "title")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(title: newValue)
        }
    }
    
    func set(title: String)
    {
        self.label.text = title
    }
    
    
}
