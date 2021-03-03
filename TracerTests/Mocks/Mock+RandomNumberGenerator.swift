//
//  MockRandomNumberGenerator.swift
//  TracerTests
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation
@testable import Tracer

class MockRandomNumberGeneratorImpl: RandomNumberGenerator {

  private var values: [Int] = [0, 1, 2]
  private var count = 0

  func generateRandomNumber(in range: ClosedRange<Int> = 0...1) -> Int {
    let output = values[count]
    count += 1
    return output
  }
  
}
