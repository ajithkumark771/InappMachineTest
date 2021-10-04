//
//  RatingViewController.swift
//  MachineTestAjith
//
//  Created by ajithkumar k on 04/10/21.
//

import UIKit
import Cosmos
import CoreData
class RatingViewController: UIViewController {
    var didUpdteRating : ((Double) -> Void)?
    @IBOutlet weak var starRatingView: CosmosView!
    var show: Show!
    var ratingValue = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI(){
        starRatingView.rating = DbOperations().getShowRatingById(id: show.id) ?? 1
        starRatingView.didFinishTouchingCosmos = { [self] rating in
            ratingValue = rating
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Actions
    @IBAction func clickedCancelBtn(_ sender: Any) {
        self.willMove(toParent: nil)
                   self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @IBAction func clickedRateNowBtn(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ShowEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(show.id))
        do
        {
            let retrievedRatingarray = try managedContext.fetch(fetchRequest)
            if !retrievedRatingarray.isEmpty{
                // update db
                let objectUpdate = retrievedRatingarray[0] as! NSManagedObject
                objectUpdate.setValue(ratingValue, forKey: "rating")
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }else{
                DbOperations().createRatingEntry(id: show.id, rating: ratingValue)
            }
        }
        catch
        {
            print(error)
        }
        
        didUpdteRating!(ratingValue)
        self.willMove(toParent: nil)
                   self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}
