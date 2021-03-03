//
//  UniverseManagerTests.swift
//  TracerTests
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import XCTest
@testable import Tracer

class UniverseManagerTests: XCTestCase {
  func test_create_universe_has_minimum_3_persons_with_covid_positive() {
    for i in 1...20 {
      let lvl = Level(number: i)
      let manager = UniverseManagerImpl()
      let persons = manager.createUniverse(forLevel: lvl)
      assert(persons.filter { $0.isCovidPositive }.count >= 3)
    }
  }

  func test_create_universe_returns_appropriate_number_of_persons_as_per_level() {
    let capacity = [
      1...4: 5,
      5...9: 10,
      10...14: 15,
      15...20: 20
    ]
    for i in 1...20 {
      let lvl = Level(number: i)
      let manager = UniverseManagerImpl()
      let persons = manager.createUniverse(forLevel: lvl)
      let key = capacity.keys.filter { $0.contains(i) }.first!
      assert(persons.count == capacity[key])
    }
  }

  func test_create_universe_returns_appropriate_number_of_covid_positives_as_per_level() {
    let positiveCount = [
      1...2: 3,
      3...4: 4,
      5...6: 5,
      7...8: 6,
      9...10: 7,
      11...12: 8,
      13...14: 9,
      15...20: 10,
    ]
    for i in 1...20 {
      let lvl = Level(number: i)
      let manager = UniverseManagerImpl()
      let persons = manager.createUniverse(forLevel: lvl)
      let key = positiveCount.keys.filter { $0.contains(i) }.first!
      assert(persons.filter { $0.isCovidPositive }.count == positiveCount[key])
    }
  }

  func test_create_universe_returns_correct_universe_as_per_level() {
    let lvl = Level(number: 1)
    let generator = MockRandomNumberGeneratorImpl()
    let manager = UniverseManagerImpl(randomNumberGenerator: generator)
    let persons = manager.createUniverse(forLevel: lvl)
    let expectedPersons = [
      Person(id: 0, isCovidPositive: true),
      Person(id: 1, isCovidPositive: true),
      Person(id: 2, isCovidPositive: true),
      Person(id: 3, isCovidPositive: false),
      Person(id: 4, isCovidPositive: false)
    ]
    assert(persons == expectedPersons)
  }

  func test_shuffle_universe_returns_appropriately_shuffled_universe_for_specific_hard_levels() {
    let levels = [5, 10, 15, 20]
    let shuffler = MockShufflerImpl()
    let manager = UniverseManagerImpl(shuffler: shuffler)
    for l in levels {
      let level = Level(number: l)
      let persons = manager.createUniverse(forLevel: level)
      let shuffledPersons = manager.shuffleUniverse(persons, forLevel: level)
      assert(persons.shiftRight(by: 3) == shuffledPersons)
    }
  }

  func test_shuffle_universe_returns_unshuffled_universe_for_specific_easy_levels() {
    let levels = [1,2,6,7,11,12,16,17]
    let manager = UniverseManagerImpl()
    for l in levels {
      let level = Level(number: l)
      let persons = manager.createUniverse(forLevel: level)
      let shuffledPersons = manager.shuffleUniverse(persons, forLevel: level)
      assert(persons == shuffledPersons)
    }
  }

  func test_shuffle_universe_returns_right_shiftede_universe_for_specific_medium_levels() {
    let levels = [3,4,8,9,13,14,18,19]
    let rightShiftedBy1 = Set<Int>(arrayLiteral: 3, 8, 13, 18)
    let manager = UniverseManagerImpl()
    for l in levels {
      let level = Level(number: l)
      let persons = manager.createUniverse(forLevel: level)
      let shuffledPersons = manager.shuffleUniverse(persons, forLevel: level)
      let shiftValue = rightShiftedBy1.contains(l) ? 1 : 2
      assert(persons.shiftRight(by: shiftValue) == shuffledPersons)
    }
  }
}
