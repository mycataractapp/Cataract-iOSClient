//
//  MainDashboardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class MainDashboardController : DynamicController
{
    private var _tabBarController : UITabBarController!
    private var _dropCardCollectionController : DropCardController!
    private var _appointmentCardCollectionController : AppointmentCardController.CollectionController!
    private var _contactCardController : ContactCardController!
    private var _faqCardCollectionController : FAQCardController.TableController!
    var dropFormController : DropFormController!
    var appointmentFormController : AppointmentFormController!
    var contactFormController : ContactFormController!
    private var _appointmentStore : DynamicStore.Collection<AppointmentModel>!
    private var _faqStore : DynamicStore.Collection<FAQModel>!
    private var _dropAddButtonController : UserController.AddButtonController!
    private var _appointmentAddButtonController : UserController.AddButtonController!
    private var _contactsAddButtonController : UserController.AddButtonController!
    var appointmentFormCardViewModels = [AppointmentCardViewModel]()
    var decodedArray = [AppointmentCardViewModel]()
    private var _url : URL!
    @objc dynamic var viewModel : MainDashboardViewModel!
    
    var url : URL
    {
        get
        {
            if (self._url == nil)
            {
                let fileManager : String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Haha").path

                self._url = URL(fileURLWithPath: fileManager)
            }
            
            let url = self._url!
            
            return url
        }
    }
//    func decode()
//    {
//        let defaults = UserDefaults.standard
//        let descriptionArray = defaults.array(forKey: "AppointmentArray") as! [String]
//
//            for id in descriptionArray
//            {
//
//                for appointmentViewModel in self.appointmentFormCardViewModels
//                {
//                    print("AA")
//
//                    
//                    if (id == appointmentViewModel.id)
//                    {
//                        print(appointmentViewModel, "AA")
//                    }
//                }
//            }
//    }
    
    
    override var tabBarController : UITabBarController
    {
        get
        {
            if (self._tabBarController == nil)
            {
                self._tabBarController = UITabBarController()
                self._tabBarController.viewControllers = [self.dropCardCollectionController, self.appointmentCardCollectionController, self.contactCardController, self.faqCardCollectionController]
            }
            
            let tabBarController = self._tabBarController!
            
            return tabBarController
        }
    }
    
    func onButtonSelected()
    {
//        self.tabBarController.present(self.dropFormController.pageViewController, animated: true, completion: nil)
    }
    
    var dropCardCollectionController : DropCardController
    {
        get
        {
            if (self._dropCardCollectionController == nil)
            {
                self._dropCardCollectionController = DropCardController()
                self._dropCardCollectionController.tabBarItem = UITabBarItem(title: "Drops",
                                                                             image: UIImage(contentsOfFile: Bundle.main.path(forResource: "Dose", ofType: "png")!),
                                                                             tag: 0)
            }
            
            let dropCardCollectionController = self._dropCardCollectionController!
            
            return dropCardCollectionController
        }
    }
    
    var appointmentCardCollectionController : AppointmentCardController.CollectionController
    {
        get
        {
            if (self._appointmentCardCollectionController == nil)
            {
               self._appointmentCardCollectionController = AppointmentCardController.CollectionController()
               self._appointmentCardCollectionController.tabBarItem = UITabBarItem(title: "Appointments",
                                                                                   image: UIImage(contentsOfFile: Bundle.main.path(forResource: "Calendar", ofType: "png")!),
                                                                                   tag: 0)
               self._appointmentCardCollectionController.tableViewController.tableView.contentInset = UIEdgeInsets(top: 0,
                                                                                               left: 0,
                                                                                               bottom: self.tabBarController.tabBar.frame.height,
                                                                                               right: 0)
            }
            
            let appointmentCardCollectionController = self._appointmentCardCollectionController!
            
            return appointmentCardCollectionController
        }
    }
    
    var contactCardController : ContactCardController
    {
        get
        {
            if (self._contactCardController == nil)
            {
                self._contactCardController = ContactCardController()
                self._contactCardController.tabBarItem = UITabBarItem(title: "Contacts",
                                                                      image: UIImage(contentsOfFile: Bundle.main.path(forResource: "Contact", ofType: "png")!),
                                                                      tag: 0)
            }
            
            let contactCardController = self._contactCardController!
            
            return contactCardController
        }
    }

    var faqCardCollectionController : FAQCardController.TableController
    {
        get
        {
            if (self._faqCardCollectionController == nil)
            {
                self._faqCardCollectionController = FAQCardController.TableController()
                self._faqCardCollectionController.tabBarItem = UITabBarItem(title: "FAQ",
                                                                            image: UIImage(contentsOfFile: Bundle.main.path(forResource: "Information", ofType: "png")!),
                                                                            tag: 0)
                self._faqCardCollectionController.tableViewController.tableView.contentInset = UIEdgeInsets(top: 0,
                                                                                        left: 0,
                                                                                        bottom: self.tabBarController.tabBar.frame.height,
                                                                                        right: 0)
            }
            
            let faqCardCollectionController = self._faqCardCollectionController!
            
            return faqCardCollectionController
        }
    }
    
    var appointmentStore : DynamicStore.Collection<AppointmentModel>
    {
        get
        {
            if (self._appointmentStore == nil)
            {
                self._appointmentStore = DynamicStore.Collection<AppointmentModel>()
            }
            
            let appointmentStore = self._appointmentStore!
            
            return appointmentStore
        }
    }
    
    var faqStore : DynamicStore.Collection<FAQModel>
    {
        get
        {
            if (self._faqStore == nil)
            {
                self._faqStore = DynamicStore.Collection<FAQModel>()
            }
            
            let faqStore = self._faqStore!
            
            return faqStore
        }
    }
    
    @objc var appointmentStoreRepresentable : DynamicStore
        {
        get
        {
            let appointmentStoreRepresentable = self.appointmentStore
            
            return appointmentStoreRepresentable
        }
    }
    
    @objc var faqStoreRepresentable : DynamicStore
    {
        get
        {
            let faqStoreRepresentable = self.faqStore
            
            return faqStoreRepresentable
        }
    }
    
    var dropAddButtonController : UserController.AddButtonController
    {
        get
        {
            if (self._dropAddButtonController == nil)
            {
                self._dropAddButtonController = UserController.AddButtonController()
            }
            
            let dropAddButtonController = self._dropAddButtonController!
            
            return dropAddButtonController
        }
    }
    
    var appointmentAddButtonController : UserController.AddButtonController
    {
        get
        {
            if (self._appointmentAddButtonController == nil)
            {
                self._appointmentAddButtonController = UserController.AddButtonController()
            }
            
            let appointmentAddButtonController = self._appointmentAddButtonController!
            
            return appointmentAddButtonController
        }
    }
    
    var contactsAddButtonController : UserController.AddButtonController
    {
        get
        {
            if (self._contactsAddButtonController == nil)
            {
                self._contactsAddButtonController = UserController.AddButtonController()
            }
            
            let contactsAddButtonController = self._contactsAddButtonController!
            
            return contactsAddButtonController
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.tabBarController.view)
        self.dropCardCollectionController.view.addSubview(self.dropAddButtonController.view)
        self.appointmentCardCollectionController.view.addSubview(self.appointmentAddButtonController.view)
        self.contactCardController.view.addSubview(self.contactsAddButtonController.view)
    }
    
    override func bind()
    {
        super.bind()
        
        self.appointmentCardCollectionController.bind()
        self.faqCardCollectionController.bind()
        self.dropAddButtonController.bind()
        self.appointmentAddButtonController.bind()
        self.contactsAddButtonController.bind()
        
        self.addObserver(self,
                         forKeyPath: "viewModel.dropAddButtonViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.appointmentAddButtonViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.contactAddButtonViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "viewModel.appointmentCardCollectionViewModel",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        
        self.addObserver(self,
                         forKeyPath: "viewModel.faqCardCollectionViewModel",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        self.addObserver(self,
                         forKeyPath: "faqStoreRepresentable.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.appointmentCardCollectionController.unbind()
        self.faqCardCollectionController.unbind()
        self.dropAddButtonController.unbind()
        self.appointmentAddButtonController.unbind()
        self.contactsAddButtonController.unbind()
        
        self.removeObserver(self, forKeyPath: "viewModel.dropAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.contactAddButtonViewModel.event")
        self.removeObserver(self, forKeyPath: "viewModel.appointmentCardCollectionViewModel")
        self.removeObserver(self, forKeyPath: "viewModel.faqCardCollectionViewModel")
        self.removeObserver(self, forKeyPath: "faqStoreRepresentable.event")
    }
 
    func write()
    {
        var jsonEncoder : JSONEncoder = JSONEncoder()
        var jsonData : Data = try! jsonEncoder.encode(self.appointmentFormCardViewModels)
        
        do
        {
            try jsonData.write(to: self.url)
        }
        catch
        {
            print(error, "QQ")
        }
    }
    
    func read()
    {
        if FileManager.default.fileExists(atPath: self.url.path)
        {
            var data : Data = try! Data(contentsOf: self.url)
            var jsonDecoder : [AppointmentCardViewModel] = try! JSONDecoder().decode([AppointmentCardViewModel].self, from: data)

            let appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: jsonDecoder)
            appointmentCardCollectionViewModel.itemSize = self.viewModel.appointmentCardCollectionViewModel.itemSize
            self.viewModel.appointmentCardCollectionViewModel = appointmentCardCollectionViewModel
        }

    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == "viewModel.appointmentAddButtonViewModel.event")
        {
            if (self.viewModel.appointmentAddButtonViewModel.state == UserViewModel.AddButtonViewModel.State.computation)
            {
                let footerPanelViewModel = FooterPanelViewModel(id: "")
                let firstPageViewModel = AppointmentFormViewModel.FirstPageViewModel()
                let secondPageViewModel = AppointmentFormViewModel.SecondPageViewModel()
                let appointmentInputViewModel = UserViewModel.AppointmentInputViewModel(id: "")

                var appointmentFormViewModel = AppointmentFormViewModel(footerPanelViewModel: footerPanelViewModel,
                                                                        firstPageViewModel: firstPageViewModel,
                                                                        secondPageViewModel: secondPageViewModel,
                                                                        appointmentInputViewModel: appointmentInputViewModel)
                self.appointmentFormController = AppointmentFormController()
                self.appointmentFormController.bind()
                appointmentFormViewModel.size = self.view.frame.size
                self.appointmentFormController.viewModel = appointmentFormViewModel

                self.appointmentFormController.viewModel.addObserver(self,
                                                                     forKeyPath: "event",
                                                                     options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                          NSKeyValueObservingOptions.initial]),
                                                                     context: nil)
                
                self.view.addSubview(self.appointmentFormController.view)
            }
        }
        if (kvoEvent.keyPath == "viewModel.dropAddButtonViewModel.event")
        {
            if (self.viewModel.dropAddButtonViewModel.state == UserViewModel.AddButtonViewModel.State.computation)
            {
                let firstPageViewModel = DropFormViewModel.FirstPageViewModel()
                let secondPageViewModel = DropFormViewModel.SecondPageViewModel()
                let thirdPageViewModel = DropFormViewModel.ThirdPageViewModel()
                let footerPanelViewModel = FooterPanelViewModel(id: "")
                let overLayCardViewModel = UserViewModel.OverLayCardViewModel(id: "")

                let dropFormViewModel = DropFormViewModel(firstPageViewModel: firstPageViewModel,
                                                          secondPageViewModel: secondPageViewModel,
                                                          thirdPageViewModel: thirdPageViewModel,
                                                          footerPanelViewModel: footerPanelViewModel,
                                                          overLayCardViewModel: overLayCardViewModel)

                self.dropFormController = DropFormController()
                self.dropFormController.carePlanStore = self.dropCardCollectionController.carePlanStore
                self.dropFormController.bind()
                dropFormViewModel.size = self.view.frame.size
                self.dropFormController.viewModel = dropFormViewModel
                self.dropFormController.viewModel.addObserver(self,
                                                              forKeyPath: "event",
                                                              options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                   NSKeyValueObservingOptions.initial]),
                                                              context: nil)

                self.view.addSubview(self.dropFormController.view)
            }
        }
        if (kvoEvent.keyPath == "viewModel.contactAddButtonViewModel.event")
        {
            if (self.viewModel.contactAddButtonViewModel.state == UserViewModel.AddButtonViewModel.State.computation)
            {
                let footerPanelViewModel = FooterPanelViewModel(id: "")
                var contactFormViewModel = ContactFormViewModel(footerPanelViewModel: footerPanelViewModel)
                
                self.contactFormController = ContactFormController()
                self.contactFormController.bind()
                contactFormViewModel.size = self.view.frame.size
                self.contactFormController.viewModel = contactFormViewModel
                self.contactFormController.viewModel.addObserver(self,
                                                                 forKeyPath: "event",
                                                                 options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                      NSKeyValueObservingOptions.initial]),
                                                                 context: nil)
                
                self.view.addSubview(self.contactFormController.view)
            }
        }
        if (kvoEvent.keyPath == "event")
        {
            if (self.dropFormController != nil && self.dropFormController.viewModel != nil)
            {
                if (self.dropFormController.viewModel.state == DropFormViewModel.State.completion || self.dropFormController.viewModel.state == DropFormViewModel.State.cancellation)
                {
                    self.dropFormController.viewModel.removeObserver(self, forKeyPath: "event")
                    self.dropFormController.unbind()
                    self.dropFormController.view.removeFromSuperview()
                    self.dropFormController.viewModel = nil
                }
            }
            if (self.appointmentFormController != nil && self.appointmentFormController.viewModel != nil)
            {                
                if (self.appointmentFormController.viewModel.state == AppointmentFormViewModel.State.completion || self.appointmentFormController.viewModel.state == AppointmentFormViewModel.State.cancellation)
                {
                    self.appointmentFormCardViewModels.append(contentsOf: self.appointmentFormController.appointmentCardViewModels)
                    
                    self.write()
                    
                    let appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: self.appointmentFormCardViewModels)
                    appointmentCardCollectionViewModel.itemSize = self.viewModel.appointmentCardCollectionViewModel.itemSize
                    self.viewModel.appointmentCardCollectionViewModel = appointmentCardCollectionViewModel
                    
                    self.appointmentFormController.viewModel.removeObserver(self, forKeyPath: "event")
                    self.appointmentFormController.unbind()
                    self.appointmentFormController.view.removeFromSuperview()
                    self.appointmentFormController.viewModel = nil
                }
            }
            if (self.contactFormController != nil && self.contactFormController.viewModel != nil)
            {
                if (self.contactFormController.viewModel.state == ContactFormViewModel.State.completion || self.contactFormController.viewModel.state == ContactFormViewModel.State.cancellation)
                {
                    self.contactCardController.ockContacts.append(contentsOf: self.contactFormController.ockContacts)
                    
                    self.contactFormController.viewModel.removeObserver(self, forKeyPath: "event")
                    self.contactFormController.unbind()
                    self.contactFormController.view.removeFromSuperview()
                    self.contactFormController.viewModel = nil
                }
            }
        }
        if (kvoEvent.keyPath == "viewModel.appointmentCardCollectionViewModel")
        {
            self.appointmentCardCollectionController.viewModel = self.viewModel.appointmentCardCollectionViewModel
        }
        if (kvoEvent.keyPath == "viewModel.faqCardCollectionViewModel")
        {
            self.faqCardCollectionController.viewModel = self.viewModel.faqCardCollectionViewModel
        }
        if (kvoEvent.keyPath == "faqStoreRepresentable.event")
        {
            var faqCardViewModels = [FAQCardViewModel]()

            for (id, faqModel) in self.faqStore._retrieveAll_()
            {
                let faqCardViewModel = FAQCardViewModel(id: id,
                                                        question: faqModel.question,
                                                        answer: faqModel.answer)
                faqCardViewModels.append(faqCardViewModel)
            }

            let faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: faqCardViewModels)
            faqCardCollectionViewModel.itemSize = self.viewModel.faqCardCollectionViewModel.itemSize

            self.viewModel.faqCardCollectionViewModel = faqCardCollectionViewModel
        }
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.viewModel.dropAddButtonViewModel.size.width = 80
        self.viewModel.dropAddButtonViewModel.size.height = self.viewModel.dropAddButtonViewModel.size.width
        self.dropAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.dropAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
        
        self.viewModel.appointmentAddButtonViewModel.size.width = 80
        self.viewModel.appointmentAddButtonViewModel.size.height = self.viewModel.appointmentAddButtonViewModel.size.width
        self.appointmentAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.appointmentAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
        
        self.viewModel.contactAddButtonViewModel.size.width = 80
        self.viewModel.contactAddButtonViewModel.size.height = self.viewModel.contactAddButtonViewModel.size.width
        self.contactsAddButtonController.view.frame.origin.x = self.view.frame.size.width - 110
        self.contactsAddButtonController.view.frame.origin.y = self.view.frame.size.height - 230
                    
        self.viewModel.appointmentCardCollectionViewModel.itemSize = CGSize(width: self.view.frame.width,
                                                                            height: 200)

        self.viewModel.faqCardCollectionViewModel.itemSize = CGSize(width: self.view.frame.width,
                                                                    height: 300)
        
        //        self.viewModel.appointmentCardCollectionViewModel = self.viewModel.appointmentCardCollectionViewModel
        //        self.viewModel.faqCardCollectionViewModel = self.viewModel.faqCardCollectionViewModel
        
        self.dropAddButtonController.viewModel = self.viewModel.dropAddButtonViewModel
        self.appointmentAddButtonController.viewModel = self.viewModel.appointmentAddButtonViewModel
        self.contactsAddButtonController.viewModel = self.viewModel.contactAddButtonViewModel
    }

