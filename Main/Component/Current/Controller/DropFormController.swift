//
//  DropFormController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftMoment
import CareKit
import UserNotifications

class DropFormController : DynamicController, DynamicViewModelDelegate
{
    private var _pageViewController : UIPageViewController!
    private var _firstPageController : DropFormController.FirstPageController!
    private var _secondPageController : DropFormController.SecondPageController!
    private var _thirdPageController : DropFormController.ThirdPageController!
    private var _footerPanelController : FooterPanelController!
    private var _overLayController : UserController.OverLayController!
    private var _carePlanStore : CarePlanStore!
    private var _timeStore : DynamicStore.Collection<TimeModel>!
    var dropModels = [DropModel]()
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
    
    var carePlanStore : CarePlanStore
    {
        get
        {
            if (self._carePlanStore == nil)
            {
                self._carePlanStore = CarePlanStore()
            }
            
            let carePlanStore = self._carePlanStore!
                        
            return carePlanStore
        }
        set (newValue)
        {
            self._carePlanStore = newValue
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
            if (self.viewModel.overLayCardViewModel.state == UserViewModel.OverLayCardViewModel.State.textFieldCompletion)
            {
                self.overLayController.collectionViewController.collectionView!.scrollToItem(at: IndexPath(item: 2,
                                                                                                           section: 0),
                                                                                             at: UICollectionViewScrollPosition.bottom,
                                                                                             animated: true)
            }
        }
    }
    
    override func render()
    {
        super.render()
                
        self.view.frame.size = self.viewModel.size
                        
        self.viewModel.footerPanelViewModel.size.width = self.view.frame.size.width
        self.viewModel.footerPanelViewModel.size.height = 90

        self.pageViewController.view.frame.size.height = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height
        
        self.viewModel.firstPageViewModel.nameLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.nameLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 5.5

        self.viewModel.firstPageViewModel.colorLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.colorLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 5.5

        self.viewModel.firstPageViewModel.textFieldInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.textFieldInputViewModel.size.height = self.pageViewController.view.frame.size.height / 5.5
        
        for colorCardviewModel in self.viewModel.firstPageViewModel.colorCardViewModels
        {
            colorCardviewModel.size.width = self.pageViewController.view.frame.size.width / 4
            colorCardviewModel.size.height = self.pageViewController.view.frame.size.height / 5.5
        }
        
        self.viewModel.secondPageViewModel.startDateLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.startDateLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 4.5

        self.viewModel.secondPageViewModel.endDateLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.endDateLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 4.5

        self.viewModel.secondPageViewModel.startDatePickerInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.startDatePickerInputViewModel.size.height = self.pageViewController.view.frame.size.height / 4.5

        self.viewModel.secondPageViewModel.endDatePickerInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.endDatePickerInputViewModel.size.height = self.pageViewController.view.frame.size.height / 4.5
        
        self.viewModel.thirdPageViewModel.controlCardStartTime.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardStartTime.size.height = 100

        self.viewModel.thirdPageViewModel.controlCardInterval.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardInterval.size.height = 100

        self.viewModel.thirdPageViewModel.controlCardTimesPerDay.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardTimesPerDay.size.height = 100

        self.viewModel.thirdPageViewModel.labelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.labelViewModel.size.height = 50
        
        self.viewModel.overLayCardViewModel.timeDatePickerInputViewModel.size.width = self.view.frame.size.width
        self.viewModel.overLayCardViewModel.timeDatePickerInputViewModel.size.height = 130
        
        self.viewModel.overLayCardViewModel.intervalDatePickerViewModel.size.width = self.view.frame.size.width
        self.viewModel.overLayCardViewModel.intervalDatePickerViewModel.size.height = 130
        
        self.viewModel.overLayCardViewModel.textFieldTimesPerdayViewModel.size.width = self.view.frame.size.width
        self.viewModel.overLayCardViewModel.textFieldTimesPerdayViewModel.size.height = 130
        
        self.viewModel.overLayCardViewModel.confirmButtonViewModel.size.width = self.view.frame.size.width
        self.viewModel.overLayCardViewModel.confirmButtonViewModel.size.height = 100
        
        self.viewModel.overLayCardViewModel.size = self.viewModel.size
        
        self.footerPanelController.view.frame.origin.y = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height
        self.footerPanelController.viewModel = self.viewModel.footerPanelViewModel
        
        self.firstPageController.viewModel = self.viewModel.firstPageViewModel
        self.secondPageController.viewModel = self.viewModel.secondPageViewModel
        self.thirdPageController.viewModel = self.viewModel.thirdPageViewModel
        self.overLayController.viewModel = self.viewModel.overLayCardViewModel
    }
    
