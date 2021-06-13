//
//  ProjectCollectionViewCell.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import PureLayout
import SDWebImage

class ProjectTinderView: UIView {
    
    let projectIcon = UIImageView().configureForAutoLayout()
    let projectName = UILabel().configureForAutoLayout()
    let projectSpecialization = UILabel().configureForAutoLayout()
    let projectDescription = UILabel().configureForAutoLayout()
    let projectReadinessStage = UILabel().configureForAutoLayout()
    let projectReadinessStageView = UIView().configureForAutoLayout()
    let projectRedinessDate = UILabel().configureForAutoLayout()
    let tagsTitle = UILabel().configureForAutoLayout()
    let tagsStackView = UIStackView().configureForAutoLayout()
    let ownerView = UIView().configureForAutoLayout()
    let ownerName = UILabel().configureForAutoLayout()
    let ownerImage = UIImageView().configureForAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProjectIcon()
        setupProjectName()
        setupProjectSpecialization()
        setupProjectDescription()
        setupProjectReadinessStage()
        setupProjectrReadinessDate()
        setupTagsTitle()
        setupTagsStackView()
        setupOwnerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupProjectIcon() {
        addSubview(projectIcon)
        projectIcon.autoSetDimensions(to: CGSize(width: 48, height: 48))
        projectIcon.layer.cornerRadius = 24
        projectIcon.clipsToBounds = true
        projectIcon.contentMode = .scaleAspectFit
        projectIcon.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        projectIcon.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
    }
    
    private func setupProjectName() {
        addSubview(projectName)
        projectName.numberOfLines = 1
        projectName.autoAlignAxis(.horizontal, toSameAxisOf: projectIcon)
        projectName.autoPinEdge(.left, to: .right, of: projectIcon, withOffset: 12)
        projectName.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
    }
    
    private func setupProjectSpecialization() {
        addSubview(projectSpecialization)
        projectSpecialization.numberOfLines = 1
        projectSpecialization.autoPinEdge(.top, to: .bottom, of: projectIcon, withOffset: 8)
        projectSpecialization.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }
    
    private func setupProjectDescription() {
        addSubview(projectDescription)
        projectDescription.numberOfLines = 5
        projectDescription.autoPinEdge(.top, to: .bottom, of: projectSpecialization, withOffset: 8)
        projectDescription.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        projectDescription.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
    }
    
    private func setupProjectReadinessStage() {
        addSubview(projectReadinessStageView)
        projectReadinessStage.numberOfLines = 1
        projectReadinessStageView.layer.cornerRadius = 8
        projectReadinessStageView.addSubview(projectReadinessStage)
        projectReadinessStage.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6))
        projectReadinessStageView.autoPinEdge(.top, to: .bottom, of: projectDescription, withOffset: 8)
        projectReadinessStageView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        projectReadinessStageView.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)
    }
    
    private func setupProjectrReadinessDate() {
        addSubview(projectRedinessDate)
        projectRedinessDate.autoPinEdge(.top, to: .bottom, of: projectReadinessStageView, withOffset: 12)
        projectRedinessDate.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        projectRedinessDate.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }

    private func setupTagsTitle() {
        addSubview(tagsTitle)
        tagsTitle.autoPinEdge(.top, to: .bottom, of: projectRedinessDate, withOffset: 12)
        tagsTitle.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        tagsTitle.attributedText = "Специализации".styled(.title1)
    }

    private func setupTagsStackView() {
        addSubview(tagsStackView)
        tagsStackView.autoPinEdge(.top, to: .bottom, of: tagsTitle, withOffset: 12)
        tagsStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        tagsStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        tagsStackView.alignment = .leading
        tagsStackView.axis = .vertical
        tagsStackView.spacing = 8
    }

    func setupOwnerView() {
        addSubview(ownerView)
        ownerView.autoSetDimension(.height, toSize: 64)
        ownerView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        ownerView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        ownerView.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        ownerView.addSubview(ownerName)
        ownerView.addSubview(ownerImage)
        ownerImage.autoPinEdge(toSuperviewEdge: .left)
        ownerImage.autoSetDimensions(to: CGSize(width: 64, height: 64))
        ownerImage.autoAlignAxis(toSuperviewAxis: .horizontal)
        ownerImage.contentMode = .scaleAspectFit
        ownerImage.clipsToBounds = true
        ownerImage.layer.cornerRadius = 32
        
        ownerName.numberOfLines = 0
        ownerName.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .left)
        ownerName.autoPinEdge(.left, to: .right, of: ownerImage, withOffset: 12)
    }

    func bindModel(model: Project) {
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

        if model.tagsIntersection?.isEmpty == true || model.tagsIntersection == nil {
            tagsTitle.isHidden = true
        }

        model.tagsIntersection?.forEach { tag in
            tagsStackView.addArrangedSubview(makeViewForSpecializaton(tag))
        }
        let owner = model.owner
        if owner.lastName == "" || owner.firstName == "" {
            ownerView.isHidden = true
        }
        ownerImage.image = owner.image.map { UIImage(base64String: $0) ?? UIImage(named: "Profile")! }
            ?? UIImage(named: "Profile")!
        ownerName.attributedText = (owner.firstName + "\n" + owner.lastName).styled(.label)
        layoutIfNeeded()
    }

    private func makeViewForSpecializaton(_ specialization: String) -> UIView {
        let colors = [
            UIColor.Brand.backgroundBlue,
            UIColor.Brand.backgroundRed,
            UIColor.Brand.backgroundGreen,
            UIColor.Brand.backgroundOrange,
            UIColor.Brand.backgroundViolet,
            UIColor.Brand.backgroundYellow
        ]

        let specializationView = UIView()
        let specializationLabel = UILabel().configureForAutoLayout()
        specializationView.addSubview(specializationLabel)
        specializationLabel.autoPinEdgesToSuperviewEdges(
            with: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        )

        specializationLabel.attributedText = specialization.styled(.label)
        specializationView.backgroundColor = colors.randomElement()
        specializationView.layer.cornerRadius = 8
        return specializationView
    }
}
