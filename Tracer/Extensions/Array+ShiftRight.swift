//
//  Array+ShiftRight.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

extension Array {
//  Array(1...10).shiftRight() -> [2, 3, 4, 5, 6, 7, 8, 9, 10, 1]
//  Array(1...10).shiftRight(7) -> [8, 9, 10, 1, 2, 3, 4, 5, 6, 7]
  func shiftRight(by amount: Int = 1) -> [Element] {
    var mutableAmount = amount
    assert(-count...count ~= amount, "Shift amount out of bounds")
    if mutableAmount < 0 { mutableAmount += count }  // this needs to be >= 0
    return Array(self[mutableAmount ..< count] + self[0 ..< amount])
  }

  mutating func shiftRightInPlace(amount: Int = 1) {
    self = shiftRight(by: amount)
  }
}
