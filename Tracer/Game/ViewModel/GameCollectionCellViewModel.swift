//
//  GameCollectionCellViewModel.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

protocol GameCollectionCellViewModel {
  var person: Person { get }
  func setOutput(_ output: GameCollectionViewCellOutput)
}

class GameCollectionCellViewModelImpl: GameCollectionCellViewModel {
  let person: Person
  weak var output: GameCollectionViewCellOutput?

  init(with person: Person) {
    self.person = person
  }

  func setOutput(_ output: GameCollectionViewCellOutput) {
    self.output = output
    self.output?.setupName(person.name)
  }
}
