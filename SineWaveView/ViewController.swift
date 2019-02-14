//
//  ViewController.swift
//  SineWaveView
//
//  Created by Hari Keerthipati on 27/06/18.
//  Copyright © 2018 Avantari Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sineWaveView: SineWaveView!
    var displayLink: CADisplayLink!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func wavesSetup(isForMindfuness: Bool){
        sineWaveView.setup()
        displayLink                         = CADisplayLink(target: self, selector: #selector(self.updateSineWavesAmplitude))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        sineWaveView.primaryWaveLineWidth   = 3.0
        sineWaveView.secondaryWaveLineWidth = 1.0
        sineWaveView.alpha                  = 1.0
    }
    var count = 0
    @objc func updateSineWavesAmplitude() {
        count += 1
        print("count", count)
        sineWaveView.updateWithLevel(level: CGFloat(0.3))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wavesSetup(isForMindfuness: false)
        //self.sineWaveView.updateWithLevel(level: 0.05)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

