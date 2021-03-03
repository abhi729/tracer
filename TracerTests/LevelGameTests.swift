//
//  LevelGameTests.swift
//  TracerTests
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import XCTest
@testable import Tracer

class LevelGameTests: XCTestCase {

  func test_level_game_returns_correct_universe_when_get_universe_is_called() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 3, universeManager: manager)
    assert(levelGame.getActualUniverse() == manager.persons)
  }

  func test_level_game_returns_correct_game_universe_when_generate_game_universe_is_called() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 3, universeManager: manager)
    assert(levelGame.generateUniverseForGame() == manager.shuffleUniverse(manager.persons, forLevel: level))
  }

  func test_invoking_end_on_level_game_updates_status_to_completed_without_error() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 3, universeManager: manager)
    levelGame.end()
    assert(levelGame.status == .completed(error: nil))
  }

  func test_selecting_wrong_person_with_no_remaining_lives_ends_the_game_with_error() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 0, universeManager: manager)
    let person = Person(id: 3, isCovidPositive: true)
    let exp = expectation(description: "GameEnd")
    levelGame.selectPerson(person) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { (report, _) in
      exp.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
    assert(levelGame.status == .completed(error: .wrongPersonSelected))
  }

  func test_selecting_wrong_person_with_1_remaining_lives_decreases_lives_to_0() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 1, universeManager: manager)
    let person = Person(id: 3, isCovidPositive: true)
    let exp = expectation(description: "LevelGame")
    levelGame.selectPerson(person) { _ in
      exp.fulfill()
    } correctPathHandler: { _ in } gameCompletedHandler: { (report, _) in }
    waitForExpectations(timeout: 1, handler: nil)
    assert(levelGame.lives == 0)
  }

  func test_selecting_correct_sequence_ends_the_game() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 1, universeManager: manager)
    let person1 = Person(id: 0, isCovidPositive: true)
    let exp = expectation(description: "LevelGame")
    levelGame.selectPerson(person1) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    let person2 = Person(id: 2, isCovidPositive: true)
    levelGame.selectPerson(person2) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    let person3 = Person(id: 4, isCovidPositive: true)
    levelGame.selectPerson(person3) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in
      exp.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
    assert(levelGame.status == .completed(error: nil))
  }

  func test_selecting_correct_sequence_adds_10_points_per_correct_person() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 1, universeManager: manager)
    _ = levelGame.generateUniverseForGame()
    let person1 = Person(id: 0, isCovidPositive: true)
    let exp = expectation(description: "LevelGame")
    levelGame.selectPerson(person1) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    let person2 = Person(id: 2, isCovidPositive: true)
    levelGame.selectPerson(person2) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    let person3 = Person(id: 4, isCovidPositive: true)
    levelGame.selectPerson(person3) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in
      exp.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
    assert(levelGame.points == (30 + level.secondsAllotedForLevel - levelGame.timeTaken))
  }

  func test_selecting_incorrect_person_decreases_10_points_if_current_points_more_than_or_equals_10() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 1, universeManager: manager)
    _ = levelGame.generateUniverseForGame()
    let person1 = Person(id: 0, isCovidPositive: true)
    let exp = expectation(description: "LevelGame")
    levelGame.selectPerson(person1) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    let person2 = Person(id: 1, isCovidPositive: true)
    levelGame.selectPerson(person2) { _ in
      exp.fulfill()
    } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    waitForExpectations(timeout: 1, handler: nil)
    assert(levelGame.points == 0)
  }

  func test_selecting_incorrect_person_sets_points_to_0_if_current_points_less_than_10() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 1, universeManager: manager)
    _ = levelGame.generateUniverseForGame()
    let exp = expectation(description: "LevelGame")
    let person = Person(id: 1, isCovidPositive: true)
    levelGame.selectPerson(person) { _ in
      exp.fulfill()
    } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    waitForExpectations(timeout: 1, handler: nil)
    assert(levelGame.points == 0)
  }

  func test_can_continue_game_after_selecting_incorrect_person_if_lives_greater_than_0() {
    let level = Level(number: 1)
    let manager = MockUniverseManagerImpl()
    let levelGame = LevelGameImpl(level: level, lives: 1, universeManager: manager)
    _ = levelGame.generateUniverseForGame()
    assert(levelGame.lives == 1)
    let exp = expectation(description: "LevelGame")
    let person = Person(id: 1, isCovidPositive: true)
    levelGame.selectPerson(person) { _ in
      exp.fulfill()
    } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    waitForExpectations(timeout: 1, handler: nil)
    assert(levelGame.lives == 0)
    let exp1 = expectation(description: "LevelGame1")
    let person1 = Person(id: 0, isCovidPositive: true)
    levelGame.selectPerson(person1) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    let person2 = Person(id: 2, isCovidPositive: true)
    levelGame.selectPerson(person2) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in }
    let person3 = Person(id: 4, isCovidPositive: true)
    levelGame.selectPerson(person3) { _ in } correctPathHandler: { _ in } gameCompletedHandler: { _,_ in
      exp1.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
    assert(levelGame.lives == 0)
    assert(levelGame.status == .completed(error: nil))
  }

}

