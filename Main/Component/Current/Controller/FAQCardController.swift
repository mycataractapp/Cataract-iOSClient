//
//  FAQCardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FAQCardController : DynamicController
{
    private var _imageView : UIImageView!
    private var _questionLabel : UILabel!
    private var _answerLabel : UILabel!
    private var _lineView : UIView!
    @objc dynamic var viewModel : FAQCardViewModel!
    
    var imageView : UIImageView
    {
        get
        {
            if (self._imageView == nil)
            {
                self._imageView = UIImageView()
                self._imageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "png")!)
            }
            
            let imageView = self._imageView!
            
            return imageView
        }
    }
    
    var questionLabel : UILabel
    {
        get
        {
            if (self._questionLabel == nil)
            {
                self._questionLabel = UILabel()
                self._questionLabel.numberOfLines = 0
                self._questionLabel.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let questionLabel = self._questionLabel!
            
            return questionLabel
        }
    }
    
    var answerLabel : UILabel
    {
        get
        {
            if (self._answerLabel == nil)
            {
                self._answerLabel = UILabel()
                self._answerLabel.numberOfLines = 0
            }
            
            let answerLabel = self._answerLabel!
            
            return answerLabel
        }
    }
    
    var lineView : UIView
    {
        get
        {
            if (self._lineView == nil)
            {
                self._lineView = UIView()
                self._lineView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
            }
            
            let lineView = self._lineView!
            
            return lineView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.questionLabel)
        self.view.addSubview(self.answerLabel)
        self.view.addSubview(self.lineView)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        let canvas = DynamicCanvas(size: self.viewModel.size)
        self.view.frame.size = canvas.size
        
        self.questionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.answerLabel.font = UIFont.systemFont(ofSize: 20)
        
        self.imageView.frame.size.width = canvas.draw(tiles: 1)
        self.imageView.frame.size.height = self.imageView.frame.size.width
        
        self.questionLabel.frame.size.width = self.view.frame.size.width - self.imageView.frame.size.width - canvas.draw(tiles: 1.15)
        self.questionLabel.sizeToFit()
        
        self.answerLabel.frame.size.width = self.view.frame.size.width - self.imageView.frame.size.width - canvas.draw(tiles: 1.15)
        self.answerLabel.sizeToFit()
        
        self.lineView.frame.size.width = self.view.frame.size.width - canvas.draw(tiles: 1)
        self.lineView.frame.size.height = 1
        
        self.view.frame.size.height = self.questionLabel.frame.size.height + self.answerLabel.frame.size.height + self.lineView.frame.size.height + canvas.draw(tiles: 0.75)
        
        self.imageView.frame.origin.x = canvas.draw(tiles: 0.15)
        self.imageView.frame.origin.y = canvas.draw(tiles: 0.25)
        
        self.questionLabel.frame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + canvas.draw(tiles: 0.25)
        self.questionLabel.frame.origin.y = self.imageView.frame.origin.y
        
        self.answerLabel.frame.origin.x = self.questionLabel.frame.origin.x
        self.answerLabel.frame.origin.y = self.questionLabel.frame.origin.y + self.questionLabel.frame.size.height + canvas.draw(tiles: 0.25)
        
        self.lineView.frame.origin.x = self.questionLabel.frame.origin.x
        self.lineView.frame.origin.y = self.view.frame.size.height - self.lineView.frame.size.height
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\FAQCardController.viewModel.question),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\FAQCardController.viewModel.answer),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\FAQCardController.viewModel.question))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\FAQCardController.viewModel.answer))
    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.kind == DynamicKVO.Event.Kind.setting)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\FAQCardController.viewModel.question))
            {
                let newValue = kvoEvent.newValue as? String
                self.set(question: newValue)
            }
            else if (kvoEvent.keyPath == DynamicKVO.keyPath(\FAQCardController.viewModel.answer))
            {
                let newValue = kvoEvent.newValue as? String
                self.set(answer: newValue)
            }
        }
    }
    
    func set(question: String?)
    {
        self.questionLabel.text = question
    }
    
    func set(answer: String?)
    {
        self.answerLabel.text = answer
    }
    
    class Cell : UITableViewCell
    {
        private var _faqCardController : FAQCardController!
        
        var faqCardController : FAQCardController
        {
            get
            {
                if (self._faqCardController == nil)
                {
                    self._faqCardController = FAQCardController()
                    self._faqCardController.bind()
                    self.addSubview(self._faqCardController.view)
                    self.autoresizesSubviews = false
                }
                
                let faqCardController = self._faqCardController!
                
                return faqCardController
            }
        }
    }
    
    class CollectionController : DynamicController, UITableViewDelegate, UITableViewDataSource
    {
        private var _tableViewController : UITableViewController!
        private var _faqCardControllers = Set<FAQCardController>()
        @objc dynamic var viewModel : FAQCardViewModel.CollectionViewModel!
        
        var tableViewController : UITableViewController
        {
            get
            {
                if (self._tableViewController == nil)
                {
                    self._tableViewController = UITableViewController()
                    self._tableViewController.tableView.delegate = self
                    self._tableViewController.tableView.dataSource = self
                }
                
                let tableViewController = self._tableViewController!
                
                return tableViewController
            }
        }
        
        var tableView : UITableView
        {
            get
            {
                let tableView = self.tableViewController.tableView!
                
                return tableView
            }
        }
        
        override func viewDidLoad()
        {
            self.tableView.backgroundColor = UIColor.white
            self.tableView.register(FAQCardController.Cell.self, forCellReuseIdentifier: FAQCardViewModel.description())
            
            self.view.addSubview(self.tableView)
        }
        
        override func unbind()
        {
            super.unbind()
                        
            for faqCardController in self._faqCardControllers
            {
                faqCardController.unbind()
            }
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\FAQCardController.viewModel))
            {
                self.tableView.reloadData()
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return self.viewModel.faqCardViewModels.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let faqCardViewModel = self.viewModel.faqCardViewModels[indexPath.row]
            let cell = self.tableView.dequeueReusableCell(withIdentifier: FAQCardViewModel.description()) as! FAQCardController.Cell
            cell.faqCardController.viewModel = faqCardViewModel
            self._faqCardControllers.insert(cell.faqCardController)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            var heightForRow : CGFloat = 0
            let faqCardViewModel = self.viewModel.faqCardViewModels[indexPath.row]
            
            for faqCardController in self._faqCardControllers
            {
                if (faqCardController.viewModel === faqCardViewModel)
                {
                    heightForRow = faqCardController.view.frame.height
                    break
                }
            }
                        
            return heightForRow
        }
    }
}
