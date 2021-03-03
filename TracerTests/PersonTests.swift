//
//  PersonTests.swift
//  TracerTests
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import XCTest
@testable import Tracer

class PersonTests: XCTestCase {
  func test_personName_returns_alphabet_for_id_values_in_0_to_25() {
    let person = Person(id: 0, isCovidPositive: true)
    assert(person.name == "A")
  }

  func test_personName_returns_id_for_id_values_not_in_0_to_25() {
    let person = Person(id: 30, isCovidPositive: true)
    assert(person.name == "30")
  }
}
