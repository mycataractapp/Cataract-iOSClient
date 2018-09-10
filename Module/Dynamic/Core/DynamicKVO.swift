//
//  DynamicKVO.Event.swift
//  Pacific
//
//  Created by Minh Nguyen on 8/3/18.
//  Copyright © 2018 Minh Nguyen. All rights reserved.
//

import Foundation

class DynamicKVO
{
    static func keyPath<Root, Value>(_ keyPath: KeyPath<Root, Value>) -> String
    {
        let keyPathString = NSExpression(forKeyPath: keyPath).keyPath
        
        return keyPathString
    }
    
    class Event : NSObject
    {
        private var _kind : DynamicKVO.Event.Kind
        private var _keyPath : String
        private var _isPriorNotification : Bool
        private var _object : Any?
        private var _oldValue : Any?
        private var _newValue : Any?
        private var _indexes : IndexSet?
        private var _context : UnsafeMutableRawPointer?
        
        init(kind: DynamicKVO.Event.Kind, keyPath: String, isPriorNotification: Bool, object: Any?, oldValue: Any?, newValue: Any?, indexes : IndexSet?, context : UnsafeMutableRawPointer?)
        {
            self._kind = kind
            self._keyPath = keyPath
            self._isPriorNotification = isPriorNotification
            self._indexes = indexes
            self._context = context
            
            if (!(oldValue is NSNull))
            {
                self._oldValue = oldValue
            }
            
            if (!(newValue is NSNull))
            {
                self._newValue = newValue
            }
            
            if (!(object is NSNull))
            {
                self._object = object
            }
        }
        
        var kind : DynamicKVO.Event.Kind
        {
            get
            {
                let kind = self._kind
                
                return kind
            }
        }
        
        var keyPath : String
        {
            get
            {
                let keyPath = self._keyPath
                
                return keyPath
            }
        }
        
        var isPriorNotification : Bool
        {
            get
            {
                let isPriorNotification = self._isPriorNotification
                
                return isPriorNotification
            }
        }
        
        var object : Any?
        {
            get
            {
                let object = self._object
                
                return object
            }
        }
        
        var oldValue : Any?
        {
            get
            {
                let oldValue = self._oldValue
                
                return oldValue
            }
        }
        
        var newValue : Any?
        {
            get
            {
                let newValue = self._newValue
                
                return newValue
            }
        }
        
        var indexes : IndexSet?
        {
            get
            {
                let indexes = self._indexes
                
                return indexes
            }
        }
        
        var context : UnsafeMutableRawPointer?
        {
            get
            {
                let context = self._context
                
                return context
            }
        }
        
        @objc
        enum Kind : Int
        {
            case setting
            case insertion
            case removal
            case replacement
        }
    }
}