//    override var viewModelEventKeyPaths: Set<String>
//    {
//        get
//        {
//            var viewModelEventKeyPaths = super.viewModelEventKeyPaths
//            viewModelEventKeyPaths = viewModelEventKeyPaths.union(Set<String>([DynamicKVO.keyPath(\MainDashboardController.viewModel.appointmentAddButtonViewModel.event),
//                                                      DynamicKVO.keyPath(\MainDashboardController.viewModel.appointmentFormViewModel.footerPanelViewModel.event)]))
//
//            return viewModelEventKeyPaths
//        }
//    }
//
//    override func observeViewModel(for viewModelEvent: DynamicViewModel.Event, kvoEvent: DynamicKVO.Event)
//    {
//        if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.viewModel.appointmentAddButtonViewModel.event))
//        {
//            if (self.viewModel.appointmentAddButtonViewModel.state == UserViewModel.AddButtonViewModel.State.computation)
//            {
//                self.appointmentFormController.viewModel = self.viewModel.appointmentFormViewModel
//                self.view.addSubview(self.appointmentFormController.view)
//            }
//        }
//        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.viewModel.appointmentFormViewModel.footerPanelViewModel.event))
//        {
//            if (self.viewModel.appointmentFormViewModel.footerPanelViewModel.state == FooterPanelViewModel.State.right)
//            {
//                print("HERE", self.viewModel.appointmentFormViewModel.state)
//
//                if (self.viewModel.appointmentFormViewModel.state == AppointmentFormViewModel.State.completion)
//                {
//                    print("THERE")
//
//                    self.appointmentFormController.view.removeFromSuperview()
//                }
//            }
//        }
//    }
    
