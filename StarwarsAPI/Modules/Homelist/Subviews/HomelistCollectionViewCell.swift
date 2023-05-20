//
//  HomelistCollectionViewCell.swift
//  CatsAPITest
//
//  Created by Higashikata Maverick on 15/5/23.
//

import UIKit

class HomelistCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var CellImageView: UIImageView!
    @IBOutlet weak var CellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(with image: UIImage?, and label: String) {
        DispatchQueue.main.sync {
            self.CellImageView.image = image
            self.CellLabel.text = label
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
