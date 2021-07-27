//
//  HomeViewController.swift
//  Calculator
//
//  Created by MSZ on 15/07/2021.
//

import UIKit

protocol HomeView: AnyObject {
    /// It takes 7 operators for now to build the UI
    func configureUI(operators: [(value: String,isEnabled: Bool)])
    func display(result: String?)
    func showErrorAlert(withMessage value: String)
    func showLoader()
    func hideLoader()
}

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var operatorsButtons: [UIButton]!
    @IBOutlet var numbersButtons: [UIButton]!
    @IBOutlet weak var equalButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Variables
    var presenter: HomePresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attach(view: self)
    }

    // MARK:- IBActions
    @IBAction func operatorTapped(_ sender: UIButton) {
        guard let value = sender.titleLabel?.text else { return }
        // In case the UI required a change for the symbols we will send the same symbols here
        // without using the text of the title label of the button.
        // Ex:- we can use the tags to identify the symbols or using a sperated actions for each symbol.
        // So it just a quick action to complete the task.
        self.presenter.operatorTapped(withValue: value)
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        self.presenter.clearTapped()
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        self.presenter.numberTapped(withValue: sender.tag)
    }
    @IBAction func equalTapped(_ sender: UIButton) {
        self.presenter.equalTapped()
    }
    @IBAction func styleSegmentTapped(_ sender: UISegmentedControl) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let style: UIUserInterfaceStyle = sender.selectedSegmentIndex == 0 ? .light : .dark
        appDelegate.changeUserInterfaceStyle(style: style)
    }
}

// MARK: - HomeView Protocol Methods
extension HomeViewController: HomeView {
    func configureUI(operators: [(value: String, isEnabled: Bool)]) {
        // Reverse the scroll view scrolling direction to be from bottom to top
        // I am using the scroll view in case we want to present the history of the equations in the future.
        scrollView.transform = CGAffineTransform(scaleX: 1, y: -1)
        textLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
        // Draw the operators
        guard operators.count >= 7 else { return }
        for index in 0..<7 {
            operatorsButtons[index].isHidden = !operators[index].isEnabled
            operatorsButtons[index].setTitle(operators[index].value, for: .normal)
        }
    }
    
    func display(result: String?) {
        guard let result = result else { return }
        self.textLabel.text = result
    }
    
    func showErrorAlert(withMessage value: String) {
        let alert = UIAlertController(title: "Oops", message: value, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoader() {
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
       ])
    }
    
    func hideLoader() {
        self.loadingView.removeFromSuperview()
    }
}
