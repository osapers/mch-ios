//
//  File.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import Foundation
import UIKit
import SDWebImage

extension EventViewController {
    
    func setupViews() {
        view.backgroundColor = .white
        setupEventIcon()
        setupEventName()
        setupEventDescription()
        setupEventType()
        setupEventDate()
        setupEventAddress()
        setupEventEmail()
        setupParticipateButton()
        setupWebsiteLabel()
        navigationItem.title = "Мероприятие"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "На карте",
            style: .plain,
            target: self,
            action: #selector(openMap)
        )
    }
    
    private func setupEventIcon() {
        view.addSubview(iconView)
        iconView.autoSetDimensions(to: CGSize(width: 48, height: 48))
        iconView.layer.cornerRadius = 24
        iconView.clipsToBounds = true
        iconView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        iconView.autoPinEdge(toSuperviewMargin: .top, withInset: 16)
        iconView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
    
    private func setupEventName() {
        view.addSubview(nameLabel)
        nameLabel.numberOfLines = 1
        nameLabel.autoAlignAxis(.horizontal, toSameAxisOf: iconView)
        nameLabel.autoPinEdge(.left, to: .right, of: iconView, withOffset: 12)
        nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
    }
    
    private func setupEventDescription() {
        view.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.enabledTextCheckingTypes = NSTextCheckingAllSystemTypes
        descriptionLabel.delegate = self
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: iconView, withOffset: 8)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
    }
    
    private func setupEventType() {
        view.addSubview(eventTypeView)
        eventTypeLabel.numberOfLines = 1
        eventTypeView.layer.cornerRadius = 8
        eventTypeView.addSubview(eventTypeLabel)
        eventTypeLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
        eventTypeView.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 8)
        eventTypeView.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        eventTypeView.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)
    }
    
    private func setupEventDate() {
        view.addSubview(dateLabel)
        dateLabel.autoPinEdge(.top, to: .bottom, of: eventTypeLabel, withOffset: 8)
        dateLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 16)
        dateLabel.autoPinEdge(.right, to: .right, of: view, withOffset: -16)
    }
    
    private func setupEventAddress() {
        view.addSubview(addressLabel)
        addressLabel.autoPinEdge(.top, to: .bottom, of: dateLabel, withOffset: 8)
        addressLabel.numberOfLines = 0
        addressLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        addressLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)
    }
    
    private func setupEventEmail() {
        view.addSubview(emailLabel)
        emailLabel.autoPinEdge(.top, to: .bottom, of: addressLabel, withOffset: 8)
        emailLabel.numberOfLines = 0
        emailLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 16)
        emailLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)
        emailLabel.enabledTextCheckingTypes = NSTextCheckingAllSystemTypes
        emailLabel.delegate = self
    }
    
    private func setupWebsiteLabel() {
        view.addSubview(websiteLabel)
        websiteLabel.autoPinEdge(.top, to: .bottom, of: emailLabel, withOffset: 8)
        websiteLabel.numberOfLines = 0
        websiteLabel.autoPinEdge(.left, to: .left, of: view, withOffset: 16)
        websiteLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16, relation: .greaterThanOrEqual)
        websiteLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 80, relation: .greaterThanOrEqual)
        websiteLabel.enabledTextCheckingTypes = NSTextCheckingAllSystemTypes
        websiteLabel.delegate = self
    }
    
    
    private func setupParticipateButton() {
        view.addSubview(participateButton)
        participateButton.autoSetDimension(.height, toSize: 48)
        participateButton.tintColor = .white
        participateButton.layer.cornerRadius = 8
        participateButton.setTitle("Принять участие", for: .normal)
        participateButton.backgroundColor = UIColor.Brand.green
        participateButton.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        participateButton.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        participateButton.autoPinEdge(toSuperviewMargin: .bottom, withInset: 16)
    }
}
