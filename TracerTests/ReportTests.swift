//
//  ReportTests.swift
//  TracerTests
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import XCTest
@testable import Tracer

class ReportTests: XCTestCase {
  func test_report_description_for_given_inputs_is_correct() {
    let mockOutput =
"""
Overall Points: 0
Level 1:
Points 0
TimeTaken 0 seconds
Actual Trace:
A -> C -> E
Your traces:
A -> C -> D
A -> B
A -> C -> E
"""

    let level = Level(number: 1)
    let mockManager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 3, universeManager: mockManager)
    let report = Report(levelGame: levelGame, universe: mockManager.persons, actualPath: mockManager.actualPaths, selectedPaths: mockManager.selectedPaths)
    assert(report.description == mockOutput)
  }
}
