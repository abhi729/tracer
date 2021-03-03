//
//  Mock+UniverseManager.swift
//  TracerTests
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation
@testable import Tracer

struct MockUniverseManagerImpl: UniverseManager {

  static let mockPersons = [
    Person(id: 0, isCovidPositive: true),
    Person(id: 1, isCovidPositive: false),
    Person(id: 2, isCovidPositive: true),
    Person(id: 3, isCovidPositive: false),
    Person(id: 4, isCovidPositive: true)
  ]

  let actualPaths = [
    Person(id: 0, isCovidPositive: true),
    Person(id: 2, isCovidPositive: true),
    Person(id: 4, isCovidPositive: true)
  ]
  
  let selectedPaths = [
    [
      Person(id: 0, isCovidPositive: true),
      Person(id: 2, isCovidPositive: true),
      Person(id: 3, isCovidPositive: false)
    ],
    [
      Person(id: 0, isCovidPositive: true),
      Person(id: 1, isCovidPositive: false)
    ],
    [
      Person(id: 0, isCovidPositive: true),
      Person(id: 2, isCovidPositive: true),
      Person(id: 4, isCovidPositive: true)
    ]
  ]

  let persons: [Person]

  init(_ persons: [Person] = MockUniverseManagerImpl.mockPersons) {
    self.persons = persons
  }
  func createUniverse(forLevel level: Level) -> [Person] {
    return persons
  }

  func shuffleUniverse(_ persons: [Person], forLevel level: Level) -> [Person] {
    return persons.shiftRight()
  }
}
