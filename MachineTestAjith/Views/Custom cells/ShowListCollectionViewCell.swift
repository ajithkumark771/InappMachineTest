//
//  ShowListCollectionViewCell.swift
//  MachineTestAjith
//
//  Created by ajithkumar k on 30/09/21.
//

import UIKit
import Kingfisher

class ShowListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var showThumbNail: UIImageView!
    @IBOutlet weak var lblShowName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(showDetail: Show){
        if let thumbnailUrl = showDetail.image.medium{
            showThumbNail.kf.setImage(with: URL(string:thumbnailUrl))
        }
        lblShowName.text = showDetail.name
        if let rating = showDetail.rating.average{
            lblRating.text = "\(rating)"
        }
       
    }

}
