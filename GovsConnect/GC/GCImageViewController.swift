//
//  GCImageViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/28.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

typealias GCImageViewBooleanBlock = () -> ()

class GCImageViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    var imagesName = Array<String>()
    var loadFullImageButton = UIButton(frame: CGRect(x: screenWidth / 2 - 70, y: screenHeight - 60, width: 140, height: 20))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        let sgr = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissExtraInformation(_:)))
        sgr.direction = .down
        let tgr = UITapGestureRecognizer(target: self, action: #selector(self.dismissExtraInformation(_:)))
        self.collectionView.addGestureRecognizer(sgr)
        self.collectionView.addGestureRecognizer(tgr)
        self.loadFullImageButton.layer.cornerRadius = 5
        self.loadFullImageButton.layer.borderColor = UIColor.white.cgColor
        self.loadFullImageButton.layer.borderWidth = 1
        self.loadFullImageButton.clipsToBounds = true
        self.loadFullImageButton.setTitleColor(UIColor.white, for: .normal)
        self.loadFullImageButton.setTitle("Load full image", for: .normal)
        self.loadFullImageButton.setTitle("Loading", for: .selected)
        self.loadFullImageButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        self.loadFullImageButton.backgroundColor = UIColor.black
        self.loadFullImageButton.addTarget(self, action: #selector(self.loadFullImageButtonDidClick(_:)), for: .touchDown)
        switch PHONE_TYPE {
        case .iphonexsmax:
            self.loadFullImageButton.y = screenHeight - 85
        default:
            break
        }
        self.view.addSubview(loadFullImageButton)
    }
    
    @objc func dismissExtraInformation(_ sender: UISwipeGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadFullImageButtonDidClick(_ sender: UIButton){
        let curPage = self.pageControl.currentPage
        let imgID = self.imagesName[curPage]
        AppIOManager.shared.loadFullImage(with: imgID, { (data) in
            //completion handler
            AppDataManager.shared.imageData[imgID] = data
            let indexPath = IndexPath(item: curPage, section: 0)
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            self.loadFullImageButton.alpha = 0
        }){
            //error handler
            self.loadFullImageButton.isSelected = false
            self.loadFullImageButton.alpha = 0.7
        }
    }
    
    func setupPaging(_ imagesData: Array<String>, at index: Int){
        self.imagesName = imagesData
        self.pageControl.numberOfPages = self.imagesName.count
        self.pageControl.currentPage = index
        self.collectionView.backgroundColor = UIColor.black
        self.collectionView.register(GCImageViewCell.self, forCellWithReuseIdentifier: "GC_IMAGE_COLLECTIONVIEW_CELL")
        self.collectionView.isPagingEnabled = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                let cell = self.collectionView.cellForItem(at: IndexPath(item: self.pageControl.currentPage, section: 0)) as! GCImageViewCell
                if cell.imageView.image!.size.width == 300{
                    //can load full image
                    self.loadFullImageButton.alpha = 0.7
                    self.loadFullImageButton.isSelected = false
                    cell.scrollViewDidZoom(cell.scrollView)
                }else{
                    //full image is already loaded
                    self.loadFullImageButton.alpha = 0
                }
            }
        }
    }
}

extension GCImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "GC_IMAGE_COLLECTIONVIEW_CELL", for: indexPath) as! GCImageViewCell
        item.scrollView = UIScrollView(frame: item.bounds)
        item.scrollView.minimumZoomScale = 0.2
        item.scrollView.maximumZoomScale = 6.0
        item.scrollView.backgroundColor = UIColor.black
        item.scrollView.showsVerticalScrollIndicator = false
        item.scrollView.showsHorizontalScrollIndicator = false
        item.scrollView.contentMode = .scaleAspectFit
        item.scrollView.delegate = item
        let imgData = AppDataManager.shared.imageData[self.imagesName[indexPath.item]]
        if imgData == nil{
            item.imageView = UIImageView()
        }else{
            //not nil
            item.imageView = UIImageView(image: UIImage(data: imgData!)!)
        }
        item.imageView.clipsToBounds = false
        item.imageView.contentMode = .scaleAspectFit
        item.scrollView.addSubview(item.imageView)
        item.addSubview(item.scrollView)
        item.updateZoom()
        item.addDoubleTapGestureRecongnizer()
        item.addLongPressGestureRecongnizer()
        item.shouldPresentActionSheetBlock = {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Save Image", style: .default, handler: { (alert) in
                let item = self.collectionView.cellForItem(at: IndexPath(item: self.pageControl.currentPage, section: 0)) as! GCImageViewCell
                UIImageWriteToSavedPhotosAlbum(item.imageView.image!, nil, nil, nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //self.pageControl.currentPage = indexPath.item
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        NSLog("\(collectionView.contentOffset.x / collectionView.frame.width), valocity: \(velocity)")
        if velocity.x < 0 && self.pageControl.currentPage != 0{
            self.pageControl.currentPage -= 1
        }else if velocity.x > 0 && self.pageControl.currentPage != self.pageControl.numberOfPages - 1{
            self.pageControl.currentPage += 1
        }
        let cell = self.collectionView.cellForItem(at: IndexPath(item: self.pageControl.currentPage, section: 0)) as? GCImageViewCell
        if cell != nil{
            cell!.scrollViewDidZoom(cell!.scrollView)
            if cell!.imageView.image!.size.width == 300{
                //can load full image
                self.loadFullImageButton.alpha = 0.7
                self.loadFullImageButton.isSelected = false
            }else{
                //full image is already loaded
                self.loadFullImageButton.alpha = 0
            }
        }
    }
}

class GCImageViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    var scrollView = UIScrollView()
    var shouldPresentActionSheetBlock: GCImageViewBooleanBlock? = nil
    override var reuseIdentifier: String?{
        return "GC_IMAGE_COLLECTIONVIEW_CELL"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addDoubleTapGestureRecongnizer(){
        self.imageView.isUserInteractionEnabled = true
        let dtgr = UITapGestureRecognizer(target: self, action: #selector(self.zoomToMin(_:)))
        dtgr.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(dtgr)
    }
    
    func addLongPressGestureRecongnizer(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.performSaveAction(_:)))
        self.imageView.addGestureRecognizer(lpgr)
    }
    
    @objc func zoomToMin(_ sender: UIGestureRecognizer){
        self.updateZoom()
    }
    
    @objc func performSaveAction(_ sender: UIGestureRecognizer){
        self.shouldPresentActionSheetBlock!()
    }
}

extension GCImageViewCell: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imgViewSize:CGSize! = self.imageView.frame.size;
        let imageSize:CGSize! = self.imageView.image?.size;
        var realImgSize : CGSize;
        if(imageSize.width / imageSize.height > imgViewSize.width / imgViewSize.height) {
            realImgSize = CGSize(width: imgViewSize.width,height: imgViewSize.width / imageSize.width * imageSize.height);
        }
        else {
            realImgSize = CGSize(width: imgViewSize.height / imageSize.height * imageSize.width, height: imgViewSize.height);
        }
        var fr:CGRect = CGRect.zero
        fr.size = realImgSize;
        self.imageView.frame = fr;
        
        let scrSize:CGSize = scrollView.frame.size;
        let offx:CGFloat = (scrSize.width > realImgSize.width ? (scrSize.width - realImgSize.width) / 2 : 0);
        let offy:CGFloat = (scrSize.height > realImgSize.height ? (scrSize.height - realImgSize.height) / 2 : 0);
        scrollView.contentInset = UIEdgeInsetsMake(offy, offx, offy, offx);
        
        // The scroll view has zoomed, so you need to re-center the contents
        let scrollViewSize:CGSize = self.scrollViewVisibleSize();
        
        // First assume that image center coincides with the contents box center.
        // This is correct when the image is bigger than scrollView due to zoom
        var imageCenter:CGPoint = CGPoint(x: self.scrollView.contentSize.width/2.0, y:
            self.scrollView.contentSize.height/2.0);
        
        let scrollViewCenter:CGPoint = self.scrollViewCenter()
        
        //if image is smaller than the scrollView visible size - fix the image center accordingly
        if (self.scrollView.contentSize.width < scrollViewSize.width) {
            imageCenter.x = scrollViewCenter.x;
        }
        
        if (self.scrollView.contentSize.height < scrollViewSize.height) {
            imageCenter.y = scrollViewCenter.y;
        }
        
        self.imageView.center = imageCenter;
    }
    
    //return the scroll view center
    func scrollViewCenter() -> CGPoint {
        let scrollViewSize:CGSize = self.scrollViewVisibleSize()
        return CGPoint(x: scrollViewSize.width/2.0, y: scrollViewSize.height/2.0);
    }
    // Return scrollview size without the area overlapping with tab and nav bar.
    func scrollViewVisibleSize() -> CGSize{
        
        let contentInset:UIEdgeInsets = self.scrollView.contentInset;
        let scrollViewSize:CGSize = self.scrollView.bounds.standardized.size;
        let width:CGFloat = scrollViewSize.width - contentInset.left - contentInset.right;
        let height:CGFloat = scrollViewSize.height - contentInset.top - contentInset.bottom;
        return CGSize(width:width, height:height);
    }
    
    func updateZoom(){
        var minZoom = min(self.bounds.size.width / self.imageView.image!.size.width, self.bounds.size.width / self.imageView.image!.size.width)
        minZoom = min(minZoom, 1)
        self.scrollView.minimumZoomScale = minZoom
        self.scrollView.zoomScale = minZoom
    }
}
