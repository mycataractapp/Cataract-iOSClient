//
//  DropFormController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftMoment

class DropFormController : DynamicController, DynamicViewModelDelegate
{
    private var _pageViewController : UIPageViewController!
    private var _firstPageController : DropFormController.FirstPageController!
    private var _secondPageController : DropFormController.SecondPageController!
    private var _thirdPageController : DropFormController.ThirdPageController!
    private var _footerPanelController : FooterPanelController!
    private var _overLayController : UserController.OverLayController!
    private var _timeStore : DynamicStore.Collection<TimeModel>!
    @objc dynamic var viewModel : DropFormViewModel!
    
    var pageViewController : UIPageViewController
    {
        get
        {
            if (self._pageViewController == nil)
            {
                self._pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll,
                                                                navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal,
                                                                options: nil)
                self._pageViewController.setViewControllers([self.firstPageController.collectionViewController],
                                                            direction: UIPageViewControllerNavigationDirection.forward,
                                                            animated: true,
                                                            completion: nil)
                
            }
            
            let pageViewController = self._pageViewController!
            
            return pageViewController
        }
    }
    
    var firstPageController : DropFormController.FirstPageController
    {
        get
        {
            if (self._firstPageController == nil)
            {
                self._firstPageController = DropFormController.FirstPageController()
            }
            
            let firstPageController = self._firstPageController!
            
            return firstPageController
        }
    }
    
    var secondPageController : DropFormController.SecondPageController
    {
        get
        {
            if (self._secondPageController == nil)
            {
                self._secondPageController = DropFormController.SecondPageController()
            }
            
            let secondPageController = self._secondPageController!
            
            return secondPageController
        }
    }
    
    var thirdPageController : DropFormController.ThirdPageController
    {
        get
        {
            if (self._thirdPageController == nil)
            {
                self._thirdPageController = DropFormController.ThirdPageController()
            }

            let thirdPageController = self._thirdPageController!

            return thirdPageController
        }
    }
    
    var footerPanelController : FooterPanelController
    {
        get
        {
            if (self._footerPanelController == nil)
            {
                self._footerPanelController = FooterPanelController()
            }
            
            let footerPanelController = self._footerPanelController!
            
            return footerPanelController
        }
    }

    var overLayController : UserController.OverLayController
    {
        get
        {
            if (self._overLayController == nil)
            {
                self._overLayController = UserController.OverLayController()
            }

            let overLayController = self._overLayController!

            return overLayController
        }
    }
    
    var timeStore : DynamicStore.Collection<TimeModel>
    {
        get
        {
            if (self._timeStore == nil)
            {
                self._timeStore = DynamicStore.Collection<TimeModel>()
            }
            
            let timeStore = self._timeStore!
            
            return timeStore
        }
    }
    
    @objc var timeStoreRepresentable : DynamicStore
    {
        get
        {
            let timeStoreRepresentable = self.timeStore
            
            return timeStoreRepresentable
        }
    }

    override func viewDidLoad()
    {
        self.view.addSubview(self.pageViewController.view)
        self.view.addSubview(self.footerPanelController.view)
    }
    
    override func bind()
    {
        super.bind()
        
        self.firstPageController.bind()
        self.secondPageController.bind()
        self.thirdPageController.bind()
        self.footerPanelController.bind()
        self.overLayController.bind()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self._keyBoardWillAppear(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
    }
    
    @objc private func _keyBoardWillAppear(notification: Notification)
    {
        if (self.viewModel != nil)
        {
            self.overLayController.collectionViewController.collectionView?.scrollToItem(at: IndexPath(item: 2, section: 0),
                                                                                         at: UICollectionViewScrollPosition.bottom,
                                                                                         animated: true)
        }
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
                
        self.viewModel.footerPanelViewModel.size.width = self.view.frame.size.width
        self.viewModel.footerPanelViewModel.size.height = 90

        self.pageViewController.view.frame.size.height = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height - 20
        
        self.viewModel.firstPageViewModel.nameLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.nameLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 5

        self.viewModel.firstPageViewModel.colorLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.colorLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 5
        
        self.viewModel.firstPageViewModel.textFieldInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.textFieldInputViewModel.size.height = self.pageViewController.view.frame.size.height / 5
        
        for colorCardviewModel in self.viewModel.firstPageViewModel.colorCardViewModels
        {
            colorCardviewModel.size.width = self.pageViewController.view.frame.size.width / 4
            colorCardviewModel.size.height = self.pageViewController.view.frame.size.height / 5
        }
        
        self.viewModel.secondPageViewModel.startDateLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.startDateLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 4
        
        self.viewModel.secondPageViewModel.endDateLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.endDateLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 4
        
        self.viewModel.secondPageViewModel.startDatePickerInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.startDatePickerInputViewModel.size.height = self.pageViewController.view.frame.size.height / 4
        
        self.viewModel.secondPageViewModel.endDatePickerInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.endDatePickerInputViewModel.size.height = self.pageViewController.view.frame.size.height / 4
        
        self.viewModel.thirdPageViewModel.controlCardStartTime.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardStartTime.size.height = 100

        self.viewModel.thirdPageViewModel.controlCardInterval.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardInterval.size.height = 100

        self.viewModel.thirdPageViewModel.controlCardTimesPerDay.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardTimesPerDay.size.height = 100
        
        self.viewModel.thirdPageViewModel.labelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.labelViewModel.size.height = 50
        
        self.viewModel.overLayCardViewModelTime.textFieldTimesPerdayViewModel.size.width = self.view.frame.size.width
        self.viewModel.overLayCardViewModelTime.textFieldTimesPerdayViewModel.size.height = 100
        
        self.viewModel.overLayCardViewModelTime.confirmButtonViewModel.size.width = self.view.frame.size.width
        self.viewModel.overLayCardViewModelTime.confirmButtonViewModel.size.height = 100
        
        self.viewModel.overLayCardViewModelTime.size = self.viewModel.size
        
        self.footerPanelController.view.frame.origin.y = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height
        
        self.thirdPageController.startTimeCell.control.viewModel = self.viewModel.thirdPageViewModel.controlCardStartTime
        self.thirdPageController.intervalTimeCell.control.viewModel = self.viewModel.thirdPageViewModel.controlCardInterval
        self.thirdPageController.timesPerDayCell.control.viewModel = self.viewModel.thirdPageViewModel.controlCardTimesPerDay
        self.thirdPageController.labelCell.labelController.viewModel = self.viewModel.thirdPageViewModel.labelViewModel

        self.footerPanelController.viewModel = self.viewModel.footerPanelViewModel

        self.firstPageController.viewModel = self.viewModel.firstPageViewModel
        self.secondPageController.viewModel = self.viewModel.secondPageViewModel
        self.thirdPageController.viewModel = self.viewModel.thirdPageViewModel
        self.overLayController.viewModel = self.viewModel.overLayCardViewModelTime
    }
    
    func update()
    {
        var timeModels = [TimeModel]()

        let value = Int(self.viewModel.overLayCardViewModelTime.textFieldTimesPerdayViewModel.value)
        var time = self.viewModel.overLayCardViewModelTime.timeDatePickerInputViewModel.timeInterval
        let interval = self.viewModel.overLayCardViewModelTime.intervalDatePickerViewModel.timeInterval
        
        var ids = [String]()
        
        for (id, timeModel) in self.timeStore.selectAll()
        {
            ids.append(id)
        }
        
        if (ids.count > 0)
        {
            self.timeStore.delete(by: ids)
        }
        
        for _ in 0...value! - 1
        {
            let aMoment = moment(time)
    
            let timeModel = TimeModel(interval: time)
            timeModels.append(timeModel)
            
            let duration = Int(interval).seconds
            time = aMoment.add(duration).date.timeIntervalSince1970
        }
        
        self.timeStore.insert(models: timeModels)
        .catch
        { (error) -> Any? in
            
            print(error)
        }
        
        self.thirdPageController.collectionViewController.collectionView?.reloadData()
    }
    
    override var storeEventKeyPaths: Set<String>
    {
        get
        {
            let storeEventKeyPaths = super.storeEventKeyPaths.union([DynamicKVO.keyPath(\DropFormController.timeStoreRepresentable.event)])

            return storeEventKeyPaths
        }
    }
    
    override func observeStore(for storeEvent: DynamicStore.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.timeStoreRepresentable.event))
        {
            if (storeEvent.operation == DynamicStore.Event.Operation.insert)
            {
                let timeModels = storeEvent.models as! [TimeModel]
                var labelViewModels = [LabelViewModel]()
                
                for timeModel in timeModels
                {
                    let aMoment = moment(timeModel.interval)
        
                    let colorCardViewModel = ColorCardViewModel(redValue: 0, greenValue: 0, blueValue: 0, alphaValue: 1)
                    let labelViewModel = LabelViewModel(text: aMoment.format("hh:mm a"),
                                                        textColor: colorCardViewModel,
                                                        numberOfLines: 1,
                                                        borderColor: colorCardViewModel,
                                                        borderWidth: 0,
                                                        size: CGSize.zero,
                                                        style: .truncate,
                                                        textAlignment: .center)

                    labelViewModel.size.width = self.pageViewController.view.frame.size.width
                    labelViewModel.size.height = 75

                    labelViewModels.append(labelViewModel)
                }
                
                self.viewModel.thirdPageViewModel.labelViewModels = labelViewModels
            }
            else if (storeEvent.operation == DynamicStore.Event.Operation.delete)
            {
                var tempViewModels = [LabelViewModel]()
                let timeModels = storeEvent.models as! [TimeModel]
                let ids : Set<String> = Set<String>(timeModels.map
                { (timeModel) -> String in
                    
                    return timeModel.id
                })
                
                for labelViewModel in self.viewModel.thirdPageViewModel.labelViewModels
                {
                    if (ids.contains(labelViewModel.description))
                    {
                    }
                    else
                    {
                        tempViewModels.append(labelViewModel)
                    }
                }
                
                self.viewModel.thirdPageViewModel.labelViewModels = tempViewModels
                
                self.thirdPageController.collectionViewController.collectionView?.reloadData()
                
                // Create a new temporary viewModels
                // Loop through the existing viewModels, check if viewModel's id is contained in the Set, if return false, then add the viewModel to the temporary viewModels
                // After finish the loop, set the temporary viewModels as the actual viewModels
                // ReloadData
                
                //when you want to remove an item from an array, check for the ones you want to keep.
            }
        }
    }

    override var viewModelEventKeyPaths: Set<String>
    {
        get
        {
            var viewModelEventKeyPaths = super.viewModelEventKeyPaths
            viewModelEventKeyPaths = viewModelEventKeyPaths.union(Set<String>([DynamicKVO.keyPath(\DropFormController.viewModel.footerPanelViewModel.event),
                                                      DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardStartTime.event),
                                                      DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardInterval.event),
                                                      DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardTimesPerDay.event),
                                                      DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModelTime.confirmButtonViewModel.event),
                                                      DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModelTime.timeDatePickerInputViewModel.event),
                                                      DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModelTime.intervalDatePickerViewModel.event),
                                                      DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModelTime.textFieldTimesPerdayViewModel.event)]))
            
            return viewModelEventKeyPaths
        }
    }
    
    override func observeViewModel(for viewModelEvent: DynamicViewModel.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.footerPanelViewModel.event))
        {
            if (self.viewModel.footerPanelViewModel.state == FooterPanelViewModel.State.left)
            {
                if (self.viewModel.state == DropFormViewModel.State.date)
                {
                    self.viewModel.inputDrop()
                }
                else if (self.viewModel.state == DropFormViewModel.State.schedule)
                {
                    self.viewModel.inputDate()
                }
            }
            else if (self.viewModel.footerPanelViewModel.state == FooterPanelViewModel.State.right)
            {
                if (self.viewModel.state == DropFormViewModel.State.drop)
                {
                    self.viewModel.inputDate()
                }
                else if (self.viewModel.state == DropFormViewModel.State.date)
                {
                    self.viewModel.setSchedule()
                }
                else if (self.viewModel.state == DropFormViewModel.State.schedule)
                {
                    var selectedColorModel : ColorCardViewModel!
                    var colorModel : ColorModel!
                    let startTime = self.viewModel.secondPageViewModel.startDatePickerInputViewModel.timeInterval
                    let endTime = self.viewModel.secondPageViewModel.endDatePickerInputViewModel.timeInterval
                    let title = self.viewModel.firstPageViewModel.textFieldInputViewModel.value
                    
                    let startTimeModel = TimeModel(interval: startTime)
                    let endTimeModel = TimeModel(interval: endTime)
                    
                    for colorViewModel in self.viewModel.firstPageViewModel.colorCardViewModels
                    {
                        if (colorViewModel.state == ColorCardViewModel.State.on)
                        {
                            selectedColorModel = colorViewModel
                            
                            colorModel = ColorModel(redValue: selectedColorModel.redValue,
                                                    greenValue: selectedColorModel.greenValue,
                                                    blueValue: selectedColorModel.blueValue,
                                                    alphaValue: selectedColorModel.alphaValue)
                            
                            break
                        }
                    }
                    
                    var timeModels = [TimeModel]()
                    
                    for (id, timeModel) in self.timeStore.selectAll()
                    {
                        timeModels.append(timeModel)
                    }

                    let dropModel = DropModel(title: title,
                                              colorModel: colorModel,
                                              startTimeModel: startTimeModel,
                                              endTimeModel: endTimeModel,
                                              frequencyTimeModels: timeModels)
                }
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardStartTime.event))
        {
            if (self.viewModel.thirdPageViewModel.controlCardStartTime.state == UserViewModel.ControlCard.State.editor)
            {
                self.viewModel.overLayCardViewModelTime.LoadTime()
                
                self.present(self.overLayController.collectionViewController,
                             animated: true,
                             completion: nil)
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardInterval.event))
        {
            if (self.viewModel.thirdPageViewModel.controlCardInterval.state == UserViewModel.ControlCard.State.editor)
            {
                self.viewModel.overLayCardViewModelTime.LoadInterval()
                
                self.present(self.overLayController.collectionViewController,
                             animated: true,
                             completion: nil)
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardTimesPerDay.event))
        {
            if (self.viewModel.thirdPageViewModel.controlCardTimesPerDay.state == UserViewModel.ControlCard.State.editor)
            {
                self.viewModel.overLayCardViewModelTime.LoadTextField()

                self.present(self.overLayController.collectionViewController, animated: true)
                {
                    self.overLayController.dayInputCell.textFieldInputController.textField.keyboardType = UIKeyboardType.numberPad
                    self.overLayController.dayInputCell.textFieldInputController.textField.becomeFirstResponder()
                }
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModelTime.confirmButtonViewModel.event))
        {
            if (self.viewModel.overLayCardViewModelTime.state == UserViewModel.OverLayCardViewModel.State.timeCompletion || self.viewModel.overLayCardViewModelTime.state == UserViewModel.OverLayCardViewModel.State.intervalCompletion || self.viewModel.overLayCardViewModelTime.state == UserViewModel.OverLayCardViewModel.State.textFieldCompletion)
            {
                if (viewModelEvent.newState == UserViewModel.ButtonCardViewModel.State.approval)
                {
                    self.dismiss(animated: true,
                                 completion: nil)
                    
                    self.viewModel.overLayCardViewModelTime.Idle()
                    
                    if (self.viewModel.overLayCardViewModelTime.state == UserViewModel.OverLayCardViewModel.State.default)
                    {
                        self.update()
                    }
                }
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModelTime.timeDatePickerInputViewModel.event))
        {
            let timeInterval = self.viewModel.overLayCardViewModelTime.timeDatePickerInputViewModel.timeInterval
            
            let aMoment = moment(timeInterval)

            self.viewModel.thirdPageViewModel.controlCardStartTime.display = aMoment.format("hh:mm a")
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModelTime.intervalDatePickerViewModel.event))
        {
            let timeInterval = self.viewModel.overLayCardViewModelTime.intervalDatePickerViewModel.timeInterval
            
            let hour = Int(timeInterval) / 3600
            let minute = (Int(timeInterval) % 3600) / 60
            
            var display = ""
            
            if (hour > 0)
            {
                display = String(hour) + " hour " + String(minute) + " min"
            }
            else
            {
                display = String(hour) + " hours " + String(minute) + " min"
            }
            
            self.viewModel.thirdPageViewModel.controlCardInterval.display = display
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModelTime.textFieldTimesPerdayViewModel.event))
        {
            let value = self.viewModel.overLayCardViewModelTime.textFieldTimesPerdayViewModel.value
            let display = String(value) + " x's"
            
            self.viewModel.thirdPageViewModel.controlCardTimesPerDay.display = display
        }
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel))
        {
            if (controllerEvent.operation == DynamicController.Event.Operation.bind)
            {
                self.viewModel.delegate = self
            }
            else
            {
                self.viewModel.delegate = nil
            }
        }
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
    {
        if (event.newState == DropFormViewModel.State.drop)
        {
            self.pageViewController.setViewControllers([self.firstPageController.collectionViewController],
                                                       direction: UIPageViewControllerNavigationDirection.reverse,
                                                       animated: true,
                                                       completion: nil)
        }
        else if (event.newState == DropFormViewModel.State.date)
        {
            if (event.oldState == DropFormViewModel.State.drop)
            {
                self.pageViewController.setViewControllers([self.secondPageController.collectionViewController],
                                                           direction: UIPageViewControllerNavigationDirection.forward,
                                                           animated: true,
                                                           completion: nil)
            }
            else if (event.oldState == DropFormViewModel.State.schedule)
            {
                self.pageViewController.setViewControllers([self.secondPageController.collectionViewController],
                                                           direction: UIPageViewControllerNavigationDirection.reverse,
                                                           animated: true,
                                                           completion: nil)
            }
        }
        else if (event.newState == DropFormViewModel.State.schedule)
        {
            if (event.oldState == DropFormViewModel.State.date)
            {
                self.pageViewController.setViewControllers([self.thirdPageController.collectionViewController],
                                                           direction: UIPageViewControllerNavigationDirection.forward,
                                                           animated: true,
                                                           completion: nil)
            }
            
            self.update()
        }
    }
    
    class FirstPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _labelControllerByViewModel = [LabelViewModel:LabelController]()
        private var _textFieldInputControllers = [TextFieldInputViewModel:TextFieldInputController]()
        private var _colorCardControllers = [ColorCardViewModel:ColorCardController]()
        @objc dynamic var viewModel : DropFormViewModel.FirstPageViewModel!
        
        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                    self._collectionViewController.collectionView!.dataSource = self
                    self._collectionViewController.collectionView!.delegate = self
                }
                
                let collectionViewController = self._collectionViewController!
                
                return collectionViewController
            }
        }
        
        var collectionViewFlowLayout : UICollectionViewFlowLayout
        {
            get
            {
                if (self._collectionViewFlowLayout == nil)
                {
                    self._collectionViewFlowLayout = UICollectionViewFlowLayout()
                    self._collectionViewFlowLayout.minimumLineSpacing = 0
                    self._collectionViewFlowLayout.minimumInteritemSpacing = 0
                }
                
                let collectionViewFlowLayout = self._collectionViewFlowLayout!
                
                return collectionViewFlowLayout
            }
        }

        override func viewDidLoad()
        {
            self.collectionViewController.collectionView!.backgroundColor = UIColor.white
        }
        
        override func render()
        {
            super.render()
            
            self.collectionViewController.collectionView!.reloadData()
        }
        
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: LabelViewModel.description())
            self.collectionViewController.collectionView!.register(TextFieldInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: TextFieldInputViewModel.description())
            self.collectionViewController.collectionView!.register(ColorCardController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: ColorCardViewModel.description())
        }
        
        override func unbind()
        {
            super.unbind()

            for labelController in self._labelControllerByViewModel.values
            {
                labelController.unbind()
            }
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int
        {
            return 2
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            var numberOfItemsInSection = 0
            
            if (self.viewModel != nil)
            {
                if (section == 0)
                {
                    numberOfItemsInSection = 3
                }
                else
                {
                    numberOfItemsInSection = self.viewModel.colorCardViewModels.count
                }
                
            }
            else
            {
                 numberOfItemsInSection = 0
            }
            
            return numberOfItemsInSection
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            if (indexPath.section == 0)
            {
                if (indexPath.item == 0 || indexPath.item == 2)
                {
                    let labelController = LabelController()
                    labelController.bind()
                    labelController.viewModel = self.viewModel.nameLabelViewModel
                    size = labelController.view.frame.size
                    labelController.unbind()
                }
                else if (indexPath.item == 1)
                {
                    let textFieldInputController = TextFieldInputController()
                    textFieldInputController.bind()
                    textFieldInputController.viewModel = self.viewModel.textFieldInputViewModel
                    size = textFieldInputController.view.frame.size
                    textFieldInputController.unbind()
                }
            }
            else
            {
                let colorCardController = ColorCardController()
                colorCardController.bind()
                let index = indexPath.item
                colorCardController.viewModel = self.viewModel.colorCardViewModels[index]
                size = colorCardController.view.frame.size
                colorCardController.unbind()
            }

            return size
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil
            
            if (indexPath.section == 0)
            {
                if (indexPath.item == 0 || indexPath.item == 2)
                {
                    let labelControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                                 for: indexPath) as! LabelController.CollectionCell
                    
                    if (indexPath.item == 0)
                    {
                        labelControllerCell.labelController.viewModel = self.viewModel.nameLabelViewModel
                        
                        self._labelControllerByViewModel[self.viewModel.nameLabelViewModel] = labelControllerCell.labelController
                    }
                    else
                    {
                        labelControllerCell.labelController.viewModel = self.viewModel.colorLabelViewModel
                        
                        self._labelControllerByViewModel[self.viewModel.colorLabelViewModel] = labelControllerCell.labelController
                    }
                    
                    cell = labelControllerCell
                }
                else if (indexPath.item == 1)
                {
                    let textFieldInputControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldInputViewModel.description(),
                                                                                          for: indexPath) as! TextFieldInputController.CollectionCell
                    textFieldInputControllerCell.textFieldInputController.viewModel = self.viewModel.textFieldInputViewModel
                    
                    self._textFieldInputControllers[self.viewModel.textFieldInputViewModel] = textFieldInputControllerCell.textFieldInputController
                    
                    cell = textFieldInputControllerCell
                }
            }
            else
            {
                let index = indexPath.item
                let colorCardViewModel = self.viewModel.colorCardViewModels[index]
                let colorCardControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCardViewModel.description(),
                                                                                 for: indexPath) as! ColorCardController.CollectionCell
                colorCardControllerCell.colorCardController.viewModel = colorCardViewModel

                self._colorCardControllers[colorCardViewModel] = colorCardControllerCell.colorCardController

                cell = colorCardControllerCell
            }

            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            let textFieldInputController = self._textFieldInputControllers[self.viewModel.textFieldInputViewModel]
            textFieldInputController?.textField.resignFirstResponder()

            if (indexPath.section == 1)
            {
                let selectedIndexPath = indexPath.row
                self.viewModel.toggle(at: selectedIndexPath)
            }

