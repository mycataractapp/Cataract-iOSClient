//
//  DynamicStore.swift
//  Pacific
//
//  Created by Minh Nguyen on 8/3/18.
//  Copyright © 2018 Minh Nguyen. All rights reserved.
//

import Foundation

class DynamicStore : NSObject
{
    private var _event : DynamicStore.Event!
    private var _mutation : DynamicMutation?
    private var _queue = DispatchQueue(label: "dynamic.store.queue")
    
    override init()
    {
        self._mutation = nil
        
        super.init()
    }
    
    init(mutation: DynamicMutation)
    {
        self._mutation = mutation
        
        super.init()
    }
    
    @objc var event : DynamicStore.Event!
    {
        get
        {
            let event = self._event
            
            return event
        }
    }
    
    class Collection<ModelType: DynamicModel> : DynamicStore
    {
        private var _modelById = [String:ModelType]()
        private var _loadUUID : UUID!
        
        @discardableResult
        func load(_ query: DynamicQuery) -> DynamicPromise
        {
            let loadUUID = UUID()
            self._loadUUID = loadUUID
            
            let promise = query.execute()
            .then
            { (value) -> Any? in

                if (loadUUID != self._loadUUID)
                {
                    throw DynamicPromise.Failure(400)
                }
                
                let models = value as! [ModelType]

                for model in models
                {
                    self._modelById[model.id] = model
                }
                
                let event = DynamicStore.Event(operation: DynamicStore.Event.Operation.load, models: models)
                self._notifyEvent(event)

                return models
            }

            return promise
        }
        
        @discardableResult
        func reload<QueryType: DynamicQuery>(_ query: QueryType) -> DynamicPromise
        {
            var models = [ModelType]()
            
            for model in self._modelById.values
            {
                models.append(model)
            }
            
            self._modelById = [String:ModelType]()
            
            let event = DynamicStore.Event(operation: DynamicStore.Event.Operation.reload, models: models)
            self._notifyEvent(event)
            
            let promise = self.load(query)

            return promise
        }
        
        func selectAll() -> AnySequence<(String,ModelType)>
        {
            let models = self._retrieveAll_() as! AnySequence<(String, ModelType)>
            
            return models
        }
        
        func select(by id: String) -> ModelType?
        {
            let model = self._retrieve_(by: id) as? ModelType
            
            return model
        }
        
        @discardableResult
        func insert(model: ModelType) -> DynamicPromise
        {
            let promise = self.insert(models: [model])
            
            return promise
        }

        @discardableResult
        func insert(models: [ModelType]) -> DynamicPromise
        {
            let promise = self._mutate(operation: DynamicMutation.Operation.insert, models: models)
            .then
            { (value) -> Any? in
                
                let models = value as! [ModelType]
                var failure : DynamicPromise.Failure? = nil
                
                for model in models
                {
                    if (model.id.count == 0)
                    {
                        failure = DynamicPromise.Failure("DynamicStore: Insertable Model Must Have Id With At Least One Character")
                    }
                    
                    if (self._modelById[model.id] != nil)
                    {
                        failure = DynamicPromise.Failure("DynamicStore: Cannot Insert Model With Duplicated Id \(model.id)")
                    }
                    
                    if (failure != nil)
                    {
                        throw failure!
                    }
                }
                
                for model in models
                {
                    self._modelById[model.id] = model
                }
                
                return models
            }
            .then
            { (value) -> Any? in
                
                let models = value as! [ModelType]
                
                if (models.count > 0)
                {
                    self._notifyEvent(for: DynamicStore.Event.Operation.insert, models: models)
                }
                
                return value
            }
            
            return promise
        }
        
        @discardableResult
        func delete(by id: String) -> DynamicPromise
        {
            let promise = self.delete(by: [id])
            
            return promise
        }
        
