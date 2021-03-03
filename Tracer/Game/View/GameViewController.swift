//
//  GameViewController.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import UIKit

protocol GameViewControllerOutput: class {
  func reloadCollectionView()
  func drawArrows(between cellsWithIndexes: [(Int, Int)])
  func showWrongPersonSelectedAlert(_ person: Person, livesLeft lives: Int)
  func showLevelEndedAlert(withReport report: Report, error: GameError?)
  func updateTimeElapsed(to seconds: Int)
  func updateLevelNumber(to number: Int)
  func updateLevelPoints(to number: Int)
  func updateTotalPoints(to number: Int)
  func updateTotalLives(to number: Int)
  func setElapsedLabelToDemo()
  func updateBackgroundColor(at index: Int)
  func popViewController()
}

class GameViewController: UIViewController, GameViewControllerOutput {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var totalPointsLabel: UILabel!
  @IBOutlet weak var totalLivesLabel: UILabel!
  @IBOutlet weak var currentLevelLabel: UILabel!
  @IBOutlet weak var levelPointsLabel: UILabel!
  @IBOutlet weak var timeElapsedLabel: UILabel!

  private var viewModel: GameViewModel!
  private var arrowLayers = [CAShapeLayer]()


  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = GameViewModelImpl(output: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.viewWillAppear()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.viewHasAppeared()
  }

  func reloadCollectionView() {
    removeArrows()
    collectionView.reloadData()
  }

  func drawArrows(between cellsWithIndexes: [(Int, Int)]) {
    let indexPathPairs: [(IndexPath, IndexPath)] = cellsWithIndexes.map {
      (arrayLiteral: IndexPath(item: $0, section: 0), IndexPath(item: $1, section: 0))
    }
    
    var arrowCount = 0
    indexPathPairs.forEach {
      let start = collectionView.cellForItem(at: $0.0)
      let end = collectionView.cellForItem(at: $0.1)
      guard let startCell = start, let endCell = end else { return }
      let animationDuration = 0.5  * Double(arrowCount)
      DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
        self.drawArrow(from: startCell, to: endCell)
      }
      arrowCount += 1
    }
  }

  func showWrongPersonSelectedAlert(_ person: Person, livesLeft lives: Int) {
    let msg = "\(person.name) is incorrect. You have \(lives) lives pending."
    let alertVC = UIAlertController(title: "OOPs!!", message: msg, preferredStyle: .alert)
    let endGameAction = UIAlertAction(title: "End Game", style: .cancel) { [unowned self] _ in
      self.viewModel.endGame()
    }
    let continueAction = UIAlertAction(title: "Continue", style: .default) { [unowned self] _ in
      self.viewModel.continueGame()
    }
    alertVC.addAction(endGameAction)
    alertVC.addAction(continueAction)
    present(alertVC, animated: true, completion: nil)
  }

  func showLevelEndedAlert(withReport report: Report, error: GameError?) {
    let title = error == nil ? "Yayy!!" : "OOPs!!"
    let msgPrefix = error == nil ? "Level crossed!!" : "No more lives!!"
    let msg = "\(msgPrefix)\n\(report.description)"
    let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)

    if error == nil {
      let endGameAction = UIAlertAction(title: "End Game", style: .cancel) { [unowned self] _ in
        self.viewModel.endGame()
      }
      alertVC.addAction(endGameAction)
      let continueAction = UIAlertAction(title: "Next Level", style: .default) { [unowned self] _ in
        self.viewModel.playNextLevel()
      }
      alertVC.addAction(continueAction)
    } else {
      let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
        self.popViewController()
      }
      alertVC.addAction(okAction)
    }
    present(alertVC, animated: true, completion: nil)
  }

  func setElapsedLabelToDemo() {
    timeElapsedLabel.text = "DEMO"
  }

  func updateTimeElapsed(to seconds: Int) {
    timeElapsedLabel.text = "Time Elapsed: \(seconds)s"
  }

  func updateLevelNumber(to number: Int) {
    currentLevelLabel.text = "Level \(number)"
  }

  func updateLevelPoints(to number: Int) {
    levelPointsLabel.text = "Level Points: \(number)"
  }

  func updateTotalPoints(to number: Int) {
    totalPointsLabel.text = "Total Points: \(number)"
  }

  func updateTotalLives(to number: Int) {
    totalLivesLabel.text = "Lives: \(number)"
  }

  func updateBackgroundColor(at index: Int) {
    let indexPath = IndexPath(item: index, section: 0)
    guard let cell = collectionView.cellForItem(at: indexPath),
          let gameCell = cell as? GameCollectionViewCell else { return }
    gameCell.nameLabel.backgroundColor = .systemBlue
  }

  func popViewController() {
    self.navigationController?.popViewController(animated: true)
  }

  private func drawArrow(from startCell: UICollectionViewCell, to endCell: UICollectionViewCell) {
    let layer = collectionView.drawArrow(start: startCell.center, end: endCell.center)
    arrowLayers.append(layer)
  }

  private func removeArrows() {
    arrowLayers.forEach { $0.removeFromSuperlayer() }
    arrowLayers = []
  }
}

extension GameViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItems()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier,
                                                  for: indexPath) as! GameCollectionViewCell
    cell.viewModel = viewModel.viewModelForCell(at: indexPath)
    cell.viewModel.setOutput(cell)
    return cell
  }

}

extension GameViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath),
          let gameCell = cell as? GameCollectionViewCell else { return }
    self.viewModel.didSelectPerson(gameCell.viewModel.person)
  }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenSize = UIScreen.main.bounds
    let itemsPerRow = 4
    let interItemPadding = 10 * (itemsPerRow - 1)
    let collectionViewPadding = 16 * 2
    let totalPadding = CGFloat(interItemPadding + collectionViewPadding)
    let cellSquareSize = (screenSize.width - totalPadding) / CGFloat(itemsPerRow)
    return CGSize(width: cellSquareSize, height: cellSquareSize)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}
