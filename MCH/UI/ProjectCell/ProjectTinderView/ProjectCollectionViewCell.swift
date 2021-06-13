//
//  ProjectTableViewCell.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import PureLayout
import SDWebImage

protocol ProjectCollectionViewCellDelegate: AnyObject {

    func didTapDeleteAtProject(_ projectID: String)

    func didTapEditAtProject(_ projectID: String)

    func didTapFindUserAtProject(_ projectID: String)

    func didTapChatAtProject(_ projectID: String)
}

class ProjectCollectionViewCell: UICollectionViewCell {
    
    let projectIcon = UIImageView().configureForAutoLayout()
    let projectName = UILabel().configureForAutoLayout()
    let projectSpecialization = UILabel().configureForAutoLayout()
    let projectDescription = UILabel().configureForAutoLayout()
    let projectReadinessStage = UILabel().configureForAutoLayout()
    let projectReadinessStageView = UIView().configureForAutoLayout()
    let projectRedinessDate = UILabel().configureForAutoLayout()
    let containerView = UIView().configureForAutoLayout()
    let shadowView = UIView().configureForAutoLayout()
    let roleLabel = UILabel().configureForAutoLayout()
    let actionsView = UIStackView().configureForAutoLayout()

    let editButton = UIButton()
    let deleteButton = UIButton()
    let chatButton = UIButton()
    let findUsersButton = UIButton()

    var didPressHandler: (() -> Void)?
    var projectID = ""

    weak var delegate: ProjectCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = false
        setupContainerView()
        setupShadowView()
        setupProjectIcon()
        setupProjectName()
        setupProjectSpecialization()
        setupProjectDescription()
        setupProjectReadinessStage()
        setupProjectrReadinessDate()
        setupRoleLabel()

