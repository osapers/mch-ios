//
//  EditProfileViewController.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import Combine

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    lazy var nameTextField = UITextField()
    lazy var surnameTextField = UITextField()
    lazy var stackView = UIStackView().configureForAutoLayout()
    lazy var avatarButton = UIButton().configureForAutoLayout()
    lazy var avatarImagePicker = UIImagePickerController()
    lazy var saveButton = UIButton().configureForAutoLayout()
    lazy var authStorage = dependencies.authStorage()
    var user: User!
    private var cancellableBag: [AnyCancellable] = []
    
    private lazy var userService = dependencies.userService()
    
    private var userSubject = PassthroughSubject<User, Never>()
    var userPublisher: AnyPublisher<User, Never> {
        userSubject.eraseToAnyPublisher()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Редактировать"
        view.backgroundColor = .white
        view.addSubview(avatarButton)
        
        avatarButton.autoSetDimensions(to: CGSize(width: 64, height: 64))
        avatarButton.setImage(UIImage(named: "Profile"), for: .normal)
        avatarButton.layer.borderWidth = 1
        avatarButton.layer.borderColor = UIColor.Brand.black.withAlphaComponent(0.5).cgColor
        avatarButton.clipsToBounds = true
        avatarButton.layer.cornerRadius = 32
        avatarButton.autoPinEdge(toSuperviewMargin: .top, withInset: 16)
        avatarButton.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        avatarButton.addTarget(self, action: #selector(handleAvatarTap), for: .touchUpInside)
        
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(surnameTextField)
        view.addSubview(stackView)
        stackView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        stackView.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        stackView.autoAlignAxis(.horizontal, toSameAxisOf: view, withOffset: -UIScreen.main.bounds.height / 7)
        
        nameTextField.placeholder = "Имя"
        nameTextField.autoSetDimension(.height, toSize: 48)
        nameTextField.borderStyle = .roundedRect
        nameTextField.textContentType = .name
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        nameTextField.autocorrectionType = .no
        
        surnameTextField.autoSetDimension(.height, toSize: 48)
        surnameTextField.placeholder = "Фамилия"
        surnameTextField.borderStyle = .roundedRect
        surnameTextField.addTarget(self, action: #selector(surnameTextFieldChanged), for: .editingChanged)
        surnameTextField.autocorrectionType = .no
        
        view.addSubview(saveButton)
        saveButton.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        saveButton.autoSetDimension(.height, toSize: 48)
        saveButton.layer.cornerRadius = 8
        saveButton.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        saveButton.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 72)
        saveButton.setTitle("Сохранить", for: UIControl.State())
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        saveButton.backgroundColor = UIColor.Brand.green
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(handleSaveButtonTap), for: .touchUpInside)
    }
    
    @objc private func nameTextFieldChanged() {
        handleSaveButtonState()
    }
    
    @objc private func surnameTextFieldChanged() {
        handleSaveButtonState()
    }
    
    private func handleSaveButtonState() {
        saveButton.isEnabled = !nameTextField.text.isEmptyOrNil
            && !surnameTextField.text.isEmptyOrNil
    }
    
    @objc private func handleSaveButtonTap() {
        guard let name = nameTextField.text, let surname = surnameTextField.text else {
            return
        }
        view.endEditing(true)
        let loadingView = startLoading()
        userService
            .updateUser(name: name, surname: surname, image: avatarButton.imageView?.image, email: user.email)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.handleError(error: error, loadingView: loadingView)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                guard let self = self else {
                    return
                }
                
                self.userSubject.send(user)
                self.stopLoading(loadingView: loadingView)
                let alert = UIAlertController(
                    title: "Успешно",
                    message: "Профиль был обновлен",
                    preferredStyle: .alert
                )
                let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellableBag)
    }
    
    @objc private func handleAvatarTap() {
        avatarImagePicker.delegate = self
        avatarImagePicker.sourceType = .savedPhotosAlbum
        avatarImagePicker.allowsEditing = true
        DispatchQueue.main.async {
            self.present(self.avatarImagePicker, animated: true)
        }
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let pickedImage = info[.originalImage] as? UIImage {
            avatarButton.imageView?.contentMode = .scaleAspectFill
            avatarButton.setImage(pickedImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
