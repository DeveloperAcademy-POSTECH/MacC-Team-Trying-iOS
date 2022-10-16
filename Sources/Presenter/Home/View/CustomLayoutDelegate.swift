//
//  CustomLayoutDelegate.swift
//  MatStar
//
//  Created by uiskim on 2022/10/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol CustomLayoutDelegate: AnyObject {
    
    // 동적으로 높이를 알기위해서 Delegate 생성
    // collectionView를 사용하는 Controller에서 구현하게 됨.
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CustomLayout: UICollectionViewLayout {
    // 1. 동적 높이을 알기 위한 delegate 참조.(구현은 Controller에서 구현할 거임)
    weak var delegate: CustomLayoutDelegate?
    
    // 2. 보여질 갯수, item 간의 padding
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    // 3
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // 4
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        // collectionView의 내부 padding
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // x,y위치를 지정하고, width, height로 화면에 그림.
    // autoLayout 개념과 유사하다.
    override func prepare() {
        // 1
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        
        // 2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // 반복해서 집어넣기
        // ex
        // let liar = Array(repeating: false, count: 5)
        // print(liar)  /* [false, false, false, false, false] */
        
        // 3
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            // 동적 높이 계산
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            // insetBy 만큼 터치 인식 영역이 증가하거나 감소함.
            // dx, dy가 음수이면 bounds의 크기를 증가, dx, dy가 양수이면 bounds의 크기 감소
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5 item의 x,y,width,height를 지정한 frame을 cache에 저장함.
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
           // print(contentHeight)
            yOffset[column] = yOffset[column] + height
            
            // 다음 item이 다음 열에 배치되도록 설정
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    // 모든 아이템들에 대한 레이아웃 attributes를 반환
    // rect 대상 보기를 포함하는 사각형(컬렉션 보기의 좌표계에 지정됨).-> 보여지는 부분.
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        //        (-568.0, 568.0, 856.0, 1136.0)
        //        (-568.0, 0.0, 856.0, 1136.0)
        //        (-568.0, 0.0, 856.0, 1136.0)
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) { // rect과 겹치는지 확인.
                visibleLayoutAttributes.append(attributes)
                
            }
        }
        return visibleLayoutAttributes
    }
    
    // item에 대한 layout속성을 CollectionView에게 알려줌.
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }

}
