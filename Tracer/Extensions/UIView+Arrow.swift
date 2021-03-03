//
//  UIView+Arrow.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import UIKit

extension UIView {
  func drawArrow(start: CGPoint, end: CGPoint) -> CAShapeLayer {
    let (p1, p2) = adjustPoints(start, end)
    let arrow = UIBezierPath()
    arrow.addArrow(start: p1,
                   end: p2,
                   pointerLineLength: 10,
                   arrowAngle: CGFloat(Double.pi / 4))
    let arrowLayer = CAShapeLayer()
    arrowLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
    arrowLayer.lineWidth = 2
    arrowLayer.path = arrow.cgPath
    arrowLayer.fillColor = UIColor.clear.cgColor
    arrowLayer.lineJoin = CAShapeLayerLineJoin.round
    arrowLayer.lineCap = CAShapeLayerLineCap.round
    self.layer.addSublayer(arrowLayer)

    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.duration = 0.2
    arrowLayer.add(animation, forKey: "MyAnimation")

    return arrowLayer
  }

  private func adjustPoints(_ start: CGPoint, _ end: CGPoint) -> (CGPoint, CGPoint) {
    var firstPoint = start
    var secondPoint = end
    if firstPoint.x < secondPoint.x {
      firstPoint.x += 5
      secondPoint.x -= 5
    } else if firstPoint.x > secondPoint.x {
      firstPoint.x -= 5
      secondPoint.x += 5
    }
    if firstPoint.y < secondPoint.y {
      firstPoint.y += 5
      secondPoint.y -= 5
    } else if firstPoint.y > secondPoint.y {
      firstPoint.y -= 5
      secondPoint.y += 5
    }
    return (firstPoint, secondPoint)
  }
}
