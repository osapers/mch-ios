//
//  AuthViewController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit
import PureLayout

final class AuthViewController: UIViewController {

    lazy var passwordTextField = UITextField()
    lazy var loginTextField = UITextField()
    lazy var stackView = UIStackView().configureForAutoLayout()
    lazy var continueButton = UIButton().configureForAutoLayout()
    lazy var authStorage = dependencies.authStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Авторизация"
        view.backgroundColor = .white
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        view.addSubview(stackView)
        stackView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        stackView.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        stackView.autoAlignAxis(.horizontal, toSameAxisOf: view, withOffset: -UIScreen.main.bounds.height / 5)

        loginTextField.placeholder = "Почта"
        loginTextField.autoSetDimension(.height, toSize: 48)
        loginTextField.borderStyle = .roundedRect
        loginTextField.textContentType = .emailAddress
        loginTextField.keyboardType = .emailAddress
        loginTextField.addTarget(self, action: #selector(loginTextFieldChanged), for: .editingChanged)
        loginTextField.autocorrectionType = .no

        passwordTextField.autoSetDimension(.height, toSize: 48)
        passwordTextField.placeholder = "Пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.addTarget(self, action: #selector(loginTextFieldChanged), for: .editingChanged)
        passwordTextField.autocorrectionType = .no

        view.addSubview(continueButton)
        continueButton.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        continueButton.autoSetDimension(.height, toSize: 48)
        continueButton.layer.cornerRadius = 8
        continueButton.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        continueButton.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 72)
        continueButton.setTitle("Продолжить", for: UIControl.State())
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        continueButton.backgroundColor = UIColor.Brand.green
        continueButton.isEnabled = false
        continueButton.addTarget(self, action: #selector(handleContinueButtonTap), for: .touchUpInside)
    }

    @objc private func loginTextFieldChanged() {
        handleContinueButtonState()
    }

    @objc private func passwordTextFieldChanged() {
        handleContinueButtonState()
    }

    @objc private func handleContinueButtonTap() {
        authStorage.isAuthorized = true
        NotificationCenter.default.post(Notification(name: .userAuthorized))
    }

    private func handleContinueButtonState() {
        continueButton.isEnabled = !passwordTextField.text.isEmptyOrNil
            && loginTextField.text.isEmail
    }
}

fileprivate extension Optional where Wrapped == String {

    var isEmptyOrNil: Bool {
        self == nil || self?.replacingOccurrences(of: " ", with: "") == ""
    }

    var isEmail: Bool {
        guard let self = self else {
            return false
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
