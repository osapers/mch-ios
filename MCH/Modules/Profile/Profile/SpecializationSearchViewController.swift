//
//  SpecializationSearchViewController.swift
//  MCH
//
//  Created by  a.khodko on 13.06.2021.
//

import Combine
import UIKit
import PureLayout

class SpecializationSearchViewController: UIViewController {

    private lazy var specializationSubject = PassthroughSubject<String, Never>()
    private lazy var specializationTableView = UITableView().configureForAutoLayout()
    private lazy var searchBar = UITextField().configureForAutoLayout()
    private var cancellableBag: [AnyCancellable] = []
    var specializationPublisher: AnyPublisher<String, Never> {
        specializationSubject.eraseToAnyPublisher()
    }
    var currentSpecializations: [String] = []
    var specializations: [String] = []
    private lazy var userService = dependencies.userService()
    var task: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Специализации"
        view.addSubview(specializationTableView)
        view.addSubview(searchBar)
        searchBar.autoPinEdge(toSuperviewMargin: .top, withInset: 8)
        searchBar.autoSetDimension(.height, toSize: 48)
        searchBar.borderStyle = .roundedRect
        searchBar.autocorrectionType = .no

        searchBar.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        searchBar.autoPinEdge(toSuperviewEdge: .right, withInset: 16)

        specializationTableView.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 12)
        specializationTableView.autoPinEdge(toSuperviewMargin: .bottom)
        specializationTableView.autoPinEdge(toSuperviewEdge: .left, withInset: 8)
        specializationTableView.autoPinEdge(toSuperviewEdge: .right, withInset: 8)
        specializationTableView.tableFooterView = UIView()
        specializationTableView.clipsToBounds = false
        specializationTableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -16)

        searchBar.placeholder = "Введите Вашу специализацию"
        searchBar.addTarget(self, action: #selector(searchBarTextFieldChange), for: .editingChanged)

        extendedLayoutIncludesOpaqueBars = false

        view.backgroundColor = .white
        specializationTableView.delegate = self
        specializationTableView.dataSource = self
        specializationTableView.reloadData()
    }
}

extension SpecializationSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        specializations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "specialization")
            ?? UITableViewCell(style: .default, reuseIdentifier: "specialization")
        cell.textLabel?.attributedText = specializations[indexPath.row].styled(.label)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let specialization = specializations[indexPath.row]
        specializationSubject.send(specialization)
        currentSpecializations.append(specialization)
        specializations.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension SpecializationSearchViewController {
    
    @objc func searchBarTextFieldChange() {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.count > 2 else { return }
        task?.cancel()
        task = DispatchWorkItem { [weak self] in
            if let self = self {
                self.userService.getSpecializations(query: text)
                    .sink { _ in } receiveValue: { [weak self] result in
                        if let self = self {
                            self.specializations = result.filter { !self.currentSpecializations.contains($0) }
                            self.specializationTableView.reloadData()
                        }
                    }
                    .store(in: &self.cancellableBag)
            }
        }
        task.map {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: $0)
        }
    }
}
