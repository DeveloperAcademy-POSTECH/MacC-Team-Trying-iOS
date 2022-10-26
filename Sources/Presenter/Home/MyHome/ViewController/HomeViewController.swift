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

    private var carouselView: CarouselCollectionView?
    let homeDetailView = HomeDetailView()
    let viewModel: HomeViewModel
    let changeMyPlanetScale: Double = 0.5
    let screenHeight = DeviceInfo.screenHeight - 20
    
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
        carouselView = CarouselCollectionView(pages: viewModel.constellations.count, delegate: self)
        Task {
            try await viewModel.fetchAsync()
            self.homeDetailView.ddayLabel.text = viewModel.user?.nickName
        }
        
        bind()
        setAttributes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView?.configureView(with: viewModel.constellations)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
//     override func viewDidAppear(_ animated: Bool) {
//         super.viewDidAppear(animated)
//         carouselView?.configureView(with: viewModel.constellations)
//     }

    /// pangesture에 따라서 요소들을 변화시키는 함수
    /// - Parameters:
    ///   - center: 이미지의 center좌표
    ///   - myPlanetTransform: 어떻게 변할지, 주로 scale에 관한 값
    ///   - constellationAlpha: 제스처에따라 alpha값이 변하는 요소는 어떻값으로 변할지
    ///   - alreadyAlphaExist: 이미 alpha값을 가지고있는 요소는 같은 값을 공유할수없기때문에 다른 계산식이 필요하다
    private func changeMyPlanet(center: CGPoint, myPlanetTransform: CGAffineTransform, constellationAlpha: CGFloat, alreadyAlphaExist: CGFloat) {
        self.homeDetailView.myPlanetImage.center = center
        self.homeDetailView.myPlanetImage.transform = myPlanetTransform
        self.carouselView?.alpha = constellationAlpha
        self.homeDetailView.courseNameButton.alpha = constellationAlpha
        self.homeDetailView.currentImageBox.alpha = constellationAlpha
        self.homeDetailView.dateLabel.alpha = constellationAlpha
        self.homeDetailView.beforeImageButton.alpha = alreadyAlphaExist
        self.homeDetailView.afterImageButton.alpha = alreadyAlphaExist
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
                changeMyPlanet(center: CGPoint(x: imageCenterX, y: min(max(imageCenterY + translation.y, screenHeight / 2), screenHeight)),
                               myPlanetTransform: CGAffineTransform(scaleX: changeScale(yPoint: imageCenterY), y: changeScale(yPoint: imageCenterY)),
                               constellationAlpha: changeAlpha(yPoint: imageCenterY),
                               alreadyAlphaExist: changeAlpha(yPoint: imageCenterY, beforeAlpha: 0.2))
                
            }
        } else if gesture.state == .ended {
            if imageCenterY > screenHeight * 8 / 9 {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight), myPlanetTransform: .identity, constellationAlpha: 1, alreadyAlphaExist: 0.2)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight / 2),
                                            myPlanetTransform: CGAffineTransform(scaleX: self.changeMyPlanetScale, y: self.changeMyPlanetScale),
                                            constellationAlpha: 0,
                                            alreadyAlphaExist: 0)
                        self.homeDetailView.beforeImageButton.alpha = 0
                        self.homeDetailView.afterImageButton.alpha = 0
                    } completion: { _ in
                        myPlanet.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureAfter)))
                    }
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
                changeMyPlanet(center: CGPoint(x: imageCenterX, y: min(max(imageCenterY + translation.y, screenHeight / 2), screenHeight)),
                               myPlanetTransform: CGAffineTransform(scaleX: changeScale(yPoint: imageCenterY), y: changeScale(yPoint: imageCenterY)),
                               constellationAlpha: changeAlpha(yPoint: imageCenterY),
                               alreadyAlphaExist: changeAlpha(yPoint: imageCenterY, beforeAlpha: 0.2))
            }
        } else if gesture.state == .ended {
            if self.homeDetailView.myPlanetImage.center.y < (screenHeight / 2) * 7 / 6 {
                UIView.animate(withDuration: 0.3) {
                    self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight / 2),
                                        myPlanetTransform: CGAffineTransform(scaleX: self.changeMyPlanetScale, y: self.changeMyPlanetScale),
                                        constellationAlpha: 0,
                                        alreadyAlphaExist: 0)
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    self.changeMyPlanet(center: CGPoint(x: imageCenterX, y: self.screenHeight),
                                        myPlanetTransform: CGAffineTransform(scaleX: 1, y: 1),
                                        constellationAlpha: 1,
                                        alreadyAlphaExist: 0.2)
                } completion: { _ in
                    myPlanet.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    
    @objc
    func courseRegistrationButtonTapped() {
        viewModel.startAddCourseFlow()
    }
    
    @objc
    func alarmButtonTapped() {
        viewModel.pushToAlarmView()
    }
    
    @objc
    /// 데이터를 넘겨야해서 코디네이터 안씀 -> 추후 변경 예정
    func courseNameButtonTapped() {
        let nextVC = CoursesViewController()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = backBarButtonItem
        nextVC.courses = viewModel.constellations
        navigationController?.pushViewController(nextVC, animated: true)
    }

    @objc
    /// 버튼을 누르면 자동으로 다음 스크롤로 넘어가게 해주는 함수
    func beforeImageButtonTapped() {
        guard let carouselView = carouselView else { return }
        carouselView.currentPage -= 1
        carouselView.carouselCollectionView.scrollToItem(at: NSIndexPath(item: carouselView.currentPage, section: 0) as IndexPath, at: .left, animated: true)
    }
    
    @objc
    /// 버튼을 누르면 자동으로 이전 스크롤로 넘어가게 해주는 함수
    func afterImageButtonTapped() {
        guard let carouselView = carouselView else { return }
        carouselView.currentPage += 1
        carouselView.carouselCollectionView.scrollToItem(at: NSIndexPath(item: carouselView.currentPage, section: 0) as IndexPath, at: .right, animated: true)
    }
    
    /// 이미지의 center위치(y)값에 따라 곱해줄 scale값을 return해주는 함수
    /// - Parameter yPoint: 이미지center의 yPoint
    /// - Returns: 이미지에 곱해줄 scale값
    private func changeScale(yPoint: Double) -> CGFloat {
        // 기울기(기기의 크기별로 대응되도록 계산)
        let gradient = (2 * (1 - changeMyPlanetScale)) / screenHeight
        // 그래프의 y절편(1차함수기때문에 필요)
        let interceptionY = (2 * changeMyPlanetScale) - 1
        return CGFloat((gradient * yPoint) + interceptionY)
    }
    
    /// 이미지의 center(y)값에 따라 곱해줄 alpha값을 return해주는 함수
    /// - Parameter yPoint: 이미지center의 yPoint
    /// - Returns: 이미지에 곱해줄 alpha값
    private func changeAlpha(yPoint: Double) -> CGFloat {
        let gredient = 2 / screenHeight
        let interceptionY = -1.0
        return CGFloat((gredient * yPoint) + interceptionY)
    }
    
    /// 이미 alpha값을 가지고있는 요소의 alpha의 변화량을 return해주는 함수
    /// - Parameters:
    ///   - yPoint: 이미지center의 yPoint
    ///   - beforeAlpha: 기존에 가지고 있던 alpha값
    /// - Returns: 이미지에 곱해줄 alpha값
    private func changeAlpha(yPoint: Double, beforeAlpha: Double) -> CGFloat {
        let gredient = (2 * beforeAlpha) / screenHeight
        let interceptionY = -beforeAlpha
        return CGFloat((gredient * yPoint) + interceptionY)
    }
}

