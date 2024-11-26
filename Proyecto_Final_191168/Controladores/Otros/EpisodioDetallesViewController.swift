//
// EpisodioDetallesViewController.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import UIKit

/// View Controller para mostrar los detalles de un episodio 
final class EpisodioDetallesViewController: UIViewController, EpisodioDetallesViewViewModelDelegate, EpisodioDetallesViewDelegate {
    private let viewModel: EpisodioDetallesViewViewModel

    private let detailView = EpisodioDetallesView()

    // MARK: - Init

    init(url: URL?) {
        self.viewModel = EpisodioDetallesViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        addConstraints()
        detailView.delegate = self
        title = "Episode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))

        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapShare() {

    }

    // MARK: - View Delegate

    func rmEpisodioDetallesView(
        _ detailView: EpisodioDetallesView,
        didSelect character: Personaje
    ) {
        let vc = EpisodioDetallesViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ViewModel Delegate

    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}