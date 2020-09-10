//
//  GalleryCellCollectionViewCell.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 09.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeCellLabel: UILabel!
    var goToFullScreen: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestures = gestureRecognizers?.count ?? 0
        if gestures == 0 {
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(choosedMediaFile))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func choosedMediaFile() {
        self.goToFullScreen?()
    }
}
