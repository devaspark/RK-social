//
//  CircleView.swift
//  RK Social
//
//  Created by Rex Kung on 1/11/18.
//  Copyright © 2018 Rex Kung. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        
    }


}
