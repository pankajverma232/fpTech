//
//  CoreDataManager.swift
//  fptech
//
//  Created by Pankaj Verma on 09/01/19.
//  Copyright © 2019 Pankaj Verma. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    let EntityName = "News"
    let EntityKeyData = "data"
    let EntityKeyPageNumber = "pageNumber"
    
    func fetchNewsDataForPageNumber(_ pageNumber:Int) -> Data?{
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: EntityName)
         fetchRequest.predicate = NSPredicate(format: "pageNumber == %d", pageNumber)
        do {
            let newsData = try managedContext.fetch(fetchRequest)
            if newsData.count > 0 {
                 return newsData[0].value(forKeyPath: EntityKeyData) as? Data
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func saveNewsData(data:Data, pageNumber:Int) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: EntityName,
                                       in: managedContext)!
        
        let news = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        news.setValue(pageNumber, forKeyPath: EntityKeyPageNumber)
        news.setValue(data, forKeyPath: EntityKeyData)
        
        //save
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save image. \(error), \(error.userInfo)")
        }
    }
    

}

