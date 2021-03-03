//
//  UIView+Border.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 04/03/2021.
//

import UIKit

extension UIView {

  func addBorder() {
    let cornerRadius = max(bounds.width, bounds.height) / 2
    layer.cornerRadius = cornerRadius
    layer.borderWidth = 2
    layer.borderColor = UIColor.black.cgColor
    layer.masksToBounds = true
  }

}
