//
//  Mock+Shuffler.swift
//  TracerTests
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation
@testable import Tracer

class MockShufflerImpl: Shuffler {
  func shuffle(persons: [Person]) -> [Person] {
    return persons.shiftRight(by: 3)
  }
}
