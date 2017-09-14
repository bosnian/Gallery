//
//  HeaderCollectionReusableView.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/14/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import ChameleonFramework

class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    var active: Observable<Bool>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gestR = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(gestR)

    }
    
    func tapped() {
        if let active = active {
            active.value = !active.value
        }
        
    }
}
