//
//  DynamicPromise.swift
//  Pacific
//
//  Created by Minh Nguyen on 8/22/16.
//  Copyright © 2017 Langtutheky. All rights reserved.
//

import Foundation

enum DynamicPromiseState
{
    case pending
    case fulfilled
    case rejected
}

struct DynamicPromiseError : Error
{
    var reason : Any?
    
    init(_ reason: Any?)
    {
        self.reason = reason
    }
}

class DynamicPromise
{
    private var _isRejected = false
    private var _resolvers = [DynamicPromiseResolver]()
    private var _state = DynamicPromiseState.pending
    private var _value : Any?
    
    init(executor: @escaping (_ resolve: @escaping (_ value: Any?) -> Void, _ reject: @escaping (_ reason: DynamicPromiseError) -> Void) -> Void)
    {
        executor(self.resolve, self.reject)
    }
    
    @discardableResult
    func then(_ fulfiller: @escaping (_ value: Any?) throws -> Any?) -> DynamicPromise
    {
        let resolver = DynamicPromiseResolver(fulfiller: fulfiller)
        self._resolvers.append(resolver)
        
        if (self._state == DynamicPromiseState.fulfilled || (self._state == DynamicPromiseState.rejected))
        {
            return self._trigger()
        }
        
        return self
    }
    
    @discardableResult
    func `catch`(_ rejector: @escaping (_ reason: DynamicPromiseError) throws -> Any?) -> DynamicPromise
    {
        let resolver = DynamicPromiseResolver(rejector: rejector)
        self._resolvers.append(resolver)
        
        if (self._state == DynamicPromiseState.rejected)
        {
            return self._trigger()
        }
        
        return self
    }
    
    func resolve(value: Any?) -> Void
    {
        if (self._state == DynamicPromiseState.pending)
        {
            self._state = DynamicPromiseState.fulfilled
            self._value = value
            self._trigger()
        }
    }
    
    func reject(reason: DynamicPromiseError) -> Void
    {
        if (self._state == DynamicPromiseState.pending)
        {
            self._state = DynamicPromiseState.rejected
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
                
                if (self._state == DynamicPromiseState.fulfilled && resolver.fulfiller != nil)
                {
                    potential = try resolver.fulfiller!(self._value)
                }
                else if (self._state == DynamicPromiseState.rejected && resolver.rejector != nil && !self._isRejected)
                {
                    self._isRejected = true
                    potential = try resolver.rejector!(self._value as! DynamicPromiseError)
                }
                else if (self._state == DynamicPromiseState.rejected && resolver.fulfiller != nil && self._isRejected)
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
                    
                    if (promise._state == DynamicPromiseState.pending)
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
                self._state = DynamicPromiseState.rejected
                self._isRejected = false
                self._value = value
            }
        }
        
        return self
    }
}
