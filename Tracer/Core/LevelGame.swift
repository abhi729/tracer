//
//  LevelGame.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

enum GameError: Error {
  case wrongPersonSelected
}

enum Status {
  case notStarted
  case inProgress
  case completed(error: GameError?)
}

protocol LevelGame: Game {
  var level: Level { get }
  var startTime: TimeInterval? { get }
  var endTime: TimeInterval? { get }
  var status: Status { get }
}

extension LevelGame {
  var timeTaken: Int {
    return Int((endTime ?? 0) - (startTime ?? 0))
  }
}

class LevelGameImpl: LevelGame {
  let level: Level
  var startTime: TimeInterval?
  var endTime: TimeInterval?
  var status = Status.notStarted
  var points = 0
  var lives: Int
  var bonusPoints = 0

  var totalPoints: Int {
    return points
  }

  private let actualUniverse: [Person]
  private let shuffledUniverse: [Person]
  private let requiredPath: [Person]
  private var selectedPath = [[Person]]()

  init(level: Level,
       lives: Int,
       universeManager: UniverseManager = UniverseManagerImpl()) {
    self.level = level
    self.lives = lives
    self.actualUniverse = universeManager.createUniverse(forLevel: level)
    self.shuffledUniverse = universeManager.shuffleUniverse(actualUniverse, forLevel: level)
    self.requiredPath = actualUniverse.filter { $0.isCovidPositive }
    self.selectedPath.append([Person]())
  }

  func getActualUniverse() -> [Person] {
    return actualUniverse
  }

  func generateUniverseForGame() -> [Person] {
    startTime = Date().timeIntervalSince1970
    status = .inProgress
    return shuffledUniverse
  }

  func selectPerson(_ person: Person,
                    wrongPathHandler: @escaping (Person) -> (),
                    correctPathHandler: @escaping (Person) -> (),
                    gameCompletedHandler: @escaping (Report, GameError?) -> ()) {
    let currentLife = selectedPath.count - 1
    let currentNumber = selectedPath[currentLife].count

    selectedPath[currentLife].append(person)

    guard currentNumber < requiredPath.count,
          person == requiredPath[currentNumber] else {
      lives -= 1
      points -= 10
      points = max(0, points)
      if lives < 0 {
        self.endGame(withError: .wrongPersonSelected)
        gameCompletedHandler(generateReport(), .wrongPersonSelected)
      } else {
        selectedPath.append([Person]())
        points = 0
        wrongPathHandler(person)
      }
      return
    }

    points += 10
    if requiredPath == selectedPath[currentLife] {
      endGame()
      gameCompletedHandler(generateReport(), nil)
    } else {
      correctPathHandler(person)
    }
  }

  func end() {
    endGame()
  }

  func getCovidTracePath() -> [Person] {
    return requiredPath
  }

  func incrementLevel() {}

  private func endGame(withError error: GameError? = nil) {
    endTime = Date().timeIntervalSince1970
    status = .completed(error: error)
    accountForBonusPoints()
  }

  private func accountForBonusPoints() {
    switch status {
    case .completed(error: let error):
      guard error == nil else { return }
      let bp = level.secondsAllotedForLevel - timeTaken
      bonusPoints = max(0, bp)
      points += bonusPoints
    default:
      break
    }
  }

  private func generateReport() -> Report {
    return Report(levelGame: self,
                  universe: shuffledUniverse,
                  actualPath: requiredPath,
                  selectedPaths: selectedPath)
  }
}
