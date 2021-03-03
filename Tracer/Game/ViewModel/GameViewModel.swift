//
//  GameViewModel.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import Foundation

protocol GameViewModel {
  var totalPoints: Int { get }
  var lives: Int { get }
  var level: Int { get }
  var levelPoints: Int { get }
  func numberOfItems() -> Int
  func viewModelForCell(at indexPath: IndexPath) -> GameCollectionCellViewModel
  func viewHasAppeared()
  func viewWillAppear()
  func didSelectPerson(_ person: Person)
  func endGame()
  func continueGame()
  func playNextLevel()
}

class GameViewModelImpl: GameViewModel {
  var totalPoints: Int {
    return game.points
  }
  var lives: Int {
    return game.lives
  }
  var level: Int {
    return game.level.number
  }
  var levelPoints: Int {
    return 0
  }

  let game: Game
  private var universe = [Person]()
  private weak var output: GameViewControllerOutput?
  private var isDemoInProgress: Bool = false
  private var selectedPersons = [Person]()
  private var timer: Timer?
  private var timerValue = 0

  init(output: GameViewControllerOutput?) {
    self.game = GameImpl(from: Level(number: 1))
    self.output = output
  }

  func numberOfItems() -> Int {
    return universe.count
  }

  func viewModelForCell(at indexPath: IndexPath) -> GameCollectionCellViewModel {
    return GameCollectionCellViewModelImpl(with: universe[indexPath.item])
  }

  func viewHasAppeared() {
    showDemo()
  }

  func viewWillAppear() {
    setupLevel()
  }

  func didSelectPerson(_ person: Person) {
    guard !isDemoInProgress else { return }
    universe
      .firstIndex(where: { $0.id == person.id })
      .map { output?.updateBackgroundColor(at: $0) }
    let newIndexPair = calculateNewIndexPair(for: person)
    newIndexPair.map { output?.drawArrows(between: [$0]) }
    selectedPersons.append(person)
    game.selectPerson(person,
                      wrongPathHandler: { [weak self] person in
                        guard let _self = self else { return }
                        _self.updateData()
                        _self.output?.showWrongPersonSelectedAlert(person, livesLeft: _self.lives)
                      }, correctPathHandler: { [weak self] person in
                        self?.updateData()
                      },
                      gameCompletedHandler: { [weak self] (report, error) in
                        self?.invalidateTimer()
                        self?.updateData()
                        self?.output?.showLevelEndedAlert(withReport: report, error: error)
                        if error == nil {
                          self?.game.incrementLevel()
                        }
                      }
    )
  }

  func continueGame() {
    selectedPersons = []
    output?.reloadCollectionView()
  }

  func endGame() {
    game.end()
    universe = []
    output?.popViewController()
  }

  func playNextLevel() {
    setupLevel()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.showDemo()
    }
  }

  private func invalidateTimer() {
    timerValue = 0
    timer?.invalidate()
    timer = nil
  }

  private func setupLevel() {
    selectedPersons = []
    invalidateTimer()
    output?.setElapsedLabelToDemo()
    updateData()
    universe = game.getActualUniverse()
    output?.reloadCollectionView()
  }

  private func updateData() {
    output?.updateTotalLives(to: game.lives)
    output?.updateLevelNumber(to: game.level.number)
    output?.updateTotalPoints(to: game.totalPoints)
    output?.updateLevelPoints(to: game.points)
  }

  private func showDemo() {
    isDemoInProgress = true
    invalidateTimer()
    output?.setElapsedLabelToDemo()
    let actualPath = game.getCovidTracePath()
    let indexPairs = calculateIndexPairs(for: actualPath)
    output?.drawArrows(between: indexPairs)
    DispatchQueue.main.asyncAfter(deadline: .now() + Double(actualPath.count / 2)) { [weak self] in
      self?.startGame()
    }
  }

  private func calculateIndexPairs(for persons: [Person]) -> [(Int, Int)] {
    var indexPairs = [(Int, Int)]()
    for i in 1..<persons.count {
      indexPairs.append((persons[i - 1].id, persons[i].id))
    }
    return indexPairs
  }

  private func calculateNewIndexPair(for person: Person) -> (Int, Int)? {
    guard !selectedPersons.isEmpty else { return nil }
    let lastIndex = selectedPersons.count - 1
    guard let firstIndex = universe.firstIndex(where: { $0.id == selectedPersons[lastIndex].id }),
          let secondIndex = universe.firstIndex(where: { $0.id == person.id }) else { return nil }
    return (firstIndex, secondIndex)
  }

  private func startGame() {
    isDemoInProgress = false
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] t in
      self?.timerValue += 1
      self?.output?.updateTimeElapsed(to: self?.timerValue ?? 0)
    })
    universe = self.game.generateUniverseForGame()
    output?.reloadCollectionView()
  }
}
