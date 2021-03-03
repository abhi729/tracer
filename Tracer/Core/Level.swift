//
//  Level.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

enum Difficulty: String {
  case easy = "EASY"
  case medium = "MEDIUM"
  case hard = "HARD"

  init(from number: Int) {
    if 1...5 ~= number {
      self = .easy
    } else if 6...10 ~= number {
      self = .medium
    } else {
      self = .hard
    }
  }
}

struct Level: CustomStringConvertible {
  let number: Int
  let difficulty: Difficulty
  var secondsAllotedForLevel: Int {
    return 5 * ((number / 5) + 1)
  }

  init(number: Int) {
    self.number = number
    self.difficulty = Difficulty.init(from: number)
  }

  var description: String {
    return "Level: \(number), Difficulty: \(difficulty.rawValue)"
  }

}
