//
//  PlaylistVC.swift
//  SpotifyClone
//
//  Created by Warln on 24/04/22.
//

import UIKit

class PlaylistVC: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _ , _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
            // Vertical And Horizontal Group
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitem: item,
                count: 1
            )
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(1)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            ]
            return section
        })
    )
    
    private var playlist: Playlist
    private var viewModel: [RecommendViewModel] = []
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = playlist.name
        view.addSubview(collectionView)
        setup()
        collectionView.register(RecommendedPlaylistCell.self, forCellWithReuseIdentifier: RecommendedPlaylistCell.identifier)
        collectionView.register(
            CollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionHeaderView.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds

    }
    
    @objc
    private func didTapShare() {
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {return}
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func setup() {
        APICaller.shared.getPlaylistDetail(for: playlist) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.viewModel = model.tracks.items.compactMap({
                        RecommendViewModel(
                            name: $0.track.name,
                            artistName: $0.track.artists.first?.name ?? "Unknown",
                            imageUrl: URL(string: $0.track.album?.images.first?.url ?? "")
                        )
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    //
}

//MARK: - UICollectionView Datasource

extension PlaylistVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPlaylistCell.identifier, for: indexPath) as? RecommendedPlaylistCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionHeaderView.identifier,
            for: indexPath
        ) as? CollectionHeaderView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = HeaderViewModel(
            name: playlist.name,
            description: playlist.description,
            artist: playlist.owner.display_name,
            image: URL(string: playlist.images.first?.url ?? "")
        )
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
}

//MARK: - UICollectionView Delegate

extension PlaylistVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

//MARK: - CollectionHeaderViewDelegate

extension PlaylistVC: CollectionHeaderViewDelegate {
    func CollectionHeaderViewDidTapPlayAll(_ header: CollectionHeaderView) {
        print("play All")
        // Play All songs
    }
}
