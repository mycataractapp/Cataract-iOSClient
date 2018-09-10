//
//  DynamicPromise.swift
//  Pacific
//
//  Created by Minh Nguyen on 8/22/16.
//  Copyright © 2017 Langtutheky. All rights reserved.
//

import Foundation

class DynamicPromise
{
    private var _isRejected = false
    private var _resolvers = [DynamicPromise.Resolver]()
    private var _state = DynamicPromise.State.pending
    private var _value : Any?
    
    init(_ executor: @escaping (_ fulfiller: @escaping (_ value: Any?) -> Void, _ rejector: @escaping (_ reason: DynamicPromise.Failure) -> Void) -> Void)
    {
        executor(self._resolve, self._reject)
    }
    
    @discardableResult
    func then(_ fulfiller: @escaping (_ value: Any?) throws -> Any?) -> DynamicPromise
    {
        let resolver = DynamicPromise.Resolver(fulfiller: fulfiller)
        self._resolvers.append(resolver)
        
        if (self._state == DynamicPromise.State.fulfilled || (self._state == DynamicPromise.State.rejected))
        {
            return self._trigger()
        }
        
        return self
    }
    
    @discardableResult
    func `catch`(_ rejector: @escaping (_ reason: DynamicPromise.Failure) throws -> Any?) -> DynamicPromise
    {
        let resolver = DynamicPromise.Resolver(rejector: rejector)
        self._resolvers.append(resolver)
        
        if (self._state == DynamicPromise.State.rejected)
        {
            return self._trigger()
        }
        
        return self
    }
    
    class func resolve(value: Any?) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            resolve(value)
        }
        
        return promise
    }
    
    class func reject(reason: DynamicPromise.Failure) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            reject(reason)
        }
        
        return promise
    }
    
    private func _resolve(value: Any?) -> Void
    {
        if (self._state == DynamicPromise.State.pending)
        {
            self._state = DynamicPromise.State.fulfilled
            self._value = value
            self._trigger()
        }
    }
    
    private func _reject(reason: DynamicPromise.Failure) -> Void
    {
        if (self._state == DynamicPromise.State.pending)
        {
            self._state = DynamicPromise.State.rejected
            self._value = reason
            self._trigger()
        }
    }
    
    @discardableResult
    private func _trigger() -> DynamicPromise
    {
        while(self._resolvers.count > 0)
        {
            let resolver = self._resolvers.shift()!
        
            do
            {
                var potential : Any? = nil
                
                if (self._state == DynamicPromise.State.fulfilled && resolver.fulfiller != nil)
                {
                    potential = try resolver.fulfiller!(self._value)
                }
                else if (self._state == DynamicPromise.State.rejected && resolver.rejector != nil && !self._isRejected)
                {
                    self._isRejected = true
                    potential = try resolver.rejector!(self._value as! DynamicPromise.Failure)
                }
                else if (self._state == DynamicPromise.State.rejected && resolver.fulfiller != nil && self._isRejected)
                {
                    potential = try resolver.fulfiller!(self._value)
                }
                else
                {
                    continue
                }
                
                if (potential is DynamicPromise)
                {
                    let promise = potential as! DynamicPromise
                    promise._resolvers.append(contentsOf: self._resolvers)
                    self._resolvers.removeAll()
                    
                    if (promise._state == DynamicPromise.State.pending)
                    {
                        return promise
                    }
                    else
                    {
                        return promise._trigger()
                    }
                }
                else 
                {
                    self._value = potential
                }
            }
            catch let value
            {
                self._state = DynamicPromise.State.rejected
                self._isRejected = false
                self._value = value
            }
        }
        
        return self
    }
    
    private class Resolver
    {
        var fulfiller : ((_ value: Any?) throws -> Any?)?
        var rejector : ((_ reason: DynamicPromise.Failure) throws -> Any?)?
        
        init(fulfiller: @escaping (_ value: Any?) throws -> Any?)
        {
            self.fulfiller = fulfiller
        }
        
        init(rejector: @escaping (_ reason: DynamicPromise.Failure) throws -> Any?)
        {
            self.rejector = rejector
        }
    }
    
    class Failure : Error
    {
        var reason : Any?
        
        init(_ reason: Any?)
        {
            self.reason = reason
        }
    }
    
    @objc
    enum State : Int
    {
        case pending
        case fulfilled
        case rejected
    }
}