//            let labelController = self._labelControllerByViewModel[self.viewModel.nameLabelViewModel]
//            Able to access the controller anywhere in the code.
        }
    }
    
    class SecondPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _secondPageLabelControllerByViewModel = [LabelViewModel:LabelController]()
        private var _datePickerControllerByViewModel = [DatePickerInputViewModel:DatePickerInputController]()
        @objc dynamic var viewModel : DropFormViewModel.SecondPageViewModel!
        
        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                    self._collectionViewController.collectionView!.delegate = self
                    self._collectionViewController.collectionView!.dataSource = self
                }
                
                let collectionViewController = self._collectionViewController!
                
                return collectionViewController
            }
        }
        
        var collectionViewFlowLayout : UICollectionViewFlowLayout
        {
            get
            {
                if (self._collectionViewFlowLayout == nil)
                {
                    self._collectionViewFlowLayout = UICollectionViewFlowLayout()
                    self._collectionViewFlowLayout.minimumLineSpacing = 0
                    self._collectionViewFlowLayout.minimumInteritemSpacing = 0
                }
                
                let collectionViewFlowLayout = self._collectionViewFlowLayout!
                
                return collectionViewFlowLayout
            }
        }
        
        override func viewDidLoad()
        {
            self.collectionViewController.collectionView?.backgroundColor = UIColor.white
        }
        
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: LabelViewModel.description())
            self.collectionViewController.collectionView!.register(DatePickerInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: DatePickerInputViewModel.description())
        }
        
        override func unbind()
        {
            
        }
        
        override func render()
        {
            super.render()
            
            self.collectionViewController.collectionView!.reloadData()
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if (self.viewModel != nil)
            {
                return 4
            }
            else
            {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            if (indexPath.row == 0 || indexPath.row == 2)
            {
                let labelController = LabelController()
                labelController.bind()
                labelController.viewModel = self.viewModel.startDateLabelViewModel
                size = labelController.view.frame.size
                labelController.unbind()
            }
            else if (indexPath.row == 1 || indexPath.row == 3)
            {
                let datePickerInputController = DatePickerInputController()
                datePickerInputController.bind()
                datePickerInputController.viewModel = self.viewModel.startDatePickerInputViewModel
                size = datePickerInputController.view.frame.size
                datePickerInputController.unbind()
            }
            
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil

            if (indexPath.item == 0 || indexPath.item == 2)
            {
                let labelControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                             for: indexPath) as! LabelController.CollectionCell
                
                if (indexPath.row == 0)
                {
                    labelControllerCell.labelController.viewModel = self.viewModel.startDateLabelViewModel
                    
                    self._secondPageLabelControllerByViewModel[self.viewModel.startDateLabelViewModel] = labelControllerCell.labelController
                }
                else
                {
                    labelControllerCell.labelController.viewModel = self.viewModel.endDateLabelViewModel
                    
                    self._secondPageLabelControllerByViewModel[self.viewModel.endDateLabelViewModel] = labelControllerCell.labelController
                }
                
                cell = labelControllerCell
            }
            else if (indexPath.row == 1 || indexPath.row == 3)
            {
                let datePickerInputControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerInputViewModel.description(),
                                                                                       for: indexPath) as! DatePickerInputController.CollectionCell
                
                if (indexPath.row == 1)
                {
                    datePickerInputControllerCell.datePickerInputController.viewModel = self.viewModel.startDatePickerInputViewModel
                    
                    self._datePickerControllerByViewModel[self.viewModel.startDatePickerInputViewModel] = datePickerInputControllerCell.datePickerInputController
                }
                else
                {
                    datePickerInputControllerCell.datePickerInputController.viewModel = self.viewModel.endDatePickerInputViewModel
                    
                    self._datePickerControllerByViewModel[self.viewModel.endDatePickerInputViewModel] = datePickerInputControllerCell.datePickerInputController
                }
                
                cell = datePickerInputControllerCell
            }
            
            return cell
        }
    }
    
    class ThirdPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _startTimeCell : UserController.Control.CollectionCell!
        private var _intervalTimeCell : UserController.Control.CollectionCell!
        private var _timesPerDayCell : UserController.Control.CollectionCell!
        private var _labelCell : LabelController.CollectionCell!
        private var _staticLabelController = [LabelViewModel:LabelController]()
        private var _labelControllers = [LabelViewModel:LabelController]()
        @objc dynamic var viewModel : DropFormViewModel.ThirdPageViewModel!
        
        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                    self._collectionViewController.collectionView?.delegate = self
                    self._collectionViewController.collectionView?.dataSource = self
                }
                
                let collectionViewController = self._collectionViewController!

                return collectionViewController
            }
        }

        var collectionViewFlowLayout : UICollectionViewFlowLayout
        {
            get
            {
                if (self._collectionViewFlowLayout == nil)
                {
                    self._collectionViewFlowLayout = UICollectionViewFlowLayout()
                    self._collectionViewFlowLayout.minimumLineSpacing = 0
                    self._collectionViewFlowLayout.minimumInteritemSpacing = 0
                }

                let collectionViewFlowLayout = self._collectionViewFlowLayout!

                return collectionViewFlowLayout
            }
        }
        
        var startTimeCell : UserController.Control.CollectionCell
        {
            get
            {
                if (self._startTimeCell == nil)
                {
                    self._startTimeCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: UserViewModel.ControlCard.description(), for: IndexPath(item: 0, section: 0)) as? UserController.Control.CollectionCell
                }
                
                let startTimeCell = self._startTimeCell!
                
                return startTimeCell
            }
        }
        
        var intervalTimeCell : UserController.Control.CollectionCell
        {
            get
            {
                if (self._intervalTimeCell == nil)
                {
                    self._intervalTimeCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: UserViewModel.ControlCard.description(), for: IndexPath(item: 0, section: 1)) as? UserController.Control.CollectionCell
                }
                
                let intervalTimeCell = self._intervalTimeCell!
                
                return intervalTimeCell
            }
        }
        
        var timesPerDayCell : UserController.Control.CollectionCell
        {
            get
            {
                if (self._timesPerDayCell == nil)
                {
                    self._timesPerDayCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: UserViewModel.ControlCard.description(), for: IndexPath(item: 0, section: 2)) as? UserController.Control.CollectionCell
                }
                
                let timesPerDayCell = self._timesPerDayCell!
                
                return timesPerDayCell
            }
        }
        
        var labelCell : LabelController.CollectionCell
        {
            get
            {
                if (self._labelCell == nil)
                {
                    self._labelCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: "StaticLabelViewModel", for: IndexPath(item: 0, section: 3)) as? LabelController.CollectionCell
                }
                
                let labelCell = self._labelCell!
                
                return labelCell
            }
        }

        override func viewDidLoad()
        {
            self.collectionViewController.collectionView?.backgroundColor = UIColor.white
        }

        override func bind()
        {
            super.bind()

            self.collectionViewController.collectionView?.register(UserController.Control.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: UserViewModel.ControlCard.description())
            self.collectionViewController.collectionView?.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: "StaticLabelViewModel")
            self.collectionViewController.collectionView?.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: LabelViewModel.description())
        }

        override func unbind()
        {
            super.unbind()
        }

        override func render()
        {
            super.render()

            self.collectionViewController.collectionView?.reloadData()
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int
        {
            return 5
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            var numberOfItemsInSection = 0
            
            if (self.viewModel != nil)
            {
                if (section == 0 || section == 1 || section == 2 || section == 3)
                {
                    numberOfItemsInSection = 1
                }
                else
                {
                    numberOfItemsInSection = self.viewModel.labelViewModels.count
                }
            }
            else
            {
                numberOfItemsInSection = 0
            }
            
            return numberOfItemsInSection
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero

            if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2)
            {
                size.width = self.viewModel.controlCardStartTime.size.width
                size.height = self.viewModel.controlCardStartTime.size.height
            }
            else if (indexPath.section == 3)
            {
                size.width = self.viewModel.labelViewModel.size.width 
                size.height = self.viewModel.labelViewModel.size.height
            }
            else
            {
                let labelController = LabelController()
                labelController.bind()
                let index = indexPath.item
                labelController.viewModel = self.viewModel.labelViewModels[index]
                size = labelController.view.frame.size
                labelController.unbind()
            }

            return size
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil

            if (indexPath.section == 0)
            {
                cell = self.startTimeCell
            }
            else if (indexPath.section == 1)
            {
                cell = self.intervalTimeCell
            }
            else if (indexPath.section == 2)
            {
                cell = self.timesPerDayCell
            }
            else if (indexPath.section == 3)
            {
                cell = self.labelCell
                
                let viewModel = self.labelCell.labelController.viewModel!

                self._staticLabelController[viewModel] = self.labelCell.labelController
                
                let labelController = self._staticLabelController[viewModel]
                labelController!.view.frame.origin.x = 16
            }
            else
            {
                let index = indexPath.item
                let labelViewModel = self.viewModel.labelViewModels[index]
                let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                   for: indexPath) as! LabelController.CollectionCell
                labelCell.labelController.viewModel = labelViewModel
                labelViewModel.textAlignment = .left
                
                self._labelControllers[labelViewModel] = labelCell.labelController
                let labelControllers = self._labelControllers[labelViewModel]
                labelControllers!.label.font = UIFont.systemFont(ofSize: 24)
                labelControllers!.view.frame.origin.x = 16
                
                cell = labelCell
            }
            
            return cell
        }
    }
}