// MARK: - UI
extension HomeViewController {
    func setAttributes() {
        
        // MARK: 기본값 세팅
        homeDetailView.courseNameButton.setTitle(viewModel.constellations.first?.name, for: .normal)
        homeDetailView.dateLabel.text = viewModel.constellations.first?.data
        homeDetailView.currentImage.image = viewModel.constellations.first?.image

        // MARK: input으로 들어오는 String에 따라 width가 달라져야하기 때문에 ViewController에서 레이아웃을 잡아줌
        self.homeDetailView.courseNameButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(160)
            make.height.equalTo(44)
            guard let text = self.homeDetailView.courseNameButton.currentTitle else { return }
            make.width.equalTo((text as NSString).size().width + 90)
        }
        
        // MARK: CarouselView의 경우 viewController의 ViewModel에서 데이터를 받아서 처리해야하기때문에 ViewController에서 작업
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(homeDetailView.courseNameButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(homeDetailView.myPlanetImage.snp.top).offset(-120)
        }
        
        // MARK: 별자리가 1개라면 다음 별자리를 보여주는 버튼이 필요없음(제약조건)
        if viewModel.constellations.count > 1 {
            homeDetailView.afterImageButton.isHidden = false
            homeDetailView.afterImageButton.setImage(self.viewModel.constellations[1].image, for: .normal)
        }
        
        // MARK: detailView의 button을 addTarget으로 연결해줌
        homeDetailView.courseRegistrationButton.addTarget(self, action: #selector(courseRegistrationButtonTapped), for: .touchUpInside)
        homeDetailView.myPlanetImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        homeDetailView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        homeDetailView.beforeImageButton.addTarget(self, action: #selector(beforeImageButtonTapped), for: .touchUpInside)
        homeDetailView.afterImageButton.addTarget(self, action: #selector(afterImageButtonTapped), for: .touchUpInside)
        homeDetailView.courseNameButton.addTarget(self, action: #selector(courseNameButtonTapped), for: .touchUpInside)
    }
}

extension HomeViewController: CarouselViewDelegate {
    /// carousel에서 Page가 변할때마다 호출되는 델리게이트 함수
    /// - Parameter page: 페이지(몇번째 별자리인지)
    func currentPageDidChange(to page: Int) {
        // MARK: page가 변할때마다 변하는 요소들 1)코스이름 2)코스날짜 3)현재별자리(가운데아래 작은 네모)
            self.homeDetailView.courseNameButton.setTitle(self.viewModel.constellations[page].name, for: .normal)
            self.homeDetailView.dateLabel.text = self.viewModel.constellations[page].data
            self.homeDetailView.currentImage.image = self.viewModel.constellations[page].image
            
            // MARK: String에 따라 값이 달라져서 ViewController에서 autoLayout잡아줌
            self.homeDetailView.courseNameButton.snp.updateConstraints { make in
                guard let text = self.homeDetailView.courseNameButton.currentTitle else { return }
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(160)
                make.height.equalTo(44)
                make.width.equalTo((text as NSString).size().width + 90)
            }
        
        // MARK: 마지막페이지와 첫페이지에서는 특정 버튼이 보이지 않아야함
        self.homeDetailView.beforeImageButton.isHidden = (page == 0) ? true : false
        self.homeDetailView.afterImageButton.isHidden = (page == viewModel.constellations.count - 1) ? true : false
        
        // MARK: 이전 별자리와 다음별자리가 보여야하는데, range를 벗어나지 않게 min과 max함수로 제약조건 추가
        self.homeDetailView.beforeImageButton.setImage(self.viewModel.constellations[max(page - 1, 0)].image, for: .normal)
        self.homeDetailView.afterImageButton.setImage(self.viewModel.constellations[min(page + 1, viewModel.constellations.count - 1)].image, for: .normal)
    }
}
