//
//  CDHelper.swift
//  CoreDataStack
//
//  Created by Steven McMurray on 9/22/15.
//  Copyright © 2015 Steven McMurray. All rights reserved.
//

import Foundation
import CoreData

class CDHelper {
    
    static let sharedInstance = CDHelper()
    
    lazy var storesDirectory: NSURL = {
        let fm = NSFileManager.defaultManager()
        let urls = fm.URLsForDirectory(.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    lazy var localStoresURL: NSURL = {
        let url = self.storesDirectory.URLByAppendingPathComponent("CoreDataStack.sqlite")
        return url
    }()
    
    lazy var modelURL: NSURL = {
        let bundle = NSBundle.mainBundle()
        if let url = bundle.URLForResource("Model", withExtension: "momd") {
            return url
        }
        print("CRITICAL - Managed Object Model file not found")
        abort()
    }()
    
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL: self.modelURL)!
    }()
    
    lazy var coordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.localStoresURL, options: nil)
            } catch {
                print("couldnt add persistent store")
                abort()
            }
        
        return coordinator
    }()
    
    lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.coordinator
        return context
    }()
    
}