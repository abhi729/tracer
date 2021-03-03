//
//  UniverseShuffler.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

protocol Shuffler {
  func shuffle(persons: [Person]) -> [Person]
}

struct UniverseShufflerImpl: Shuffler {
  func shuffle(persons: [Person]) -> [Person] {
    return persons.shuffled()
  }
}
