//
//  RecommdViewController.swift
//  DouYuShow
//
//  Created by 田彬彬 on 2017/6/1.
//  Copyright © 2017年 田彬彬. All rights reserved.
//

import UIKit

private let kItemMargin:CGFloat = 10
private let kItemW = (kSCREENW - 3 * kItemMargin)/2
private let kNormalItemH = kItemW*4/5
private let kPretyItemH = kItemW*5/4
private let kNormalCellID =  "kNormalCellID"
private let kPretyCellID =  "kPretyCellID"
private let kHeaderViewH : CGFloat = 50
private let kHeaderViewID = "kHeaderViewID"


class RecommdViewController: UIViewController {

    // mark:懒加载
    fileprivate lazy var collectionView:UICollectionView = {[weak self] in
    
        //1.先创建布局
       let layout = UICollectionViewFlowLayout()
       layout.itemSize = CGSize(width:kItemW , height: kNormalItemH)
       layout.minimumLineSpacing = 0
       layout.minimumInteritemSpacing = kItemMargin
       layout.headerReferenceSize = CGSize(width:kSCREENW, height: kHeaderViewH)
       layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
    
       let collectionView = UICollectionView(frame: (self?.view.bounds)!, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionViewPretyCell", bundle: nil), forCellWithReuseIdentifier: kPretyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        collectionView.backgroundColor = UIColor.white
        // 这行的意思让 collectionView 的宽高随着父视图的改变而改变
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        return collectionView
    
    }()
    
    fileprivate lazy var RecommedModel:RecommendViewModel = RecommendViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置ui
        setUpUI()
        
        // 请求数据
        LoadData()


    }
}


// mark：设置UI
extension RecommdViewController{

    fileprivate func setUpUI(){
    
        view.addSubview(collectionView)
    }
}

// mark: 遵循collectionView datasourece
extension RecommdViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return RecommedModel.anChorArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       let group = RecommedModel.anChorArr[section]
        return group.anchModelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let group = RecommedModel.anChorArr[indexPath.section]
        let anchor = group.anchModelArr[indexPath.row]
        
        if indexPath.section == 1{
            
           let  cell = (collectionView.dequeueReusableCell(withReuseIdentifier: kPretyCellID, for: indexPath)) as!CollectionViewPretyCell
            cell.achor = anchor
            return cell
        
        }else{
        
           let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as!CollectionViewNormalCell
             cell.achor = anchor
            
             return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // 1. 取出headview
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderReusableView
        
        // 2. 取出模型
        headerView.group = RecommedModel.anChorArr[indexPath.section]
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
        
            return CGSize(width: kItemW, height: kPretyItemH)
            
        }else{
        
            return CGSize(width: kItemW, height: kNormalItemH)
        }
    }
}

// mark: 请求数据、
extension RecommdViewController{

    fileprivate func LoadData(){
        
        RecommedModel.requestData { 
            self.collectionView.reloadData()
        }
    }
}





