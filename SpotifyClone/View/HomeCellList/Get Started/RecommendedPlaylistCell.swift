//
//  RecommendedPlaylistCell.swift
//  SpotifyClone
//
//  Created by Warln on 03/04/22.
//

import UIKit
import SDWebImage

class RecommendedPlaylistCell: UICollectionViewCell {
    static let identifier = "RecommendedPlaylistCell"
    
    private let posterImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "photo")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let TrackNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        return lbl
    }()
    
    
    private let artistNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .thin)
        return lbl
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(posterImg)
        contentView.addSubview(TrackNameLbl)
        contentView.addSubview(artistNameLbl)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImg.frame = CGRect(
            x: 5,
            y: 2,
            width: contentView.height - 4,
            height: contentView.height - 4
        )
        TrackNameLbl.frame = CGRect(
            x: posterImg.right+10,
            y: 0,
            width: contentView.width-posterImg.right-15,
            height: contentView.height/2
        )
        
        artistNameLbl.frame = CGRect(
            x: posterImg.right+10,
            y: contentView.height/2,
            width: contentView.width-posterImg.right-15,
            height: contentView.height/2
        )

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImg.image = nil
        self.TrackNameLbl.text = nil
    }
    
    func configure(with viewModel: RecommendViewModel ) {
        guard let url = viewModel.imageUrl else {return}
        posterImg.sd_setImage(with: url, completed: nil)
        TrackNameLbl.text = viewModel.name
        artistNameLbl.text = viewModel.artistName
    }
}
