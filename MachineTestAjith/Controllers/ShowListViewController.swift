//
//  ShowListViewController.swift
//  MachineTestAjith
//
//  Created by ajithkumar k on 30/09/21.
//

import UIKit

class ShowListViewController: UIViewController {
    @IBOutlet weak var showSearchBar: UISearchBar!
    @IBOutlet weak var showListCollectionView: UICollectionView!

    var showsList: [Show] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getShowsList()
        showListCollectionView.register(UINib(nibName: "ShowListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowListCollectionViewCell")
    }
    
    func setupUI(){
        self.navigationItem.title = "Shows"
    }
    
    func getShowsList(){
        ApiHandler.apiCall(requrl: ServerURL.showList, method: .get, parameter: ["page": "1"], enableSpinner: true) { responseData, success, errorMesage in
            if success{
                do{
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode([Show].self, from: responseData!)
                    self.showsList = responseData
                    self.showListCollectionView.reloadData()
                }catch{
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToShowDetailVc" {
            guard let vc = segue.destination as? ShowDetailViewController else { return }
            vc.show = showsList[sender as! Int]
            vc.didUpdteRating = { value in
                self.showSimpleAlert(withTitle: "", withMessage: "Your rating is \(value)")
                self.showListCollectionView.reloadData()
            }
        }
    }

}

extension ShowListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return showsList.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowListCollectionViewCell", for: indexPath) as! ShowListCollectionViewCell
    cell.setupCell(showDetail: showsList[indexPath.row])
    cell.btnStarRating.addTarget(self, action: #selector(clickedStarRatingButton(sender:)), for: .touchUpInside)
    cell.btnStarRating.tag = indexPath.item
    return cell
}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
    let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    let width:CGFloat = (showListCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: width, height: width * 1.5)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          performSegue(withIdentifier: "GoToShowDetailVc", sender: indexPath.row)
    }
    
    @objc func clickedStarRatingButton(sender: UIButton){
        let ratingVC = UIStoryboard(name: "ShowList", bundle: nil).instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        ratingVC.show = showsList[sender.tag]
        ratingVC.didUpdteRating = { value in
            self.showListCollectionView.reloadData()
        }
        self.addChild(ratingVC)
        ratingVC.view.frame = self.view.frame
        self.view.addSubview(ratingVC.view)
        ratingVC.didMove(toParent: self)
    }

}
