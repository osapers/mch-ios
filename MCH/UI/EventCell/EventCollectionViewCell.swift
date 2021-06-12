//
//  EventCollectionViewCell.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit
import PureLayout
import SDWebImage

class EventCollectionViewCell: UICollectionViewCell {

    let containerView = UIView().configureForAutoLayout()
    let eventIcon = UIImageView().configureForAutoLayout()
    let eventName = UILabel().configureForAutoLayout()
    let eventDescription = UILabel().configureForAutoLayout()
    let eventType = UILabel().configureForAutoLayout()
    let eventTypeView = UIView().configureForAutoLayout()
    let eventDate = UILabel().configureForAutoLayout()
    let shadowView = UIView().configureForAutoLayout()

    var didPressHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContainerView()
        setupShadowView()
        setupEventIcon()
        setupEventName()
        setupEventDescription()
        setupEventType()
        setupEventDate()
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

    override func prepareForReuse() {
        eventIcon.sd_cancelCurrentImageLoad()
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

    private func setupEventIcon() {
        containerView.addSubview(eventIcon)
        eventIcon.autoSetDimensions(to: CGSize(width: 48, height: 48))
        eventIcon.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        eventIcon.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        eventIcon.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }

    private func setupEventName() {
        containerView.addSubview(eventName)
        eventName.numberOfLines = 1
        eventName.autoAlignAxis(.horizontal, toSameAxisOf: eventIcon)
        eventName.autoPinEdge(.left, to: .right, of: eventIcon, withOffset: 12)
        eventName.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
    }
    
    private func setupEventDescription() {
        containerView.addSubview(eventDescription)
        eventDescription.numberOfLines = 0
        eventDescription.autoPinEdge(.top, to: .bottom, of: eventIcon, withOffset: 8)
        eventDescription.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        eventDescription.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
    }
    
    private func setupEventType() {
        containerView.addSubview(eventTypeView)
        eventType.numberOfLines = 1
        eventTypeView.layer.cornerRadius = 8
        eventTypeView.addSubview(eventType)
        eventType.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        eventTypeView.autoPinEdge(.top, to: .bottom, of: eventDescription, withOffset: 8)
        eventTypeView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        eventTypeView.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)
    }
    
    private func setupEventDate() {
        containerView.addSubview(eventDate)
        eventDate.autoPinEdge(.top, to: .bottom, of: eventType, withOffset: 8)
        eventDate.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        eventDate.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        eventDate.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindModel(model: Event) {
        eventName.text = model.name
        eventDescription.text = model.shortDescription
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        eventDate.text = formatter.string(from: model.date)
        eventIcon.sd_setImage(with: model.imageURL)
        eventType.text = model.type.description
        eventTypeView.backgroundColor = model.type.color
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
