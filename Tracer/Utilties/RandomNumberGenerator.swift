//
//  RandomNumberGenerator.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

protocol RandomNumberGenerator {
  func generateRandomNumber(in range: ClosedRange<Int>) -> Int
}

struct RandomNumberGeneratorImpl: RandomNumberGenerator {
  func generateRandomNumber(in range: ClosedRange<Int>) -> Int {
    return Int.random(in: range)
  }
}