    func update()
    {
        var timeInterval = self.viewModel.overLayCardViewModel.timeDatePickerInputViewModel.timeInterval
        let timesPerDay = Int(self.viewModel.overLayCardViewModel.textFieldTimesPerdayViewModel.value)!
        let interval = self.viewModel.overLayCardViewModel.intervalDatePickerViewModel.timeInterval
        
        let duration = Duration(value: interval)
        
        var labelViewModels = [LabelViewModel]()

        for _ in 0...timesPerDay - 1
        {
            let swiftMoment = moment(timeInterval)
            
            let colorCardViewModel = ColorCardViewModel(redValue: 0, greenValue: 0, blueValue: 0, alphaValue: 1)
            let labelViewModel = LabelViewModel(text: swiftMoment.format("hh:mm a"),
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
            
            timeInterval = swiftMoment.add(duration).date.timeIntervalSince1970
        }
        
        self.viewModel.thirdPageViewModel.labelViewModels = labelViewModels
        
        self.thirdPageController.collectionViewController.collectionView!.reloadData()
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
                
                self.thirdPageController.collectionViewController.collectionView!.reloadData()
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
                                                                               DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModel.confirmButtonViewModel.event),
                                                                               DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModel.timeDatePickerInputViewModel.event),
                                                                               DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModel.intervalDatePickerViewModel.event),
                                                                               DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModel.textFieldTimesPerdayViewModel.event)]))
            
            return viewModelEventKeyPaths
        }
    }
    
    override func observeViewModel(for viewModelEvent: DynamicViewModel.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.footerPanelViewModel.event))
        {
            if (self.viewModel.footerPanelViewModel.state == FooterPanelViewModel.State.left)
            {
                if (self.viewModel.state == DropFormViewModel.State.drop)
                {
                    self.viewModel.exit()
                }
                else if (self.viewModel.state == DropFormViewModel.State.date)
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
                    let startDate = self.viewModel.secondPageViewModel.startDatePickerInputViewModel.timeInterval
                    let endDate = self.viewModel.secondPageViewModel.endDatePickerInputViewModel.timeInterval
                    let title = self.viewModel.firstPageViewModel.textFieldInputViewModel.value

                    let startDateTimeModel = TimeModel(interval: startDate, identifier: "")
                    let endDateTimeModel = TimeModel(interval: endDate, identifier: "")

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
                    
                    var timeInterval = self.viewModel.overLayCardViewModel.timeDatePickerInputViewModel.timeInterval
                    let timesPerDay = Int(self.viewModel.overLayCardViewModel.textFieldTimesPerdayViewModel.value)!
                    let interval = self.viewModel.overLayCardViewModel.intervalDatePickerViewModel.timeInterval
                    
                    var timeModels = [TimeModel]()

                    for _ in 0...timesPerDay - 1
                    {
                        let timeModel = TimeModel(interval: timeInterval, identifier: UUID().uuidString)
                        timeModels.append(timeModel)
                        
                        timeInterval = timeInterval + interval
                    }
                    
                    let dropModel = DropModel(title: title,
                                              colorModel: colorModel,
                                              startTimeModel: startDateTimeModel,
                                              endTimeModel: endDateTimeModel,
                                              frequencyTimeModels: timeModels)
                    
                    self.dropModels.append(dropModel)
                    
                    let scheduleStartDate = Calendar.current.dateComponents([.year, .month, .day],
                                                                            from: Date(timeIntervalSince1970: startDateTimeModel.interval))
                    let scheduleEndDate = Calendar.current.dateComponents([.year, .month, .day],
                                                                          from: Date(timeIntervalSince1970: endDateTimeModel.interval))
                    let schedule = OCKCareSchedule.dailySchedule(withStartDate: scheduleStartDate,
                                                                 occurrencesPerDay: UInt(self.viewModel.thirdPageViewModel.labelViewModels.count),
                                                                 daysToSkip: 0,
                                                                 endDate: scheduleEndDate)
                    let ockCarePlanActivity = OCKCarePlanActivity(identifier: dropModel.title,
                                                                  groupIdentifier: "",
                                                                  type: .intervention,
                                                                  title: dropModel.title,
                                                                  text: "",
                                                                  tintColor: dropModel.colorModel.uiColor,
                                                                  instructions: "",
                                                                  imageURL: nil,
                                                                  schedule: schedule,
                                                                  resultResettable: false,
                                                                  userInfo: nil)

                    self.carePlanStore.ockCarePlanStore.add(ockCarePlanActivity)
                    { (isCompleted, error) in
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .none
                    dateFormatter.timeStyle = .short

                    let notificationStartDate = Date(timeIntervalSince1970: startDateTimeModel.interval)
                    var startDateComponents = Calendar.current.dateComponents([Calendar.Component.year,
                                                                               Calendar.Component.month,
                                                                               Calendar.Component.day],
                                                                              from: notificationStartDate)
                    
                    for timeModel in timeModels
                    {
                        let dropTime = Date(timeIntervalSince1970: timeModel.interval)

                        var timeComponents = Calendar.current.dateComponents([Calendar.Component.hour,
                                                                              Calendar.Component.minute],
                                                                             from: dropTime)

                        var dateComponents = DateComponents()
                        dateComponents.year = startDateComponents.year
                        dateComponents.month = startDateComponents.month
                        dateComponents.day = startDateComponents.day
                        dateComponents.hour = timeComponents.hour
                        dateComponents.minute = timeComponents.minute

                        let content = UNMutableNotificationContent()
                        let dateString = dateFormatter.string(from: dropTime)
                        content.title = title
                        content.body = "Time is " + dateString + ", take " + content.title + "."
                        content.sound = UNNotificationSound.default()

                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                        let request = UNNotificationRequest(identifier: timeModel.identifier,
                                                            content: content,
                                                            trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request)
                        { (error) in

                        }
                    }
                
                    self.viewModel.create()
                }
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardStartTime.event))
        {
            if (self.viewModel.thirdPageViewModel.controlCardStartTime.state == UserViewModel.ControlCard.State.editor)
            {
                self.viewModel.overLayCardViewModel.LoadTime()
                
                self.present(self.overLayController.collectionViewController,
                             animated: true,
                             completion: nil)
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardInterval.event))
        {
            if (self.viewModel.thirdPageViewModel.controlCardInterval.state == UserViewModel.ControlCard.State.editor)
            {
                self.viewModel.overLayCardViewModel.LoadInterval()
                
                self.present(self.overLayController.collectionViewController,
                             animated: true,
                             completion: nil)
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.thirdPageViewModel.controlCardTimesPerDay.event))
        {
            if (self.viewModel.thirdPageViewModel.controlCardTimesPerDay.state == UserViewModel.ControlCard.State.editor)
            {
                self.viewModel.overLayCardViewModel.LoadTextField()

                self.present(self.overLayController.collectionViewController, animated: true)
                {
                    self.overLayController.dayInputCell.textFieldInputController.textField.keyboardType = UIKeyboardType.numberPad
                    self.overLayController.dayInputCell.textFieldInputController.textField.becomeFirstResponder()
                }
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModel.confirmButtonViewModel.event))
        {
            if (self.viewModel.overLayCardViewModel.state == UserViewModel.OverLayCardViewModel.State.timeCompletion || self.viewModel.overLayCardViewModel.state == UserViewModel.OverLayCardViewModel.State.intervalCompletion || self.viewModel.overLayCardViewModel.state == UserViewModel.OverLayCardViewModel.State.textFieldCompletion)
            {
                if (viewModelEvent.newState == UserViewModel.ButtonCardViewModel.State.approval)
                {
                    self.dismiss(animated: true,
                                 completion: nil)
                    
                    self.viewModel.overLayCardViewModel.Idle()
                    
                    if (self.viewModel.overLayCardViewModel.state == UserViewModel.OverLayCardViewModel.State.default)
                    {
                        self.update()
                    }
                }
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModel.timeDatePickerInputViewModel.event))
        {
            let timeInterval = self.viewModel.overLayCardViewModel.timeDatePickerInputViewModel.timeInterval
            
            let aMoment = moment(timeInterval)
            
            self.viewModel.thirdPageViewModel.controlCardStartTime.display = aMoment.format("hh:mm a")
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModel.intervalDatePickerViewModel.event))
        {
            let timeInterval = self.viewModel.overLayCardViewModel.intervalDatePickerViewModel.timeInterval
            
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
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.overLayCardViewModel.textFieldTimesPerdayViewModel.event))
        {
            let value = self.viewModel.overLayCardViewModel.textFieldTimesPerdayViewModel.value
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
        if (event.newState == DropFormViewModel.State.cancellation)
        {
            self.view.removeFromSuperview()
        }
        else if (event.newState == DropFormViewModel.State.drop)
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
            self.pageViewController.setViewControllers([self.thirdPageController.collectionViewController],
                                                       direction: UIPageViewControllerNavigationDirection.forward,
                                                       animated: true,
                                                       completion: nil)
            
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
//        private var _labelControllerByCell = [UICollectionViewCell:LabelController]()
//        private var _textControllerByCell = [UICollectionViewCell:TextFieldInputController]()
//        private var _colorControllerByCell = [UICollectionViewCell:ColorCardController]()
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
            self.view.addSubview(self.collectionViewController.collectionView!)
            self.collectionViewController.collectionView!.backgroundColor = UIColor.white
        }
        
