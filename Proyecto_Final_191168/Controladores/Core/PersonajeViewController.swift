//
//  PersonajeViewController.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import UIKit

final class PersonajeViewController: UIViewController, PersonajeListViewDelegate {

  private let characterListView = PersonajeListView()

  override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
      title = "Characters"
      setUpView()
      addSearchButton()
  }

  private func addSearchButton() {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
  }

  @objc private func didTapSearch() {
      let vc = SearchViewController(config: SearchViewController.Config(type: .character))
      vc.navigationItem.largeTitleDisplayMode = .never
      navigationController?.pushViewController(vc, animated: true)
  }

  private func setUpView() {
      characterListView.delegate = self
      view.addSubview(characterListView)
      NSLayoutConstraint.activate([
          characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
          characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
          characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      ])
  }

  // MARK: - PersonajeListViewDelegate

  func rmPersonajeListView(_ characterListView: PersonajeListView, didSelectCharacter character: Personaje) {
      // Abre el controlador de detailes de ese personaje
      let viewModel = PersonajeDetailViewViewModel(character: character)
      let detailVC = PersonajeDetailViewController(viewModel: viewModel)
      detailVC.navigationItem.largeTitleDisplayMode = .never
      navigationController?.pushViewController(detailVC, animated: true)
  }
    
}
