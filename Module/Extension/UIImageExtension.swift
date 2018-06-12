//
//  UIImageExtension.swift
//  Pacific
//
//  Created by Minh Nguyen on 9/21/16.
//  Copyright © 2017 Langtutheky. All rights reserved.
//

import UIKit

extension UIImage
{
    private static var _compressionQueue : DispatchQueue = DispatchQueue(label: "compressionQueue")
    
    class func load(contentsOfFile: String, completion: @escaping (UIImage?) -> Void)
    {
        let fetchedImage = UIImageCache.fetch(contentsOfFile: contentsOfFile)
        completion(fetchedImage)
    }
    
    var cgImageTransform : CGAffineTransform
    {
        get
        {
            var transform : CGAffineTransform = CGAffineTransform.identity
            
            if (self.imageOrientation == UIImageOrientation.left)
            {
                transform = transform.rotated(by: .pi / 2)
                transform = transform.translatedBy(x: 0, y: -self.size.height)
            }
            else if (self.imageOrientation == UIImageOrientation.right)
            {
                transform = CGAffineTransform(rotationAngle: -(.pi / 2))
                transform = transform.translatedBy(x: -self.size.width, y: 0)
            }
            else if (self.imageOrientation == UIImageOrientation.down)
            {
                transform = CGAffineTransform(rotationAngle: -(.pi))
                transform = transform.translatedBy(x: -self.size.width, y: -self.size.height)
            }
            
            transform = transform.scaledBy(x: self.scale, y: self.scale)
            
            return transform
        }
    }
    
    func crop(to rect: CGRect) -> UIImage
    {
        let cropRect = rect.applying(self.cgImageTransform)
                
        let image = UIImage(cgImage: self.cgImage!.cropping(to: cropRect)!,
                            scale: self.scale,
                            orientation: self.imageOrientation)
        
        return image
    }
    
    func compress(toMb expectedSizeInMb: Int, completion: @escaping (Data?)->())
    {
        self.compress(toKb: expectedSizeInMb * 1024, completion: completion)
    }
    
    func compress(toKb expectedSizeInKb: Int, completion: @escaping (Data?)->())
    {
        UIImage._compressionQueue.async
        {
            let sizeInBytes = expectedSizeInKb * 1024
            var needCompress : Bool = true
            var imageData : Data? = nil
            var compressingValue : CGFloat = 1.0
            
            while (needCompress && compressingValue > 0.0)
            {
                if let data : Data = UIImageJPEGRepresentation(self, compressingValue)
                {
                    if data.count < sizeInBytes
                    {
                        needCompress = false
                        imageData = data
                    }
                    else
                    {
                        compressingValue -= 0.1
                    }
                }
            }
            
            DispatchQueue.main.async
            {
                completion(imageData)
            }
        }
    }
}

class UIImageCache
{
    static var imagesByPath = [String:UIImage]()
    static var paths = [String]()
    
    class func fetch(contentsOfFile: String) -> UIImage?
    {
        var image = UIImageCache.imagesByPath[contentsOfFile]
        
        if (image == nil)
        {
            image = UIImage(contentsOfFile: contentsOfFile)
            
            if (image != nil)
            {
                UIGraphicsBeginImageContextWithOptions(image!.size, false, image!.scale)
                image!.draw(in: CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height))
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                UIImageCache.queue(contentsOfFile: contentsOfFile, image: image!)
            }
        }
        
        return image
    }
    
    class func queue(contentsOfFile: String, image: UIImage)
    {
        UIImageCache.imagesByPath[contentsOfFile] = image
        UIImageCache.paths.append(contentsOfFile)
        
        if (UIImageCache.imagesByPath.count > 100)
        {
            UIImageCache.imagesByPath.removeValue(forKey: UIImageCache.paths.removeFirst())
        }
    }
}
