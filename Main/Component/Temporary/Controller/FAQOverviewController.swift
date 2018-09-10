//
//  FAQOverviewController.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/4/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FAQOverviewController : DynamicController, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _faqQueue : DynamicQueue<FAQController>!
    
    var listView : UIListView!
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView()
                self._listView.delegate = self
                self._listView.dataSource = self
            }
            
            let listView = self._listView!
            
            return listView
        }
    }
    
    var faqQueue : DynamicQueue<FAQController>
    {
        get
        {
            if (self._faqQueue == nil)
            {
                self._faqQueue = DynamicQueue()
            }
            
            let faqQueue = self._faqQueue!
            
            return faqQueue
        }
    }
    
    var faqControllerSize : CGSize
    {
        get
        {
            var faqControllerSize = CGSize.zero
            faqControllerSize.width = self.listView.frame.size.width
            faqControllerSize.height = canvas.draw(tiles: 5)
            
            return faqControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.listView.backgroundColor = UIColor.white
        
        self.view.addSubview(self.listView)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.listView.frame.size = self.view.frame.size
        
        return canvas
    }
    
    override func unbind()
    {
        self.faqQueue.purge
        { (indentifier, faqController) in
            
            faqController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.faqViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let faqController = self.faqQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (faqController != nil)
        {
            itemSize.width = faqController!.view.frame.size.width
            itemSize.height = faqController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let faqController = self.faqQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> FAQController in
            
            let faqController = FAQController()
            
            return faqController
        }
        
        let faqViewModel = self.viewModel.faqViewModels[indexPath.item]
        faqController.bind(viewModel: faqViewModel)
        cell.addSubview(faqController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.faqQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (faqController) in
            
            if (faqController != nil)
            {
                faqController!.unbind()
            }
        }
    }
}
