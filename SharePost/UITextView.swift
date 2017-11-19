//
//  UITextView.swift
//  
//
//  Created by allen3_huang on 2017/11/11.
//

import UIKit

extension UITextView {
    func setBorder(width: CGFloat, radius: CGFloat, color: CGColor){
        self.layer.borderWidth = width
        self.layer.borderColor = color
        self.layer.cornerRadius = radius
    }
}
