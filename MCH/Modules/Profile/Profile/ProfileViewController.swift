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
        avatarImage.contentMode = .center
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
        tagsTitle.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 24)
        tagsTitle.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        tagsTitle.attributedText = "Специализации".styled(.title1)

        scrollView.addSubview(addTagsButton)
        addTagsButton.setAttributedTitle("Добавить".styled(.label, textColor: UIColor.Brand.green), for: .normal)
        addTagsButton.setTitleColor(UIColor.Brand.green, for: .normal)
        addTagsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        addTagsButton.autoAlignAxis(.horizontal, toSameAxisOf: tagsTitle)

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
        emailLabel.attributedText = user.email.styled(.label)
        nameLabel.attributedText = "Александр".styled(.title1)
        surnameLabel.attributedText = "Ходько".styled(.title1)
        let spe = ["iOS", "Android", "Дизайн"]
        let colors = [UIColor.Brand.backgroundBlue, UIColor.Brand.backgroundRed, UIColor.Brand.backgroundGreen]
        (0...6).forEach { _ in
            spe.forEach { spe in
                let view = UIView()
                let label = UILabel().configureForAutoLayout()
                view.addSubview(label)
                label.autoPinEdgesToSuperviewEdges(
                    with: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 0),
                    excludingEdge: .right
                )
                let deleteButton = UIButton().configureForAutoLayout()
                view.addSubview(deleteButton)
                deleteButton.autoMatch(.height, to: .width, of: deleteButton)
                deleteButton.autoPinEdgesToSuperviewEdges(
                    with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6),
                    excludingEdge: .left
                )
                deleteButton.autoPinEdge(.left, to: .right, of: label, withOffset: 8)
                deleteButton.setImage(UIImage(named: "Dismiss"), for: .normal)
                label.attributedText = spe.styled(.label)
                view.backgroundColor = colors.randomElement()
                view.layer.cornerRadius = 8
                specializationsStack.addArrangedSubview(view)
            }
        }
        view.layoutIfNeeded()
        scrollView.isHidden = false
        
        avatarImage.image = user.avatar.map { UIImage(base64String: $0) ?? UIImage(named: "Profile")! }
    }
}

fileprivate extension UIImage {
    convenience init?(base64String: String) {
        guard !base64String.isEmpty else { return nil }
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data)
    }
}
