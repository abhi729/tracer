//
//  Game.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

protocol Game {
  var level: Level { get }
  var points: Int { get }
  var bonusPoints: Int { get }
  var totalPoints: Int { get }
  var lives: Int { get }
  func getActualUniverse() -> [Person]
  func generateUniverseForGame() -> [Person]
  func selectPerson(_ person: Person,
                    wrongPathHandler: @escaping (Person) -> (),
                    correctPathHandler: @escaping (Person) -> (),
                    gameCompletedHandler: @escaping (Report, GameError?) -> ())
  func getCovidTracePath() -> [Person]
  func end()
  func incrementLevel()
}

class GameImpl: Game {
  private var levelGames = [LevelGame]()
  private var currentLevelGame: LevelGame
  private var reports = [Report]()
  var level: Level {
    return currentLevelGame.level
  }
  var lives: Int = 3
  var points: Int = 0
  var totalPoints: Int = 0
  var bonusPoints: Int = 0
  private var prevTotalPoints: Int = 0

  init(from level: Level = Level(number: 1)) {
    self.currentLevelGame = LevelGameImpl(level: level, lives: lives)
    self.levelGames.append(currentLevelGame)
  }

  func getActualUniverse() -> [Person] {
    return currentLevelGame.getActualUniverse()
  }

  func generateUniverseForGame() -> [Person] {
    return currentLevelGame.generateUniverseForGame()
  }

  func selectPerson(_ person: Person,
                    wrongPathHandler: @escaping (Person) -> (),
                    correctPathHandler: @escaping (Person) -> (),
                    gameCompletedHandler: @escaping (Report, GameError?) -> ()) {
    currentLevelGame
      .selectPerson(person,
                    wrongPathHandler: { [unowned self] person in
                      self.lives -= 1
                      wrongPathHandler(person)
                    }, correctPathHandler: { [unowned self] person in
                      self.points = currentLevelGame.points
                      self.totalPoints = prevTotalPoints + currentLevelGame.points
                      correctPathHandler(person)
                    }, gameCompletedHandler: { [unowned self] report, error in
                      if error != nil {
                        self.accountForLevelGameEnd()
                      }
                      let updatedReport = update(report: report)
                      self.reports.append(report)
                      gameCompletedHandler(updatedReport, error)
                    }
      )
  }

  func end() {
    currentLevelGame.end()
  }

  func getCovidTracePath() -> [Person] {
    return currentLevelGame.getCovidTracePath()
  }

  func incrementLevel() {
    let newLevel = Level(number: level.number + 1)
    self.currentLevelGame = LevelGameImpl(level: newLevel, lives: lives)
    self.points = currentLevelGame.points
    self.levelGames.append(currentLevelGame)
  }

  private func accountForLevelGameEnd() {
    lives = currentLevelGame.lives
    prevTotalPoints += currentLevelGame.points
    totalPoints = prevTotalPoints
    bonusPoints += currentLevelGame.bonusPoints
  }

  private func update(report: Report) -> Report {
    var finalReport = report
    finalReport.updateTotalPoints(to: totalPoints)
    return finalReport
  }
}
