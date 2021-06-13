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

    @objc private func handlePatricipateButtonTap() {
        let loadingView = startLoading()

        eventsParticipationService
            .participateInEvent(event)
            .sink { [weak self] error in
                switch error {
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
                    self.removeParticipateButton()
                }
                alert.addAction(cancelAction)
                return self.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellableBag)
    }

    private func handleAddToCalendar() {
        removeParticipateButton()
        eventStore.requestAccess(to: .event) { (granted, error) in
            DispatchQueue.main.async {
                guard granted, error == nil else {
                    let alert = UIAlertController(title: "Ошибка", message: "Предоставьте доступ к календарю", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
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

    private func removeParticipateButton() {
        UIView.animate(withDuration: 0.5) {
            self.participateButton.alpha = 0
        } completion: { _ in
            self.participateButton.removeFromSuperview()
        }
    }

    private func bindModel(model: Event) {
        nameLabel.text = model.name
        descriptionLabel.text = model.longDescription
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        dateLabel.text = formatter.string(from: model.date)
        iconView.sd_setImage(with: model.imageURL)
        eventTypeLabel.text = model.type.description
        eventTypeView.backgroundColor = model.type.color
        addressLabel.text = "Адрес: \(model.address.description)"
        emailLabel.text = "Электронная почта: \(model.email)"
        websiteLabel.text = "Сайт: \(model.website)"
        if model.isParticipating {
            participateButton.removeFromSuperview()
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
