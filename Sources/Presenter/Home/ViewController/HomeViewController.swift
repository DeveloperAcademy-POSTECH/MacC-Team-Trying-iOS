//
//  HomeViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit
import Lottie

final class HomeViewController: BaseViewController {
    
    var homeDetailView = HomeDetailView()
    
    override func loadView() {
        view = homeDetailView
    }
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setAttributes()

    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let screenHeight = UIScreen.main.bounds.height
        if gesture.state == .changed {
            UIView.animate(withDuration: 0.7) {
                self.homeDetailView.constellationCollectionView.alpha = 0
                let scale = CGAffineTransform(scaleX: 0.5, y: 0.5).translatedBy(x: 0, y: -screenHeight)
                self.homeDetailView.myPlanetImage.transform = scale
            }
        } else if gesture.state == .ended {
            if translation.y > -screenHeight / 5 {
                UIView.animate(withDuration: 0.5) {
                    self.homeDetailView.myPlanetImage.transform = .identity
                    self.homeDetailView.constellationCollectionView.alpha = 1
                }
            } else {
                self.homeDetailView.constellationCollectionView.isHidden = true
                self.homeDetailView.myPlanetImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPlanetImageTapped)))
                self.homeDetailView.homeLottie.stop()
            }
        }
    }
    
    @objc
    func myPlanetImageTapped() {
        UIView.animate(withDuration: 0.5) {
            self.homeDetailView.constellationCollectionView.isHidden = false
            self.homeDetailView.constellationCollectionView.alpha = 1
            self.homeDetailView.myPlanetImage.transform = .identity
            self.homeDetailView.homeLottie.play()
        }
    }
    
    @objc
    func courseRsgistrationButtonTapped() {
        print("코스등록하기 버튼이 눌림")
    }
}

// MARK: - UI
extension HomeViewController {
    func setAttributes() {
        let layout = CustomLayout(numberOfColumns: homeDetailView.viewModel.numberOfColum)
        layout.delegate = self
        homeDetailView.constellationCollectionView.collectionViewLayout = layout
        homeDetailView.constellationCollectionView.dataSource = self
        homeDetailView.courseRegistrationButton.addTarget(self, action: #selector(courseRsgistrationButtonTapped), for: .touchUpInside)
        homeDetailView.myPlanetImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = homeDetailView.viewModel.constellations.count
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstellationCollectionViewCell.identifier, for: indexPath) as? ConstellationCollectionViewCell else { return UICollectionViewCell() }
        cell.constellation = homeDetailView.viewModel.constellations[indexPath.row]
        return cell
    }
}

extension HomeViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellDynamicHeight = CGFloat((homeDetailView.viewModel.constellations[indexPath.row].image?.size.height ?? 0)) / 4
        return cellDynamicHeight
    }
}