//        func labelController(by cell: UICollectionViewCell) -> LabelController
//        {
//            var labelController : LabelController! = nil
//
//            if (self._labelControllerByCell.keys.contains(cell))
//            {
//                labelController = self._labelControllerByCell[cell]
//            }
//            else
//            {
//                labelController = LabelController()
//                labelController.bind()
//
//                cell.addSubview(labelController.view)
//                cell.autoresizesSubviews = false
//                self._labelControllerByCell[cell] = labelController
//            }
//
//            return labelController
//        }
//
//        func textController(by cell: UICollectionViewCell) -> TextFieldInputController
//        {
//            var textFieldInputController : TextFieldInputController! = nil
//
//            if (self._textControllerByCell.keys.contains(cell))
//            {
//                textFieldInputController = self._textControllerByCell[cell]
//            }
//            else
//            {
//                textFieldInputController = TextFieldInputController()
//                textFieldInputController.bind()
//
//                cell.addSubview(textFieldInputController.view)
//                cell.autoresizesSubviews = false
//                self._textControllerByCell[cell] = textFieldInputController
//            }
//
//            return textFieldInputController
//        }
//
//        func colorController(by cell: UICollectionViewCell) -> ColorCardController
//        {
//            var colorCardController : ColorCardController! = nil
//
//            if (self._colorControllerByCell.keys.contains(cell))
//            {
//                colorCardController = self._colorControllerByCell[cell]
//            }
//            else
//            {
//                colorCardController = ColorCardController()
//                colorCardController.bind()
//
//                cell.addSubview(colorCardController.view)
//                cell.autoresizesSubviews = false
//                self._colorControllerByCell[cell] = colorCardController
//            }
//
//            return colorCardController
//        }
        
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
            
            for textFieldInputController in self._textFieldInputControllers.values
            {
                textFieldInputController.unbind()
            }
            
            for colorCardController in self._colorCardControllers.values
            {
                colorCardController.unbind()
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
                colorCardController.viewModel = self.viewModel.colorCardViewModels[indexPath.item]
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
                let colorCardViewModel = self.viewModel.colorCardViewModels[indexPath.item]
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
        }
    }
    
    class SecondPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _secondPageLabelControllerByViewModel = [LabelViewModel:LabelController]()
        private var _datePickerControllerByViewModel = [DatePickerInputViewModel:DatePickerInputController]()
        private var _labelControllerByCell = [UICollectionViewCell:LabelController]()
        private var _datePickerInputControllerByCell = [UICollectionViewCell:DatePickerInputController]()
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
        
        func labelController(by cell: UICollectionViewCell) -> LabelController
        {
            var labelController : LabelController! = nil
            
            if (self._labelControllerByCell.keys.contains(cell))
            {
                labelController = self._labelControllerByCell[cell]
            }
            else
            {
                labelController = LabelController()
                labelController.bind()
                
                cell.addSubview(labelController.view)
                cell.autoresizesSubviews = false
                self._labelControllerByCell[cell] = labelController
            }
            
            return labelController
        }
        
        func datePickerController(by cell: UICollectionViewCell) -> DatePickerInputController
        {
            var datePickerController : DatePickerInputController! = nil
            
            if (self._datePickerInputControllerByCell.keys.contains(cell))
            {
                datePickerController = self._datePickerInputControllerByCell[cell]
            }
            else
            {
                datePickerController = DatePickerInputController()
                datePickerController.bind()
                
                cell.addSubview(datePickerController.view)
                cell.autoresizesSubviews = false
                self._datePickerInputControllerByCell[cell] = datePickerController
            }
            
            return datePickerController
        }
            
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.description())
        }
        
        override func unbind()
        {
            for labelController in self._secondPageLabelControllerByViewModel.values
            {
                labelController.unbind()
            }
            
            for datePickerController in self._datePickerControllerByViewModel.values
            {
                datePickerController.unbind()
            }
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
                if (indexPath.row == 0)
                {
                    let viewModel = self.viewModel.startDateLabelViewModel
                    viewModel.size = self.viewModel.startDateLabelViewModel.size
                    
                    cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
                    
                    let labelController = self.labelController(by: cell)
                    labelController.viewModel = viewModel
                    
                    
//                    self._secondPageLabelControllerByViewModel[self.viewModel.startDateLabelViewModel] = labelControllerCell.labelController
                }
                else
                {
                    let viewModel = self.viewModel.endDateLabelViewModel
                    viewModel.size = self.viewModel.endDateLabelViewModel.size
                    
                    cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
                    
                    let labelController = self.labelController(by: cell)
                    labelController.viewModel = viewModel
                    
//                    self._secondPageLabelControllerByViewModel[self.viewModel.endDateLabelViewModel] = labelControllerCell.labelController
                }
            }
            else if (indexPath.row == 1 || indexPath.row == 3)
            {
                if (indexPath.row == 1)
                {
                    let viewModel = self.viewModel.startDatePickerInputViewModel
                    viewModel.size = self.viewModel.startDatePickerInputViewModel.size
                    
                    cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)

                    let datePickerInputController = self.datePickerController(by: cell)
                    datePickerInputController.viewModel = viewModel
                    
//                    self._datePickerControllerByViewModel[self.viewModel.startDatePickerInputViewModel] = datePickerInputControllerCell.datePickerInputController
                }
                else
                {
                    let viewModel = self.viewModel.endDatePickerInputViewModel
                    viewModel.size = self.viewModel.endDatePickerInputViewModel.size
                    
                    cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)

                    let datePickerInputController = self.datePickerController(by: cell)
                    datePickerInputController.viewModel = viewModel
                    
