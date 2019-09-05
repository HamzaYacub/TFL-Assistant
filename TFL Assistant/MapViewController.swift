//
//  MapViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 09/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }
  
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
