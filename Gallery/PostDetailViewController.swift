//
//  PostDetailViewController.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/13/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import Kingfisher

class PostDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let model = PostDetailViewModel()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        bond()
    }
    
    func bond() {
        model.title.bind(to: titleLabel.reactive.text)
        model.body.bind(to: bodyTextView.reactive.text)
        _ = model.albumsRepository.observeNext { (_) in
            self.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.albumsRepository.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let album = model.albumsRepository[section]
        if album.active.value {
            return album.photos.value.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        let photo = model.albumsRepository[indexPath.section].photos.value[indexPath.row]
        let dispo = photo.url.observeNext { (url) in
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: url)
        }
        
        dispo.dispose(in: cell.bag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionReusableView
        cell.bag.dispose()
        
        let album = model.albumsRepository[indexPath.section]
        album.title.bind(to: cell.titleLabel.reactive.text).dispose(in: cell.bag)
        cell.backgroundColor = UIColor(hexString: PFColorHash().hex(album.title.value))
        cell.active = Observable<Bool>(album.active.value)
        
        let dist = cell.active!.observeNext { (active) in
            if album.active.value != active {
                album.active.value = active
                self.model.albumsRepository[indexPath.section] = album
            }
        }
        
        dist.dispose(in: cell.bag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
}
