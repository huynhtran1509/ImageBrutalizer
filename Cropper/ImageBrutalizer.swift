//
//  ImageBrutalizer.swift
//  Cropper
//
//  Created by Erik Little on 8/27/16.
//  Copyright © 2016 Erik Little. All rights reserved.
//

import Foundation
import CoreImage
import AppKit

class ImageBrutalizer {
    let context = CIContext(options: nil)
    let extent: CGRect
    let height: Int
    let width: Int
    
    var image: CIImage
    var outputImage: CGImage {
        return context.createCGImage(image, fromRect: extent)
    }
    
    var outputData: NSData? {
        let outputCGImage = outputImage
        let outputSize = NSSize(width: width, height: height)
        let bitmapRep = NSBitmapImageRep(CGImage: outputCGImage)
        
        bitmapRep.size = outputSize
        
        return bitmapRep.representationUsingType(.NSPNGFileType, properties: [:])
    }
    
    private var randomCenter: CIVector {
        return CIVector(x: CGFloat(arc4random_uniform(UInt32(width))), y: CGFloat(arc4random_uniform(UInt32(height))))
    }
    
    init?(image: CIImage) {
        guard let height = image.properties["PixelHeight"] as? Int else { return nil }
        guard let width = image.properties["PixelWidth"] as? Int else { return nil }
        
        self.image = image
        self.extent = image.extent
        self.height = height
        self.width = width
    }
    
    func brutalizeWithBumps(numberOfBumps bumpNum: Int) {
        for _ in 0..<bumpNum {
            let bumper = CIFilter(name: "CIBumpDistortion", withInputParameters: [
                "inputImage": image,
                "inputCenter": randomCenter,
                "inputRadius": randomNSNumber(500)
                ])
            
            image = bumper?.outputImage ?? image
        }
    }
    
    func brutalizeWithHoles(numberOfHoles holeNum: Int) {
        for _ in 0..<holeNum {
            let holer = CIFilter(name: "CIHoleDistortion", withInputParameters: [
                "inputImage": image,
                "inputCenter": randomCenter,
                "inputRadius": randomNSNumber(30)
                ])
            
            image = holer?.outputImage ?? image
        }
    }
    
    func brutalizeWithLightTunnel() {
        let tunneler = CIFilter(name: "CILightTunnel", withInputParameters: [
            "inputImage": image,
            "inputCenter": randomCenter,
            "inputRotation": randomNSNumber(40),
            ])
        
        image = tunneler?.outputImage ?? image
    }
    
    func brutalizeWithToruses(numberOfToruses numOfToruses: Int) {
        for _ in 0..<numOfToruses {
            let toruser = CIFilter(name: "CITorusLensDistortion", withInputParameters: [
                "inputImage": image,
                "inputCenter": randomCenter,
                "inputRadius": randomNSNumber(200),
                "inputWidth": randomNSNumber(200),
                "inputRefraction": randomNSNumber(10)
                ])
            
            image = toruser?.outputImage ?? image
        }
    }
    
    
    func brutalizeWithTwirls(numberOfTwirls numOfTwirls: Int) {
        for _ in 0..<numOfTwirls {
            let twirler = CIFilter(name: "CITwirlDistortion", withInputParameters: [
                "inputImage": image,
                "inputCenter": randomCenter,
                "inputRadius": randomNSNumber(100),
                "inputAngle": randomNSNumber(4)
                ])
            
            image = twirler?.outputImage ?? image
        }
    }
    
    private func randomNSNumber(limit: Int) -> NSNumber {
        return NSNumber(unsignedInt: arc4random_uniform(UInt32(limit)))
    }
}