        @discardableResult
        func delete(by ids: [String]) -> DynamicPromise
        {
            let promise = DynamicPromise.resolve(value: [ModelType]())
            .then
            { (value) -> Any? in
                
                var models = value as! [ModelType]
                
                for id in ids
                {
                    let model = self._modelById[id]
                    
                    if (model != nil)
                    {
                        models.append(model!)
                    }
                }
                
                return self._mutate(operation: DynamicMutation.Operation.delete, models: models)
            }
            .then
            { (value) -> Any? in
                
                let models = value as! [ModelType]
                
                for model in models
                {
                    self._modelById[model.id] = nil
                }
                
                if (models.count > 0)
                {
                    self._notifyEvent(for: DynamicStore.Event.Operation.delete, models: models)
                }
                
                return models
            }
            
            return promise
        }

        @discardableResult
        func update(model: ModelType) -> DynamicPromise
        {
            let promise = self.update(models: [model])
            
            return promise
        }
        
        @discardableResult
        func update(models: [ModelType]) -> DynamicPromise
        {
            let promise = DynamicPromise.resolve(value: models)
            .then
            { (value) -> Any? in
                
                var models = value as! [ModelType]
                
                for model in models
                {
                    if (self._modelById[model.id] != nil)
                    {
                        models.append(model)
                    }
                }
                
                return self._mutate(operation: DynamicMutation.Operation.update, models: models)
            }
            .then
            { (value) -> Any? in
                
                let models = value as! [ModelType]
                
                for model in models
                {
                    self._modelById[model.id] = model
                }
                
                if (models.count > 0)
                {
                    self._notifyEvent(for: DynamicStore.Event.Operation.update, models: models)
                }
                
                return models
            }
            
            return promise
        }
        
        private func _mutate(operation: DynamicMutation.Operation, models: [ModelType]) -> DynamicPromise
        {
            let promise = DynamicPromise.resolve(value: nil)
            .then
            { (value) -> Any? in
                
                if (self._mutation != nil)
                {
                    return self._mutation!.execute(operation: operation, models: models)
                }
                else
                {
                    return models
                }
            }
            
            return promise
        }
        
        internal func _retrieve_(by id: String) -> DynamicModel?
        {
            let model = self._modelById[id]
            
            return model
        }
        
        internal func _retrieveAll_() -> AnySequence<(String,DynamicModel)>
        {
            let sequence = AnySequence<(String,DynamicModel)>
            { () -> AnyIterator<(String,DynamicModel)> in
                
                let modelById = self._modelById as [String:DynamicModel]
                var modelByIdIterator = modelById.makeIterator()
                
                let iterator = AnyIterator<(String,DynamicModel)>
                {
                    let modelByIdEntry = modelByIdIterator.next()
                    
                    return modelByIdEntry
                }
                
                return iterator
            }
            
            return sequence
        }
        
        private func _notifyEvent(for operation: DynamicStore.Event.Operation, models: [DynamicModel])
        {
            let event = DynamicStore.Event(operation: operation, models: models)
            self._notifyEvent(event)
        }
        
        private func _notifyEvent(_ event: DynamicStore.Event)
        {
            DispatchQueue.main.async
            {
                self.willChangeValue(forKey: "event")
                self._event = event
                self.didChangeValue(forKey: "event")
            }
        }
    }
    
    class Event : NSObject
    {
        private var _operation : DynamicStore.Event.Operation
        private var _models : [DynamicModel]
        
        init(operation: DynamicStore.Event.Operation, models: [DynamicModel])
        {
            self._operation = operation
            self._models = models
        }
        
        var operation : DynamicStore.Event.Operation
        {
            get
            {
                let operation = self._operation
                
                return operation
            }
        }
        
        var models : [DynamicModel]
        {
            get
            {
                let models = self._models
                
                return models
            }
        }
        
        var model : DynamicModel!
        {
            get
            {
                let model = self._models.first
                
                return model
            }
        }
        
        @objc var mode : DynamicStore.Event.Mode
        {
            get
            {
                var mode = DynamicStore.Event.Mode.atomic
                
                if (self.models.count > 0)
                {
                    mode = DynamicStore.Event.Mode.batch
                }
                
                return mode
            }
        }
        
        @objc
        enum Mode : Int
        {
            case atomic
            case batch
        }
        
        @objc
        enum Operation : Int
        {
            case load
            case reload
            case insert
            case delete
            case update
        }
    }
}
