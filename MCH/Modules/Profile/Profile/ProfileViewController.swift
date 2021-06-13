//
//  ProfileViewController.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import Combine
import PureLayout

class ProfileViewController: UIViewController {
    
    lazy var scrollView = UIScrollView().configureForAutoLayout()
    lazy var contentView = UIView().configureForAutoLayout()
    lazy var nameLabel = UILabel()
    lazy var surnameLabel = UILabel()
    lazy var tagsTitle = UILabel().configureForAutoLayout()
    lazy var addTagsButton = UIButton().configureForAutoLayout()
    lazy var emailLabel = UILabel()
    lazy var stackView = UIStackView().configureForAutoLayout()
    lazy var specializationsStack = UIStackView().configureForAutoLayout()
    lazy var avatarImage = UIImageView().configureForAutoLayout()
    private var cancellableBag: [AnyCancellable] = []
    private lazy var userService = dependencies.userService()
    private var user: User?
    private var specializations: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        navigationItem.title = "Профиль"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewMargins()
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        contentView.autoPinEdgesToSuperviewEdges()
        contentView.autoMatch(.width, to: .width, of: view, withOffset: -40)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Редактировать",
            style: .plain,
            target: self,
            action: #selector(editProfile)
        )
        scrollView.addSubview(avatarImage)
        avatarImage.autoSetDimensions(to: CGSize(width: 64, height: 64))
        avatarImage.image = UIImage(named: "Profile")
        avatarImage.layer.borderWidth = 1
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.borderColor = UIColor.Brand.black.withAlphaComponent(0.5).cgColor
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 32
        avatarImage.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        avatarImage.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(surnameLabel)
        stackView.addArrangedSubview(emailLabel)
        scrollView.addSubview(stackView)
        stackView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        stackView.autoPinEdge(.left, to: .right, of: avatarImage, withOffset: 12)
        stackView.autoPinEdge(toSuperviewEdge: .top, withInset: 16)

        scrollView.addSubview(tagsTitle)
        tagsTitle.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 24, relation: .greaterThanOrEqual)
        tagsTitle.autoPinEdge(.top, to: .bottom, of: avatarImage, withOffset: 24, relation: .greaterThanOrEqual)
        tagsTitle.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        tagsTitle.attributedText = "Специализации".styled(.title1)

        scrollView.addSubview(addTagsButton)
        addTagsButton.setAttributedTitle("Добавить".styled(.label, textColor: UIColor.Brand.green), for: .normal)
        addTagsButton.setTitleColor(UIColor.Brand.green, for: .normal)
        addTagsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        addTagsButton.autoAlignAxis(.horizontal, toSameAxisOf: tagsTitle)
        addTagsButton.addTarget(self, action: #selector(appendSpecializatons), for: .touchUpInside)

        specializationsStack.alignment = .leading
        specializationsStack.axis = .vertical
        specializationsStack.spacing = 8
        scrollView.addSubview(specializationsStack)
        specializationsStack.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        specializationsStack.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        specializationsStack.autoPinEdge(.top, to: .bottom, of: tagsTitle, withOffset: 16)
        specializationsStack.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16, relation: .greaterThanOrEqual)
        
        nameLabel.text = "Имя"
        surnameLabel.text = "Фамилия"

        scrollView.isHidden = true
        
        let loadingView = startLoading()
        userService
            .obtainUser()
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.handleError(error: error, loadingView: loadingView)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                self?.stopLoading(loadingView: loadingView)
                self?.bindUser(user)
            }
            .store(in: &cancellableBag)
    }
    
    @objc private func editProfile() {
        let editViewController = EditProfileViewController()
        editViewController.user = user
        editViewController
            .userPublisher
            .sink { [weak self] user in
                self?.bindUser(user)
            }
            .store(in: &cancellableBag)
        
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    private func bindUser(_ user: User) {
        self.user = user
        specializations = user.specializations
        emailLabel.attributedText = user.email.styled(.label)
        nameLabel.attributedText = user.name.styled(.title1)
        surnameLabel.attributedText = user.surname.styled(.title1)

        if specializationsStack.arrangedSubviews.isEmpty {
            specializations.enumerated().forEach { index, specialization in
                specializationsStack.addArrangedSubview(makeViewForSpecializaton(specialization, index: index + 1))
            }
        }
        view.layoutIfNeeded()
        scrollView.isHidden = false
        
        avatarImage.image = user.avatar.map { UIImage(base64String: $0) ?? UIImage(named: "Profile")! }
    }

    @objc private func appendSpecializatons() {
        let specializationSearchViewController = SpecializationSearchViewController()
        specializationSearchViewController.currentSpecializations = user?.specializations ?? []
        specializationSearchViewController.specializationPublisher.sink { [weak self] specialization in
            guard let self = self else {
                return
            }

            self.user?.specializations.append(specialization)
            self.user.map {
                self.userService.updateUser(
                    name: $0.name,
                    surname: $0.surname,
                    image: self.avatarImage.image,
                    email: $0.email,
                    specialization: $0.specializations
                )
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &self.cancellableBag)
            }
            self.specializationsStack.arrangedSubviews.forEach {
                self.specializationsStack.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            self.user.map {
                self.bindUser($0)
            }
        }.store(in: &cancellableBag)

        navigationController?.pushViewController(specializationSearchViewController, animated: true)
    }

    private func makeViewForSpecializaton(_ specialization: String, index: Int) -> UIView {
        let colors = [
            UIColor.Brand.backgroundBlue,
            UIColor.Brand.backgroundRed,
            UIColor.Brand.backgroundGreen,
            UIColor.Brand.backgroundOrange,
            UIColor.Brand.backgroundViolet,
            UIColor.Brand.backgroundYellow
        ]

        let specializationView = UIView()
        specializationView.tag = index
        let specializationLabel = UILabel().configureForAutoLayout()
        specializationLabel.tag = index
        specializationView.addSubview(specializationLabel)
        specializationLabel.autoPinEdgesToSuperviewEdges(
            with: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 0),
            excludingEdge: .right
        )
        let deleteSpecializationButton = UIButton().configureForAutoLayout()
        specializationView.addSubview(deleteSpecializationButton)
        deleteSpecializationButton.autoMatch(.height, to: .width, of: deleteSpecializationButton)
        deleteSpecializationButton.autoPinEdgesToSuperviewEdges(
            with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6),
            excludingEdge: .left
        )
        deleteSpecializationButton.autoPinEdge(.left, to: .right, of: specializationLabel, withOffset: 8)
        deleteSpecializationButton.setImage(UIImage(named: "Dismiss"), for: .normal)
        deleteSpecializationButton.tag = index
        deleteSpecializationButton.addTarget(self, action: #selector(removeSpecialization(_:)), for: .touchUpInside)
        specializationLabel.attributedText = specialization.styled(.label)
        specializationView.backgroundColor = colors.randomElement()
        specializationView.layer.cornerRadius = 8
        return specializationView
    }

    @objc private func removeSpecialization(_ sender: UIButton) {
        let tag = sender.tag
        let index = tag - 1
        let specialization = specializations[index]
        user?.specializations.removeAll(where: { $0 == specialization })
        user.map {
            userService.updateUser(
                name: $0.name,
                surname: $0.surname,
                image: avatarImage.image,
                email: $0.email,
                specialization: $0.specializations
            )
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellableBag)
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.specializationsStack.arrangedSubviews.first(where: { $0.tag == tag }).map {
                    $0.isHidden = true
                    $0.alpha = 0
                    self.specializationsStack.layoutIfNeeded()
                }
            },
            completion: { _ in }
        )
    }
}