//    override var controllerEventKeyPaths: Set<String>
//    {
//        get
//        {
//            var controllerEventKeyPaths = Set<String>([DynamicKVO.keyPath(\MainDashboardController.viewModel.faqCardCollectionViewModel),
//                                                       DynamicKVO.keyPath(\MainDashboardController.viewModel.appointmentCardCollectionViewModel)])
//            controllerEventKeyPaths = controllerEventKeyPaths.union(super.controllerEventKeyPaths)
//
//            return controllerEventKeyPaths
//        }
//    }
    
//    override var storeEventKeyPaths: Set<String>
//    {
//        get
//        {
//            let storeEventKeyPaths = super.storeEventKeyPaths.union([DynamicKVO.keyPath(\MainDashboardController.faqStoreRepresentable.event),
//                                                                     DynamicKVO.keyPath(\MainDashboardController.appointmentStoreRepresentable.event)])
//            return storeEventKeyPaths
//        }
//    }
    
//          Observe for the updated collectionViewModel.
//    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
//    {
//        if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.viewModel.appointmentCardCollectionViewModel))
//        {
//            self.appointmentCardCollectionController.viewModel = self.viewModel.appointmentCardCollectionViewModel
//        }
//        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.viewModel.faqCardCollectionViewModel))
//        {
//            self.faqCardCollectionController.viewModel = self.viewModel.faqCardCollectionViewModel
//        }
//    }
    
