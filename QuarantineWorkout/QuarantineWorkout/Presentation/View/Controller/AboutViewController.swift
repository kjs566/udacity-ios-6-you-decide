//
//  AboutViewController.swift
//  PitchPerfect
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import UIKit


/// About me and about app controller.
class AboutViewController: UIViewController {
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var currentSegment = 0;
    let aboutTexts = [
        0: "Hi, my name is Jan Skála.\n\nMy hobbies are squash, programming and biking. I've been working as an Android developer for nearly 5 years.\n\nAnd now I'm trying a new platform - that's why this app was created.\n\nHope you will enjoy it!",
        1: "This app demonstrates knowledge in iOS development and it's frameworks - UIKit and Core Data. It uses Swift 5, Storyboards, MVVM architecture and clean architecture. This app was created as the sixth project during Udacity's iOS Developer Nanodegree program.\n\n"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        
        updateView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        currentSegment = segmentedControl.selectedSegmentIndex;
        updateView();
    }
    
    private func updateView(){
        aboutText?.text = aboutTexts[currentSegment]
    }
    
}
