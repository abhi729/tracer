//
//  LevelTests.swift
//  TracerTests
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import XCTest
@testable import Tracer

class LevelTests: XCTestCase {
  func test_level_difficulty_is_easy_for_level_less_than_or_equals_5() {
    for i in 1...5 {
      let level = Level(number: i)
      assert(level.difficulty == .easy)
    }
  }

  func test_level_difficulty_is_medium_for_level_in_range_6_to_10() {
    for i in 6...10 {
      let level = Level(number: i)
      assert(level.difficulty == .medium)
    }
  }

  func test_level_difficulty_is_hard_for_level_greater_than_10() {
    for i in 11...20 {
      let level = Level(number: i)
      assert(level.difficulty == .hard)
    }
  }

  func test_seconds_alloted_for_levels_1_through_4_is_5() {
    for i in 1...4 {
      let level = Level(number: i)
      assert(level.secondsAllotedForLevel == 5)
    }
  }

  func test_seconds_alloted_for_levels_5_through_9_is_10() {
    for i in 5...9 {
      let level = Level(number: i)
      assert(level.secondsAllotedForLevel == 10)
    }
  }

  func test_seconds_alloted_for_levels_10_through_14_is_15() {
    for i in 10...14 {
      let level = Level(number: i)
      assert(level.secondsAllotedForLevel == 15)
    }
  }

  func test_seconds_alloted_for_levels_15_through_19_is_20() {
    for i in 15...19 {
      let level = Level(number: i)
      assert(level.secondsAllotedForLevel == 20)
    }
  }
}
