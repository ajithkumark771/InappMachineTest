//
//  ShowDetailViewController.swift
//  MachineTestAjith
//
//  Created by ajithkumar k on 30/09/21.
//

import UIKit
import Cosmos
import CoreData
class ShowDetailViewController: UIViewController {
    var didUpdteRating : ((Double) -> Void)?
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lblDesription: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPremierDate: UILabel!
    @IBOutlet weak var lblRunTime: UILabel!
    @IBOutlet weak var lblOfficialSite: UILabel!
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var stackStatus: UIStackView!
    @IBOutlet weak var stackPremieredDate: UIStackView!
    @IBOutlet weak var stackRunTime: UIStackView!
    @IBOutlet weak var stackOfficialSite: UIStackView!
    @IBOutlet weak var stackUrl: UIStackView!
    @IBOutlet weak var stackRating: UIStackView!
    @IBOutlet weak var viewRating: CosmosView!
    var show: Show!
    var ratingValue = 1.0
    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getShowDetails()
        retrieveStarRatingFromDB()
    }
    func setupUI(){
        self.navigationItem.title = show.name
        lblDesription.text = ""
        stackStatus.isHidden = true
        stackPremieredDate.isHidden = true
        stackRunTime.isHidden = true
        stackOfficialSite.isHidden = true
        stackUrl.isHidden = true
        stackRating.isHidden = true
        
        viewRating.rating = 1
        viewRating.didFinishTouchingCosmos = { [self] rating in
          ratingValue = rating
        }
    }
    func loadData(showDetail: Show)
    {
        if let thumbnailUrl = showDetail.image.medium{
            ivThumbnail.kf.setImage(with: URL(string:thumbnailUrl))
        }
        lblDesription.text = showDetail.summary.htmlToString
        
        if let status = show.status{
            stackStatus.isHidden = false
            lblStatus.text = status
        }
        if let premierDate = show.premiered{
            stackPremieredDate.isHidden = false
            lblPremierDate.text = premierDate
        }
        if let runTime = show.runtime{
            stackRunTime.isHidden = false
            lblRunTime.text = "\(runTime)"
        }
        if let officialSite = show.officialSite{
            stackOfficialSite.isHidden = false
            lblOfficialSite.text = officialSite
        }
        if let url = show.url{
            stackUrl.isHidden = false
            lblUrl.text = url
        }
        if let rating = show.rating.average{
            stackRating.isHidden = false
            lblRating.text = "\(rating)"
        }
    }
    
    func retrieveStarRatingFromDB() {
        self.viewRating.rating = DbOperations().getShowRatingById(id: show.id) ?? 1.0
    }
    
    func getShowDetails(){
        ApiHandler.apiCall(requrl: ServerURL.showList + "/" +  String(describing: show.id), method: .get, parameter: [:], enableSpinner: true) { responseData, success, errorMesage in
            if success{
                do{
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(Show.self, from: responseData!)
                    self.show = responseData
                   self.loadData(showDetail: responseData)
                }catch{
                    print(error)
                }
            }else{
               
            }
        }
    }

    
    // MARK: - Actions
    
    @IBAction func clickedSubmitRatingButton(_ sender: Any) {
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
        
        
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        navigationController?.popViewController(animated: true)
        didUpdteRating!(ratingValue)
    }
}
