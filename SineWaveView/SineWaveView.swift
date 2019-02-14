//
//  SineWaveView.swift
//  DhyanaGenric
//
//  Created by AVANTARI on 02/11/17.
//  Copyright © 2017 AVANTARI. All rights reserved.
//

import UIKit

let kDefaultFrequency:CGFloat      = 1.5
let kDefaultAmplitude:CGFloat      = 1.0
let kDefaultIdleAmplitude:CGFloat  = 0.01
let kDefaultNumberOfWaves:Int      = 1

let kDefaultPhaseShift:CGFloat         = -0.10
let kDefaultDensity:CGFloat            = 5.0
let kDefaultPrimaryLineWidth:CGFloat   = 3.0
let kDefaultSecondaryLineWidth:CGFloat = 1.0

class SineWaveView: UIView {

    var isRelaxationStarted = false
    var numberOfWaves:Int                     = 5
    @IBInspectable weak var  waveColor        = UIColor.white
    @IBInspectable  var  primaryWaveLineWidth = kDefaultPrimaryLineWidth
    @IBInspectable var secondaryWaveLineWidth = kDefaultSecondaryLineWidth
    @IBInspectable var idleAmplitude          = kDefaultIdleAmplitude
    @IBInspectable var frequency              = kDefaultFrequency
    @IBInspectable var amplitude              = kDefaultAmplitude
    private var amplitudeSmooth:CGFloat?
    @IBInspectable var density                = kDefaultPhaseShift
    @IBInspectable var phaseShift             = kDefaultPhaseShift
    var phase:CGFloat                         = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        self.waveColor              = UIColor.white
        self.frequency              = kDefaultFrequency
        self.amplitude              = 0.0//kDefaultAmplitude
        self.idleAmplitude          = kDefaultIdleAmplitude
        self.amplitudeSmooth        = 0.0//kDefaultAmplitude
        self.numberOfWaves          = kDefaultNumberOfWaves
        self.phaseShift             = kDefaultPhaseShift
        self.density                = kDefaultDensity
        self.primaryWaveLineWidth   = kDefaultPrimaryLineWidth
        self.secondaryWaveLineWidth = kDefaultSecondaryLineWidth
        self.phase                  = 0
    }
    
    func updateWithLevel(level:CGFloat) {
        
        self.phase     += self.phaseShift
        self.amplitude = fmax(level, self.idleAmplitude)
        if amplitude > 1.0{
            amplitude = 1.0
        }
        self.setNeedsDisplay()
    }
    var indexx = 0
    override func draw(_ rect: CGRect) {
        
        // TODO:- Find alternate way instead of adding 0.001 which is wrong.
//        self.amplitude       = self.amplitude + 0.001
//        self.amplitudeSmooth = self.amplitudeSmooth! + 0.001
        // *************
        //print("amplitude===\(self.amplitude)")
        let context = UIGraphicsGetCurrentContext()!

        self.amplitudeSmooth  = self.amplitudeSmooth! +  (self.amplitude - self.amplitudeSmooth!)/40
        context.clear(self.bounds);
        self.backgroundColor?.set()
        context.fill(rect)
        
        context.setLineWidth(self.primaryWaveLineWidth)
        context.setShadow(offset: CGSize.init(width: 1.0, height: 2.0), blur: 0.0)
        indexx += 1

            let halfHeight      = self.bounds.height / 2.0
            let fullwidth       = self.bounds.width
            let mid             = fullwidth/2.0
            let maxAmplitude    = halfHeight - 4.0;
            let progress        = 1.0
            let normedAmplitude = CGFloat(1.5 * progress - 0.5) * amplitudeSmooth!
            let multiplier      = CGFloat(1.0);
            self.waveColor?.withAlphaComponent(multiplier*(self.waveColor?.cgColor.alpha)!).set()
            
            var x:CGFloat = 0.0
            var y:CGFloat = 0.0
            while x < (fullwidth + self.density) {
                let scaling   = -pow(1 / mid * (x - mid), 2) + 1
                var amplitude = scaling * maxAmplitude * normedAmplitude
                amplitude     = fmin(amplitude, maxAmplitude)
                
                y = amplitude * CGFloat( cosf(Float (2 * Double.pi) * Float (x / fullwidth) * Float( self.frequency ) + Float(self.phase)) ) + halfHeight
                
                if (x == 0) {
                    context.move(to: CGPoint(x: x, y: y))
                } else {
                    context.addLine(to: CGPoint(x: x, y: y))
                }
                x += self.density
            }
        
        context.addLine(to: CGPoint(x: self.frame.size.width, y: halfHeight))
        context.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        context.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        context.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        context.addLine(to: CGPoint(x: 0, y: halfHeight))
        context.fillPath()
//        CGContextAddLineToPoint(context, self.frame.size.width, halfHeight)
//        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height)
//        CGContextAddLineToPoint(context, 0, self.frame.size.height)
//        CGContextAddLineToPoint(context, 0, halfHeight)
        
  //      CGContextFillPath(context);
    }
}
