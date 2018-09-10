//
//  DropFormInputController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/19/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropFormInputController : DynamicController, UIListViewDelegate, UIListViewDataSource
{
    private var _titleLabel : UILabel!
    private var _colorLabel : UILabel!
    private var _listView : UIListView!
    private var _inputController : InputController!
    private var _iconOverviewController : IconOverviewController!
    private var _colorStore : ColorStore!
    
    var titleLabel : UILabel
    {
        get
        {
            if (self._titleLabel == nil)
            {
                self._titleLabel = UILabel()
                self._titleLabel.text = "Choose a name for your drop."
                self._titleLabel.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
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
                self._colorLabel.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                self._colorLabel.textAlignment = NSTextAlignment.center
            }

            let colorLabel = self._colorLabel!

            return colorLabel
        }
    }
    
    var listView : UIListView
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView(style: UIListViewStyle.grouped)
                self._listView.delegate = self
                self._listView.dataSource = self
                self._listView.anchorPosition = UIListViewScrollPosition.middle
            }
            
            let listView = self._listView!
            
            return listView
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
    
    var colorStore : ColorStore
    {
        get
        {
            if (self._colorStore == nil)
            {
                self._colorStore = ColorStore()
            }

            let colorStore = self._colorStore!

            return colorStore
        }
    }
    
    var inputControllerSize : CGSize
    {
        get
        {
            var inputControllerSize = CGSize.zero
            inputControllerSize.width = canvas.size.width - canvas.draw(tiles: 1)
            inputControllerSize.height = canvas.draw(tiles: 3)
            
            return inputControllerSize
        }
    }
    
    var iconOverviewControllerSize : CGSize
    {
        get
        {
            var iconOverviewControllerSize = CGSize.zero
            iconOverviewControllerSize.width = canvas.size.width - canvas.draw(tiles: 1)
            iconOverviewControllerSize.height = canvas.draw(tiles: 7)
            
            return iconOverviewControllerSize
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
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 24)
        self.colorLabel.font = UIFont.systemFont(ofSize: 24)

        self.titleLabel.frame.size.width = canvas.size.width - canvas.draw(tiles: 1)
        self.titleLabel.frame.size.height = canvas.draw(tiles: 2)

        self.colorLabel.frame.size.width = self.titleLabel.frame.size.width
        self.colorLabel.frame.size.height = self.titleLabel.frame.size.height
        
        self.inputController.view.frame.origin.x = canvas.draw(tiles: 0.5)
        self.iconOverviewController.view.frame.origin.x = canvas.draw(tiles: 0.5)
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.inputController.bind()
        self.iconOverviewController.bind()
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.inputController.unbind()
        self.iconOverviewController.unbind()
    }
    
    func numberOfListSections(in listView: UIListView) -> Int
    {
        return 2
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        
        if (indexPath.section == 0)
        {
            itemSize.height = self.inputController.view.frame.height
        }
        else if (indexPath.section == 1)
        {
            itemSize.height = self.iconOverviewController.view.frame.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        if (indexPath.section == 0)
        {
            cell.addSubview(self.inputController.view)
        }
        else if (indexPath.section == 1)
        {
            cell.addSubview(self.iconOverviewController.view)
        }
        
        return cell
    }
    
    func listView(_ listView: UIListView, viewForHeaderInSection section: Int) -> UIView?
    {
        var label : UILabel! = nil
        
        if (section == 0)
        {
            label = self.titleLabel
        }
        else if (section == 1)
        {
            label = self.colorLabel
        }
        
        return label
    }
    
    func listView(_ listView: UIListView, heightForHeaderInSection section: Int) -> CGFloat
    {
        var headerHeight : CGFloat = 0
        
        if (section == 0)
        {
            headerHeight = self.titleLabel.frame.height
        }
        else if (section == 1)
        {
            headerHeight = self.colorLabel.frame.height
        }
        
        return headerHeight
    }
    
//    func listView(_ listView: UIListView, titleForHeaderInSection section: Int) -> String?
//    {
//        var title = ""
//
//        if (section == 0)
//        {
//            title = "Choose a name for your drop."
//        }
//        else if (section == 1)
//        {
//             title = "Choose a color accordingly."
//        }
//
//        return title
//    }
    
    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {
            let indexSet = change![NSKeyValueChangeKey.indexesKey] as! IndexSet
            
            if (self.colorStore === object as! NSObject)
            {
                self.iconOverviewController.viewModel.iconViewModels = [IconViewModel]()
                
                for index in indexSet
                {
                    let colorModel = self.colorStore.retrieve(at: index)
                    let iconViewModel = IconViewModel(title: colorModel.name,
                                                      colorPathByState: ["On": colorModel.filledCircleName,
                                                                         "Off": colorModel.emptyCircleName],
                                                      colorCode: ["red": colorModel.redValue,
                                                                  "green": colorModel.greenValue,
                                                                  "blue": colorModel.blueValue,
                                                                  "alpha": colorModel.alphaValue],
                                                      isSelected: false)

                    self.iconOverviewController.viewModel.iconViewModels.append(iconViewModel)
                }

                self.iconOverviewController.listView.reloadData()
            }
        }
    }
}
