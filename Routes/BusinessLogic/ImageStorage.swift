//
//  ImageStorage.swift
//  Routes
//
//  Created by Ekaterina on 20.06.21.
//

import UIKit

class ImageStorage {
    
    private var selfieImamgeName = "routeSelfie.png"
    
    public func save(image: UIImage) -> Bool {
        guard let data = image.pngData(),
              let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }

        do {
            try data.write(to: directory.appendingPathComponent(selfieImamgeName)!, options: .atomic)
            return true
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
    }
    
    
    public func getImage() -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(selfieImamgeName).path)
        }
        return UIImage()
    }
    
}
