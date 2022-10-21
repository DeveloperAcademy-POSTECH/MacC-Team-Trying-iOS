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
    var viewModel: HomeViewModel
    var changeMyPlanetScale: Double = 0.5
    var screenHeight = UIScreen.main.bounds.height - 20
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeDetailView
    }
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setAttributes()
    }
    
    func changeMyPlanet(center: CGPoint, myPlanetTransform: CGAffineTransform, constellationAlpha: CGFloat) {
        self.homeDetailView.myPlanetImage.center = center
        self.homeDetailView.myPlanetImage.transform = myPlanetTransform
        self.homeDetailView.constellationCollectionView.alpha = constellationAlpha
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let myPlanet = self.homeDetailView.myPlanetImage
        let imageCenterY = myPlanet.center.y
        let imageCenterX = myPlanet.center.x
        let translation = gesture.translation(in: myPlanet)
        gesture.setTranslation(.zero, in: myPlanet)
        if gesture.state == .changed {
            if abs(gesture.velocity(in: myPlanet).y) > abs(gesture.velocity(in: myPlanet).x) {
                changeMyPlanet(center: CGPoint(x: imageCenterX,
                                               y: min(max(imageCenterY + translation.y, screenHeight/2), screenHeight)),
                               myPlanetTransform: CGAffineTransform(scaleX: changeScale(xPoint: imageCenterY), y: changeScale(xPoint: imageCenterY)),
                               constellationAlpha: changeAlpht(xPoint: imageCenterY))
            }
        } else if gesture.state == .ended {
            if imageCenterY > screenHeight * 6/7 {
                UIView.animate(withDuration: 0.5) {
                    self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight), myPlanetTransform: .identity, constellationAlpha: 1)
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight/2),
                                        myPlanetTransform: CGAffineTransform(scaleX: self.changeMyPlanetScale, y: self.changeMyPlanetScale),
                                        constellationAlpha: 0)
                } completion: { _ in
                    self.homeDetailView.constellationCollectionView.isHidden = true
                    myPlanet.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureAfter)))
                }
            }
        }
    }
    
    @objc
    func handlePanGestureAfter(gesture: UIPanGestureRecognizer) {
        let myPlanet = self.homeDetailView.myPlanetImage
        let imageCenterX = myPlanet.center.x
        let imageCenterY = myPlanet.center.y
        let translation = gesture.translation(in: myPlanet)
        gesture.setTranslation(.zero, in: myPlanet)
        if gesture.state == .changed {
            if abs(gesture.velocity(in: myPlanet).y) > abs(gesture.velocity(in: myPlanet).x) {
                changeMyPlanet(center: CGPoint(x: imageCenterX, y: min(max(imageCenterY + translation.y, screenHeight/2), screenHeight)),
                               myPlanetTransform: CGAffineTransform(scaleX: changeScale(xPoint: imageCenterY), y: changeScale(xPoint: imageCenterY)),
                               constellationAlpha: changeAlpht(xPoint: imageCenterY))
                self.homeDetailView.constellationCollectionView.isHidden = false
            }
        } else if gesture.state == .ended {
            if self.homeDetailView.myPlanetImage.center.y < (screenHeight/2) * 7/6 {
                UIView.animate(withDuration: 0.3) {
                    self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight/2),
                                   myPlanetTransform: CGAffineTransform(scaleX: self.changeMyPlanetScale, y: self.changeMyPlanetScale),
                                   constellationAlpha: 0)
                    self.homeDetailView.constellationCollectionView.isHidden = true
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight), myPlanetTransform: CGAffineTransform(scaleX: 1, y: 1), constellationAlpha: 1)
                } completion: { _ in
                    myPlanet.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    
    @objc
    func courseRegistrationButtonTapped() {
        print("코스등록하기 버튼이 눌림")
        
    }
    
    @objc
    func alarmButtonTapped() {
        print("알림 버튼이 눌림")
        viewModel.pushToAlarmView()
    }
    
    func changeScale(xPoint: Double) -> CGFloat {
        return CGFloat(((xPoint * 0.5)/425)+0.0287)
    }
    
    func changeAlpht(xPoint: Double) -> CGFloat {
        return CGFloat((xPoint/400)-1.1125)
    }
}

// MARK: - UI
extension HomeViewController {
    func setAttributes() {
        let layout = CustomLayout(numberOfColumns: viewModel.numberOfColum)
        homeDetailView.constellationCollectionView.collectionViewLayout = layout
        layout.delegate = self
        homeDetailView.constellationCollectionView.dataSource = self
        homeDetailView.constellationCollectionView.dragInteractionEnabled = true
        
        homeDetailView.courseRegistrationButton.addTarget(self, action: #selector(courseRegistrationButtonTapped), for: .touchUpInside)
        homeDetailView.myPlanetImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        homeDetailView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel.constellations.count
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstellationCollectionViewCell.identifier, for: indexPath) as? ConstellationCollectionViewCell else { return UICollectionViewCell() }
        cell.constellation = viewModel.constellations[indexPath.row]
        return cell
    }
}

extension HomeViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellDynamicHeight = CGFloat((viewModel.constellations[indexPath.row].image?.size.height ?? 0)) / 4
        return cellDynamicHeight
    }
}

