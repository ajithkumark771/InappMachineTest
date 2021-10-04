//
//  DbOperations.swift
//  MachineTestAjith
//
//  Created by ajithkumar k on 04/10/21.
//

import UIKit
import  CoreData
class DbOperations{
    
    func getShowRatingById(id: Int) -> Double?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
              //self.viewRating.rating = data.value(forKey: "rating") as! Double
                return  data.value(forKey: "rating") as? Double
            }
            
        } catch {
            
            print("Failed")
        }
        return nil
    }
    
    func createRatingEntry(id: Int, rating: Double){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "ShowEntity", in: managedContext)!
        let ratedShow = NSManagedObject(entity: userEntity, insertInto: managedContext)
        ratedShow.setValue(rating, forKeyPath: "rating")
        ratedShow.setValue(id, forKeyPath: "id")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
