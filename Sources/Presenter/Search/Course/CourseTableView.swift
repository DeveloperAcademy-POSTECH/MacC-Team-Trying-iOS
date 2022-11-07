//
//  CourseTableView.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag

class CourseTableView: UITableView {
    var searchViewModel: SearchViewModel?
    let cancelBag = CancelBag()
    
    convenience init(viewModel: SearchViewModel?) {
        self.init(frame: .zero, style: .plain)
        self.searchViewModel = viewModel
        bind()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        register(CourseTableViewCell.self, forCellReuseIdentifier: CourseTableViewCell.identifier)
        register(PlanetTableViewCell.self, forCellReuseIdentifier: PlanetTableViewCell.identifier)
        backgroundColor = .designSystem(.black)
        separatorColor = .clear
        showsVerticalScrollIndicator = true
        dataSource = self
        prefetchDataSource = self
    }
    
    private func bind() {
        guard let viewModel = searchViewModel else { return }
        viewModel.$coursesOrPlanets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .cancel(with: cancelBag)
    }
}

extension CourseTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = searchViewModel else { return 0 }
        return viewModel.coursesOrPlanets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = searchViewModel,
              let courseTableCell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCell.identifier, for: indexPath) as? CourseTableViewCell,
              let planetTableCell = tableView.dequeueReusableCell(withIdentifier: PlanetTableViewCell.identifier, for: indexPath) as? PlanetTableViewCell
        else { return UITableViewCell() }
        
        switch viewModel.currentCategory {
        case .course:
            courseTableCell.course = viewModel.getCourseIndexPathAt(indexPath)
            courseTableCell.likeTapped = { courseId, isLike in
                viewModel.toggleLike(courseId: courseId, isLike: isLike)
            }
            
            return courseTableCell
        case .planet:
            planetTableCell.planet = viewModel.getPlanetIndexPathAt(indexPath)
            planetTableCell.followTapped = { planetId, isFollow in
                viewModel.toggleFollow(planetId: planetId, isFollow: isFollow)
            }
            return planetTableCell
        }
    }
    
}

extension CourseTableView: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let viewmodel = searchViewModel else { return }
        viewmodel.prefetchIndexAt(indexPaths.last?.row)
    }
    
}
