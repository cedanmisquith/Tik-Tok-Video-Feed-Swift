//
//  Utilities.swift
//  TikTok Video Feed Swift
//
//  Created by Cedan Misquith on 20/10/22.
//

import UIKit

class Utilities {
    static let shared = Utilities()
    func createGradient(color1: UIColor, color2: UIColor, frame: CGRect) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        return gradientLayer.toImage()
    }
}
extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
extension CAGradientLayer {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        self.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage ?? UIImage()
    }
}
private var xoAssociationKey: UInt8 = 0
extension UIImageView {
    @nonobjc static var imageCache = NSCache<NSString, AnyObject>()
    var imageURL: String? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? String
        }
        set(newValue) {
            guard let urlString = newValue else {
                objc_setAssociatedObject(self, &xoAssociationKey,
                                         newValue,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                image = nil
                return
            }
            objc_setAssociatedObject(self,
                                     &xoAssociationKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            if let image = UIImageView.imageCache.object(
                forKey: "\((urlString as NSString).hash)" as NSString) as? UIImage {
                self.image = image
                return
            }
            DispatchQueue.global().async { [weak self] in
                guard let url = URL(string: urlString as String) else {
                    return
                }
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                let image = UIImage(data: data)
                guard let fetchedImage = image else {
                    return
                }
                DispatchQueue.main.async {
                    UIImageView.imageCache.setObject(fetchedImage, forKey: "\(urlString.hash)" as NSString)
                    guard let pastImageUrl = self?.imageURL,
                          url.absoluteString == pastImageUrl else {
                        self?.image = nil
                        return
                    }
                    let animation = CATransition()
                    animation.type = CATransitionType.fade
                    animation.duration = 0.3
                    self?.layer.add(animation, forKey: "transition")
                    self?.image = fetchedImage
                }
            }
        }
    }
    func setImageColour(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
}
