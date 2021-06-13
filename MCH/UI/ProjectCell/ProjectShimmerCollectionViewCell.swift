//
//  ProjectShimmerCollectionViewCell.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import UIKit
import PureLayout
import UIView_Shimmer

class ProjectShimmerCollectionViewCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    let containerView = UIView().configureForAutoLayout()
    let eventIcon = UIView().configureForAutoLayout()
    let eventName = UIView().configureForAutoLayout()
    let eventDescription = UIView().configureForAutoLayout()
    let eventType = UIView().configureForAutoLayout()
    let eventDate = UIView().configureForAutoLayout()
    let shadowView = UIView().configureForAutoLayout()
    
    private var didPressHandler: (() -> Void)?
    
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
        eventIcon.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
    }
    
    private func setupEventName() {
        containerView.addSubview(eventName)
        eventName.autoSetDimension(.height, toSize: 24)
        eventName.autoAlignAxis(.horizontal, toSameAxisOf: eventIcon)
        eventName.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        eventName.autoPinEdge(.left, to: .right, of: eventIcon, withOffset: 12)
    }
    
    private func setupEventDescription() {
        containerView.addSubview(eventDescription)
        eventDescription.autoSetDimension(.height, toSize: 48)
        eventDescription.autoPinEdge(.top, to: .bottom, of: eventIcon, withOffset: 8)
        eventDescription.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        eventDescription.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }
    
    private func setupEventType() {
        containerView.addSubview(eventType)
        eventType.autoSetDimensions(to: CGSize(width: 64, height: 24))
        eventType.autoPinEdge(.top, to: .bottom, of: eventDescription, withOffset: 8)
        eventType.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }
    
    private func setupEventDate() {
        containerView.addSubview(eventDate)
        eventDate.autoSetDimensions(to: CGSize(width: 84, height: 24))
        eventDate.autoPinEdge(.top, to: .bottom, of: eventType, withOffset: 8)
        eventDate.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        eventDate.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }
    
    var shimmeringAnimatedItems: [UIView] {
        [
            eventIcon,
            eventName,
            eventDescription,
            eventType,
            eventDate
        ]
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
