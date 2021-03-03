//
//  Report.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

struct Report: CustomStringConvertible {
  private let level: Level
  private let points: Int
  private let timeTaken: Int
  private let universe: [Person]
  private let actualPath: [Person]
  private let selectedPaths: [[Person]]
  private var totalPoints = 0
  private let bonusPoints: Int

  var actualPathOutput: String {
    return actualPath
      .map { $0.name }
      .joined(separator: " -> ")
  }

  var selectedPathOutput: String {
    return selectedPaths
      .map { $0.map { $0.name }.joined(separator: " -> ") }
      .joined(separator: "\n")
  }

  init(levelGame: LevelGame,
       universe: [Person],
       actualPath: [Person],
       selectedPaths: [[Person]]) {
    self.level = levelGame.level
    self.points = levelGame.points
    self.timeTaken = levelGame.timeTaken
    self.universe = universe
    self.actualPath = actualPath
    self.selectedPaths = selectedPaths
    self.bonusPoints = levelGame.bonusPoints
  }

  var description: String {
    return
      "Overall Points: \(totalPoints)\n" +
      "Level \(level.number):\n" +
      "Points \(points)\n" +
      "Bonus Points \(bonusPoints)\n" +
      "Time Taken \(timeTaken) seconds\n" +
      "Actual Trace:\n\(actualPathOutput)\n" +
      "Your traces:\n\(selectedPathOutput)"
  }

  mutating func updateTotalPoints(to points: Int) {
    self.totalPoints = points
  }
}