//                    self._datePickerControllerByViewModel[self.viewModel.endDatePickerInputViewModel] = datePickerInputControllerCell.datePickerInputController
                }
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
                    self._startTimeCell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UserViewModel.ControlCard.description(), for: IndexPath(item: 0, section: 0)) as? UserController.Control.CollectionCell
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
            self.view.addSubview(self.collectionViewController.collectionView!)
        }

        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(UserController.Control.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: UserViewModel.ControlCard.description())
            self.collectionViewController.collectionView!.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: "StaticLabelViewModel")
            self.collectionViewController.collectionView!.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: LabelViewModel.description())
        }

        override func unbind()
        {
            super.unbind()
        }

        override func render()
        {
            super.render()
            
            self.startTimeCell.control.viewModel = self.viewModel.controlCardStartTime
            self.intervalTimeCell.control.viewModel = self.viewModel.controlCardInterval
            self.timesPerDayCell.control.viewModel = self.viewModel.controlCardTimesPerDay
            self.labelCell.labelController.viewModel = self.viewModel.labelViewModel
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
                
                let viewModel = self.viewModel.labelViewModel
                viewModel.textAlignment = .center
            }
            else
            {
                let index = indexPath.item
                let labelViewModel = self.viewModel.labelViewModels[index]
                let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                   for: indexPath) as! LabelController.CollectionCell
                labelCell.labelController.viewModel = labelViewModel
                labelViewModel.textAlignment = .center
                
                self._labelControllers[labelViewModel] = labelCell.labelController
                let labelControllers = self._labelControllers[labelViewModel]
                labelControllers!.label.font = UIFont.systemFont(ofSize: 24)
                
                cell = labelCell
            }
            
            return cell
        }
    }
}

