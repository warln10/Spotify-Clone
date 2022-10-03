 //
//  HomeVC.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import UIKit

enum BrowseSectionData {
    case newReleases(viewModel: [NewReleaseViewModel])
    case featurePlaylist(viewModel: [FeaturePlayViewModel])
    case recommendedTrack(viewModel: [RecommendViewModel])
    
    var title: String {
        switch self {
        case .newReleases:
            return "New Releases"
        case .featurePlaylist:
            return "Feature Playlist"
        case .recommendedTrack:
            return "Recommended"
            
        }
    }
}

class HomeVC: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeVC.createSectionLayout(section: sectionIndex)
        })
    )
    
    private var sections = [BrowseSectionData]()
    private var newAlbums: [Albums] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Get Started"
        setup()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // Setup & UI Configration
    func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didBtnTap)
        )
        configureCollection()
        view.addSubview(spinner)
        fetchData()
    }
    
    // Button Handler
    @objc
    func didBtnTap () {
        let vc = SettingVC()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Configure CollectionView
    private func configureCollection() {
        view.addSubview(collectionView)
        collectionView.register(NewReleaseCell.self, forCellWithReuseIdentifier: NewReleaseCell.identifier)
        collectionView.register(FeaturePlaylistCell.self, forCellWithReuseIdentifier: FeaturePlaylistCell.identifier)
        collectionView.register(RecommendedPlaylistCell.self, forCellWithReuseIdentifier: RecommendedPlaylistCell.identifier)
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    // Fetch Api Data
    func fetchData() {
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newRelease: NewReleaseResponse?
        var featurePlaylist: FeaturePlaylistResponse?
        var recommended: RecommendedResponse?
        // New Release
        APICaller.shared.getNewRelease { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newRelease = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // Feature Playlist
        APICaller.shared.getFeaturedPlaylist { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featurePlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // Recommmed Track
        APICaller.shared.getRecommendationGeners { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APICaller.shared.getRecommendation(with: seeds) { result in
                    defer {
                        group.leave()
                    }
                    switch result {
                    case .success(let model):
                        recommended = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Group notify
        group.notify(queue: .main) { [weak self] in
            guard let newAblums = newRelease?.albums.items,
                  let playlists = featurePlaylist?.playlists.items,
                  let tracks = recommended?.tracks else {
                return
            }
            
            self?.configureModel(newAlbums: newAblums, playlists: playlists, tracks: tracks)
        }
    }
    
    
    private func configureModel(
        newAlbums: [Albums],
        playlists: [Playlist],
        tracks: [AudioTrack]
    ) {
        
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        sections.append(.newReleases(viewModel: newAlbums.compactMap({
            return NewReleaseViewModel(
                name: $0.name,
                imageUrl: URL(string: $0.images.first?.url ?? ""),
                numberOfTrack: $0.total_tracks,
                artistName: $0.artists.first?.name ?? ""
            )
        })))
        sections.append(.featurePlaylist(viewModel: playlists.compactMap({
            return FeaturePlayViewModel(name: $0.name, imageUrl: URL(string: $0.images.first?.url ?? ""), createName: "")
        })))
        sections.append(.recommendedTrack(viewModel: tracks.compactMap({
            return RecommendViewModel(
                name: $0.name,
                artistName: $0.artists.first?.name ?? "Unknown",
                imageUrl: URL(string: $0.album?.images.first?.url ?? "")
            )
        })))
        collectionView.reloadData()
    }
    

    
    
}


//MARK: -  UITableView DataSource
extension HomeVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(let viewModel):
            return viewModel.count
        case .featurePlaylist(let viewModel):
            return viewModel.count
        case .recommendedTrack(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        let index = indexPath.row
        switch type {
        case .newReleases(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCell.identifier, for: indexPath) as? NewReleaseCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel[index])
            cell.backgroundColor = .red
            return cell
        case .featurePlaylist(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCell.identifier, for: indexPath) as? FeaturePlaylistCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel[index])
            return cell
        case .recommendedTrack(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedPlaylistCell.identifier, for: indexPath) as? RecommendedPlaylistCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel[indexPath.row])
            return cell
        }
    }
    
}

//MARK: - UICollectionView Delegate

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .newReleases:
            let albums = newAlbums[indexPath.row]
            let vc = AlbumVC(albums: albums)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = albums.name
            navigationController?.pushViewController(vc, animated: true)
        case .featurePlaylist:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistVC(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTrack: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderView.identifier,
            for: indexPath
        ) as? TitleHeaderView , kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    
}

//MARK: - UICollectionViewCompositionalLayout
extension HomeVC {
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementryView = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        switch section {
        case 0:
            // Items
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // Vertical And Horizontal Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: item,
                count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(360)
                ),
                subitem: verticalGroup,
                count: 1
            )
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementryView
            return section
        case 1:
            // Items
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(180),
                    heightDimension: .absolute(200)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // Vertical And Horizontal Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(180),
                    heightDimension: .absolute(400)
                ),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(180),
                    heightDimension: .absolute(400)
                ),
                subitem: verticalGroup,
                count: 1
            )
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementryView
            return section
        case 2:
            // Items
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // Vertical And Horizontal Group
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                ),
                subitem: item,
                count: 1
            )
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplementryView
            return section
        default:
            // Items
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // Vertical And Horizontal Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: item,
                count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(360)
                ),
                subitem: verticalGroup,
                count: 1
            )
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementryView
            return section
        }
        
    }
}