//    override func observeStore(for storeEvent: DynamicStore.Event, kvoEvent: DynamicKVO.Event)
//    {
//        if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.faqStoreRepresentable.event))
//        {
//            if (storeEvent.operation == DynamicStore.Event.Operation.load)
//            {
//                let faqModels = storeEvent.models as! [FAQModel]
//                var faqCardViewModels = [FAQCardViewModel]()
//
//                for faqModel in faqModels
//                {
//                    let faqCardViewModel = FAQCardViewModel(id: faqModel.id,
//                                                            question: faqModel.question,
//                                                            answer: faqModel.answer)
//                    faqCardViewModels.append(faqCardViewModel)
//                }
//
//                let faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: faqCardViewModels)
//
//                if (self.viewModel != nil)
//                {
//                    faqCardCollectionViewModel.itemSize = self.viewModel.faqCardCollectionViewModel.itemSize
//                }
//
////                Update the collectionViewModel.
//                self.viewModel.faqCardCollectionViewModel = faqCardCollectionViewModel
//            }
//        }
//        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.appointmentStoreRepresentable.event))
//        {
//            if (storeEvent.operation == DynamicStore.Event.Operation.insert)
//            {
//                let appointmentModels = storeEvent.models as! [AppointmentModel]
//                var appointmentCardViewModels = [AppointmentCardViewModel]()
//
//                for appointmentModel in appointmentModels
//                {
//                    let appointmentCardViewModel = AppointmentCardViewModel(title: appointmentModel.title,
//                                                                            date: appointmentModel.date,
//                                                                            time: appointmentModel.time,
//                                                                            id: appointmentModel.description)
//
//                    appointmentCardViewModels.append(appointmentCardViewModel)
//                }
//
//                let appointmentCardCollectionViewModel = AppointmentCardViewModel.CollectionViewModel(appointmentCardViewModels: appointmentCardViewModels)
//
//                if (self.viewModel != nil)
//                {
//                    appointmentCardCollectionViewModel.itemSize = self.viewModel.appointmentCardCollectionViewModel.itemSize
//                }
//
//                self.viewModel.appointmentCardCollectionViewModel = appointmentCardCollectionViewModel
//            }
//        }
//    }
    
    func loadAllStores()
    {
        self.faqStore.load(FAQOperation.GetFAQModelsQuery())
//        self.appointmentStore.load(AppointmentOperation.GetAppointmentModelsQuery())
    }
}
