//
//  HomeViewController.swift
//  Tracer
//
//  Created by Abhishek Agarwal on 03/03/2021.
//

import UIKit

protocol HomeViewControllerOutput: class {
  func routeToGameScreen()
}

class HomeViewController: UIViewController, HomeViewControllerOutput {

  @IBOutlet weak var welcomeLabel: UILabel!
  @IBOutlet weak var instructionsLabel: UILabel!
  @IBOutlet weak var startGameButton: UIButton!

  private var viewModel: HomeViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel = HomeViewModelImpl(output: self)
    setupViews()
  }

  private func setupViews() {
    welcomeLabel.text = Constants.welcomeText
    instructionsLabel.text = Constants.instructions
    startGameButton.setTitle(Constants.startGameButtonTitle,
                             for: .normal)
  }

  @IBAction func didTapStartGame(_ sender: Any) {
    viewModel.didTapStartGame()
  }

  // MARK:- HomeViewControllerOutput implementation
  func routeToGameScreen() {
    performSegue(withIdentifier: Constants.homeToGameSegue, sender: self)
  }

}

