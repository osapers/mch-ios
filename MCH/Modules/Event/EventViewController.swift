//
//  EventViewController.swift
//  MCH
//
//  Created by  a.khodko on 12.06.2021.
//

import UIKit
import Combine
import SDWebImage
import EventKit
import TTTAttributedLabel
import MapKit

class EventViewController: UIViewController {
    
    var event: Event!
    
    private let eventStore = EKEventStore()
    private lazy var eventsParticipationService = dependencies.eventsParticipationService
    private var cancellableBag: [AnyCancellable] = []
    
    let iconView = UIImageView().configureForAutoLayout()
    let nameLabel = UILabel().configureForAutoLayout()
    let descriptionLabel = TTTAttributedLabel(frame: .zero).configureForAutoLayout()
    let eventTypeLabel = UILabel().configureForAutoLayout()
    let eventTypeView = UIView().configureForAutoLayout()
    let dateLabel = UILabel().configureForAutoLayout()
    let addressLabel = UILabel().configureForAutoLayout()
    let emailLabel = TTTAttributedLabel(frame: .zero).configureForAutoLayout()
    let websiteLabel = TTTAttributedLabel(frame: .zero).configureForAutoLayout()
    let participateButton = UIButton().configureForAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindModel(model: event)
        participateButton.addTarget(self, action: #selector(handlePatricipateButtonTap), for: .touchUpInside)
    }
    
    @objc func openMap() {
        let place = MKMapItem(
            placemark: MKPlacemark(
                coordinate: CLLocationCoordinate2D(
                    latitude: event.address.latitude,
                    longitude: event.address.longitude
                )
            )
        )
        
        MKMapItem.openMaps(with: [place], launchOptions: nil)
    }
    
    @objc private func handlePatricipateButtonTap() {
        let loadingView = startLoading()
        
        eventsParticipationService
            .participateInEvent(event)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.handleError(error: error, loadingView: loadingView)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.stopLoading(loadingView: loadingView)
                let alert = UIAlertController(title: "Добавить событие в календарь?", message: "Это позволит Вам не забыть о мероприятии", preferredStyle: .alert)
                let addToCalendarAction = UIAlertAction(title: "Да", style: .default) { _ in
                    self.handleAddToCalendar()
                }
                alert.addAction(addToCalendarAction)
                let cancelAction = UIAlertAction(title: "Нет", style: .destructive) { _ in
                    self.updateParticipateButton()
                }
                alert.addAction(cancelAction)
                return self.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellableBag)
    }
    
    private func handleAddToCalendar() {
        updateParticipateButton()
        eventStore.requestAccess(to: .event) { (granted, error) in
            DispatchQueue.main.async {
                guard granted, error == nil else {
                    let alert = UIAlertController(title: "Ошибка", message: "Предоставьте доступ к календарю", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    alert.addAction(action)
                    return self.present(alert, animated: true, completion: nil)
                }
                
                let event = EKEvent(eventStore: self.eventStore)
                
                event.title = self.event.name
                event.startDate = self.event.date
                event.endDate = self.event.date
                
                event.notes = self.event.longDescription
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                    let alert = UIAlertController(title: "Успешно", message: "Событие было добавлено в Ваш календарь", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    alert.addAction(action)
                    return self.present(alert, animated: true, completion: nil)
                } catch let error as NSError {
                    let alert = UIAlertController(title: "Ошибка", message: "\(error.description)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    alert.addAction(action)
                    return self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func updateParticipateButton() {
        UIView.animate(withDuration: 0.5) {
            self.setIsPariticipating()
        } completion: { _ in }
    }
    
    private func setIsPariticipating() {
        participateButton.setTitle("Вы участвуете", for: .normal)
        participateButton.tintColor = UIColor.Brand.green
        participateButton.setTitleColor(UIColor.Brand.green, for: .normal)
        participateButton.backgroundColor = .white
        participateButton.isUserInteractionEnabled = false
    }
    
    private func bindModel(model: Event) {
        nameLabel.attributedText = model.name.styled(.title1)
        descriptionLabel.text = model.longDescription.styled(.body)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE, d MMM"
        dateLabel.attributedText = formatter.string(from: model.date).capitalizingFirstLetter().styled(.label)
        iconView.sd_setImage(with: model.imageURL)
        eventTypeLabel.attributedText = model.type.description.styled(.label)
        eventTypeView.backgroundColor = model.type.color
        addressLabel.attributedText = "Адрес: \(model.address.description)".styled(.label)
        emailLabel.text = "Электронная почта: \(model.email)".styled(.label)
        websiteLabel.text = "Сайт: \(model.website)".styled(.label)
        if model.isParticipating {
            setIsPariticipating()
        }
    }
}

// MARK: - TTTAttributedLabelDelegate
extension EventViewController: TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        phoneNumber.map {
            UIApplication.shared.open(URL(string: "tel://\($0)")!)
        }
    }
}
