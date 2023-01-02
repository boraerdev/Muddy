//
//  Helpers.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import UIKit

func getYearFromDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateString)!
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: date)
}

import UIKit

func shakeImageView(imageView: UIImageView) {
    let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
    shake.duration = 0.1
    shake.repeatCount = 2
    shake.autoreverses = true

    let fromValue = -8
    let toValue = 8

    shake.values = [fromValue, toValue]

    CATransaction.begin()
    imageView.layer.add(shake, forKey: "shake")
    CATransaction.setCompletionBlock {
        imageView.transform = CGAffineTransform.identity
    }
    CATransaction.commit()
}

func extractQuotedStrings(from paragraph: String) -> [String] {
    let pattern = "\"(.*?)\""
    let regex = try! NSRegularExpression(pattern: pattern)
    let matches = regex.matches(in: paragraph, range: NSRange(paragraph.startIndex..., in: paragraph))
    return matches.map {
        let range = Range($0.range, in: paragraph)!
        return String(paragraph[range]).replacingOccurrences(of: "\"", with: "")
    }
}

func drawCircle(size: CGFloat, color: UIColor) -> UIView {
  let circleView = UIView()
  let circlePath = UIBezierPath(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: size / 2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)

  let shapeLayer = CAShapeLayer()
  shapeLayer.path = circlePath.cgPath
  shapeLayer.fillColor = color.cgColor
    shapeLayer.strokeColor = UIColor.red.cgColor
  shapeLayer.lineWidth = 0

  circleView.layer.addSublayer(shapeLayer)
    circleView.frame = .zero
    circleView.withSize(.init(width: size, height: size))
  return circleView
}


func createRatingView(score: Double) -> UIView {
    let starSize: CGFloat = 20
  let ratingView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: starSize))

    let score = score / Double(2)
    
  // Calculate the number of full stars and partial stars
  let fullStars = Int(score)
  let partialStars = score - Double(fullStars)

  // Create the full and partial stars
  let fullStarImage = UIImage(systemName: "star.fill")
  let partialStarImage = UIImage(systemName: "star.lefthalf.fill")
  let emptyStarImage = UIImage(systemName: "star")

  // Add the full, partial, and empty stars to the rating view
  for i in 0..<fullStars {
    let imageView = UIImageView(image: fullStarImage)
      imageView.tintColor = .orange
    imageView.frame = CGRect(x: CGFloat(i) * starSize, y: 0, width: starSize, height: starSize)
    ratingView.addSubview(imageView)
  }

  if partialStars > 0 {
    let imageView = UIImageView(image: partialStarImage)
      imageView.tintColor = .orange
    imageView.frame = CGRect(x: CGFloat(fullStars) * starSize, y: 0, width: starSize, height: starSize)
    ratingView.addSubview(imageView)
  }

  for i in (fullStars + 1)..<5 {
    let imageView = UIImageView(image: emptyStarImage)
      imageView.tintColor = .orange
    imageView.frame = CGRect(x: CGFloat(i) * starSize, y: 0, width: starSize, height: starSize)
    ratingView.addSubview(imageView)
  }

  return ratingView
}
