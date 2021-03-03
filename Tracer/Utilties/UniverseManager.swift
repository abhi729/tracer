//
//  UniverseManager.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

protocol UniverseManager {
  func createUniverse(forLevel level: Level) -> [Person]
  func shuffleUniverse(_ persons: [Person], forLevel level: Level) -> [Person]
}

struct UniverseManagerImpl: UniverseManager {

  private let generator: RandomNumberGenerator
  private let shuffler: Shuffler

  init(randomNumberGenerator: RandomNumberGenerator = RandomNumberGeneratorImpl(),
       shuffler: Shuffler = UniverseShufflerImpl()) {
    self.generator = randomNumberGenerator
    self.shuffler = shuffler
  }

  func createUniverse(forLevel level: Level) -> [Person] {
    let actualCapacity = getUniverseCapacity(forLevel: level)
    let actualCovidPositive = getUniverseCovidPositiveCount(forLevel: level)
    let covidPositiveIDs = generateCovidPositiveIDs(forCapacity: actualCapacity, actualCovidPositive)
    var universe = [Person]()
    for i in 1...actualCapacity {
      let person = Person(id: (i - 1), isCovidPositive: covidPositiveIDs.contains(i))
      universe.append(person)
    }
    return universe
  }

  func shuffleUniverse(_ persons: [Person], forLevel level: Level) -> [Person] {
    switch level.shuffleMode {
    case .noShuffle:
      return persons
    case .shift(let val):
      return persons.shiftRight(by: val)
    case .shuffle:
      return shuffler.shuffle(persons: persons)
    }
  }

//    [1...4] = 5; [5...9] = 10; [10...14] = 15; [15...20] = 20
  private func getUniverseCapacity(forLevel level: Level) -> Int {
    let maxCapacity = 20
    let desiredLevelCapacity = 5 * ((level.number / 5) + 1)
    return min(maxCapacity, desiredLevelCapacity)
  }

//    [1...2] = 3; [3...4] = 4; [5...6] = 5; [7...8] = 6; [9...10] = 7 ...
  private func getUniverseCovidPositiveCount(forLevel level: Level) -> Int {
    let minPositiveCount = 3
    return min(10, minPositiveCount + ((level.number - 1) / 2))
  }

  private func generateCovidPositiveIDs(forCapacity capacity: Int, _ count: Int) -> Set<Int> {
    var ids = Set<Int>()
    while ids.count < count {
      let newID = generator.generateRandomNumber(in: 1...capacity)
      if !ids.contains(newID) { ids.insert(newID) }
    }
    return ids
  }

}

// MARK :- Level utilities
fileprivate enum ShuffleMode {
  case noShuffle
  case shift(by: Int)
  case shuffle

  /*
   Easy levels: 1,2 -> No shift/shuffle; 3,4 -> ShiftRight; 5 -> Shuffle
   Medium levels: 6,7 -> No shift/shuffle; 8,9 -> ShiftRight; 10 -> Shuffle
   Hard levels: 11,12,16,17 -> No shift/shuffle; 13,14,18,19 -> ShiftRight; 15,20 -> Shuffle
  */
  
  init(from level: Level) {
    if [1,2,6,7,11,12,16,17].contains(level.number) {
      self = .noShuffle
    } else if [3,4,8,9,13,14,18,19].contains(level.number) {
      self = .shift(by: Set(arrayLiteral: 3,8,13,18).contains(level.number) ? 1 : 2)
    } else {
      self = .shuffle
    }
  }
}

fileprivate extension Level {
  var shuffleMode: ShuffleMode {
    return ShuffleMode.init(from: self)
  }
}