        setupActionsView()
    }


    @objc private func handleDeleteButtonTap() {
        delegate?.didTapDeleteAtProject(projectID)
    }

    @objc private func handleEditButtonTap() {
        delegate?.didTapEditAtProject(projectID)
    }

    @objc private func handleFindUserButtonTap() {
        delegate?.didTapFindUserAtProject(projectID)
    }
    
    @objc private func handleChatButtonTap() {
        delegate?.didTapChatAtProject(projectID)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = false
        contentView.clipsToBounds = false
        containerView.clipsToBounds = false
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: 8, height: 8)
        ).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContainerView() {
        addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
    }

    private func setupShadowView() {
        containerView.addSubview(shadowView)
        shadowView.backgroundColor = .white
        shadowView.autoPinEdgesToSuperviewEdges()
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: shadowView.bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: 8, height: 8)
        ).cgPath
        shadowView.clipsToBounds = false
        shadowView.layer.shouldRasterize = true
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 8)
        shadowView.layer.shadowColor = UIColor.Brand.black.cgColor
        shadowView.layer.shadowOpacity = 0.08
        shadowView.layer.shadowRadius = 10
        shadowView.layer.masksToBounds = false
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupProjectIcon() {
        containerView.addSubview(projectIcon)
        projectIcon.autoSetDimensions(to: CGSize(width: 48, height: 48))
        projectIcon.layer.cornerRadius = 24
        projectIcon.clipsToBounds = true
        projectIcon.contentMode = .scaleAspectFit
        projectIcon.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        projectIcon.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
    }
    
    private func setupProjectName() {
        containerView.addSubview(projectName)
        projectName.numberOfLines = 1
        projectName.autoAlignAxis(.horizontal, toSameAxisOf: projectIcon)
        projectName.autoPinEdge(.left, to: .right, of: projectIcon, withOffset: 12)
        projectName.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
    }
    
    private func setupProjectSpecialization() {
        containerView.addSubview(projectSpecialization)
        projectSpecialization.numberOfLines = 1
        projectSpecialization.autoPinEdge(.top, to: .bottom, of: projectIcon, withOffset: 8)
        projectSpecialization.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }
    
    private func setupProjectDescription() {
        containerView.addSubview(projectDescription)
        projectDescription.numberOfLines = 5
        projectDescription.lineBreakMode = .byTruncatingTail
        projectDescription.autoPinEdge(.top, to: .bottom, of: projectSpecialization, withOffset: 8)
        projectDescription.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        projectDescription.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
    }
    
    private func setupProjectReadinessStage() {
        containerView.addSubview(projectReadinessStageView)
        projectReadinessStage.numberOfLines = 1
        projectReadinessStageView.layer.cornerRadius = 8
        projectReadinessStageView.addSubview(projectReadinessStage)
        projectReadinessStage.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6))
        projectReadinessStageView.autoPinEdge(.top, to: .bottom, of: projectDescription, withOffset: 8)
        projectReadinessStageView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        projectReadinessStageView.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)
    }
    
    private func setupProjectrReadinessDate() {
        containerView.addSubview(projectRedinessDate)
        projectRedinessDate.autoPinEdge(.top, to: .bottom, of: projectReadinessStageView, withOffset: 12)
        projectRedinessDate.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        projectRedinessDate.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }

    private func setupRoleLabel() {
        containerView.addSubview(roleLabel)
        roleLabel.autoPinEdge(.top, to: .bottom, of: projectRedinessDate, withOffset: 12)
        roleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        roleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }

    private func setupActionsView() {
        containerView.addSubview(actionsView)
        actionsView.autoPinEdge(.top, to: .bottom, of: roleLabel, withOffset: 12)
        actionsView.axis = .horizontal
        actionsView.spacing = 0
        actionsView.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        actionsView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        actionsView.distribution = .fillProportionally
        actionsView.alignment = .leading
        actionsView.addArrangedSubview(chatButton)
        actionsView.addArrangedSubview(findUsersButton)
        actionsView.addArrangedSubview(editButton)
        actionsView.addArrangedSubview(deleteButton)
        actionsView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        
        deleteButton.addTarget(self, action: #selector(handleDeleteButtonTap), for: .touchUpInside)
        deleteButton.setAttributedTitle("Удалить".styled(.label, textColor: .red), for: .normal)

        editButton.addTarget(self, action: #selector(handleEditButtonTap), for: .touchUpInside)
        editButton.setAttributedTitle("Редактировать".styled(.label, textColor: .orange), for: .normal)

        chatButton.addTarget(self, action: #selector(handleChatButtonTap), for: .touchUpInside)
        chatButton.setAttributedTitle("Чат".styled(.label, textColor: .red), for: .normal)

        findUsersButton.addTarget(self, action: #selector(handleFindUserButtonTap), for: .touchUpInside)
        findUsersButton.setAttributedTitle(
            "Найти команду".styled(.label, textColor: UIColor.Brand.green), for: .normal
        )
    }

    func bindModel(model: Project) {
        projectID = model.id
        projectName.attributedText = model.name.styled(.title1)
        projectDescription.attributedText = model.description.styled(.label)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "MMM yyyy"
        projectRedinessDate.attributedText = "Дата запуска: \(formatter.string(from: model.launchDate))".styled(.label)
        projectIcon.sd_setImage(with: model.imageURL)
        projectReadinessStage.attributedText = model.readinessStage.description.styled(.body)
        projectReadinessStageView.backgroundColor = model.readinessStage.color
        projectSpecialization.attributedText = model.industry.capitalizingFirstLetter().styled(
            .label,
            textColor: UIColor.Brand.black.withAlphaComponent(0.7)
        )

        roleLabel.attributedText = model.role?.description.styled(.label, textColor: model.role?.color)
        layoutIfNeeded()

        model.role.map {
            switch $0 {
            case .applicant:
                editButton.isHidden = true
                deleteButton.isHidden = true
                chatButton.isHidden = true
                findUsersButton.isHidden = true
            case .owner:
                editButton.isHidden = false
                deleteButton.isHidden = false
                chatButton.isHidden = true
                findUsersButton.isHidden = false
            case .participant:
                editButton.isHidden = true
                deleteButton.isHidden = true
                chatButton.isHidden = false
                findUsersButton.isHidden = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isUserInteractionEnabled = false
        let duration = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.isUserInteractionEnabled = true
            self?.applyState(isHighlighted: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration / 4) {
                self?.didPressHandler?()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        applyState(isHighlighted: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        applyState(isHighlighted: false)
    }
    
    private func applyState(isHighlighted: Bool) {
        let transform = isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseIn],
            animations: {
                self.containerView.transform = transform
            }
        )
    }
}

