//
//  TestOverviewController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 9/5/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TestOverviewController : DynamicController<TestOverviewViewModel>, UITableViewDelegate, UITableViewDataSource
{
    private var _tableView : UITableView!
    var controllers : [TestController] = []
    
    var tableView : UITableView
    {
        get
        {
            if (self._tableView == nil)
            {
                self._tableView = UITableView()
                self._tableView.delegate = self
                self._tableView.dataSource = self
            }
            
            let tableView = self._tableView!
            
            return tableView
        }
    }
    
    var testControllerSize : CGSize
    {
        get
        {
            var testControllerSize = CGSize.zero
            testControllerSize.width = self.tableView.frame.size.width
            testControllerSize.height = self.tableView.frame.size.height
            
            return testControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.tableView)
        
        tableView.register(ControllerCell.self, forCellReuseIdentifier: "ControllerCell")
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.tableView.frame.size = self.view.frame.size
    }
    
    func createArray() -> [TestController]
    {
        for testViewModel in self.viewModel.testViewModels
        {
            let controller = TestController()
            controller.bind(viewModel: testViewModel)
            controller.render(size: self.testControllerSize)
            
            self.controllers.append(controller)
        }
        
        return controllers
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        return self.viewModel.testViewModels.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let controllerCell = tableView.dequeueReusableCell(withIdentifier: "ControllerCell") as! ControllerCell
        
        for view in self.controllers
        {
            controllerCell.contentView.addSubview(view.label)
        }

        return controllerCell
    }
}

class ControllerCell : UITableViewCell
{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
