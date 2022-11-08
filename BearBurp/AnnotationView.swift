//
//  AnnotationView.swift
//  BearBurp
//
//  Created by Haoran Song on 11/3/22.
//

import UIKit
import HDAugmentedReality

protocol AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {

  var delegate: AnnotationViewDelegate?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    loadUI()
  }
  
  func loadUI() {
      let label = UILabel(frame: CGRect(x: 10, y: 0, width: 180, height: 30))
      label.font = UIFont.boldSystemFont(ofSize: 18)
      label.numberOfLines = 0
      label.backgroundColor = .clear
      label.textColor = UIColor.black
      self.addSubview(label)
      
      let rateStar = UILabel(frame: CGRect(x: 10, y: 30, width: 180, height: 20))
      self.addSubview(rateStar)
      
      let distanceLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 180, height: 30))
      distanceLabel.backgroundColor = .clear
      distanceLabel.textAlignment = .right
      distanceLabel.textColor = UIColor.black
      distanceLabel.font = UIFont.boldSystemFont(ofSize: 14)
      self.addSubview(distanceLabel)
      
      if let annotation = annotation as? Place {
          label.text = annotation.placeName
          distanceLabel.text = String(format: "%.2f km", annotation.distanceFromUser / 1000)
          rateStar.attributedText = NSMutableAttributedString().starWithRating(rating: Float(round(annotation.rateNum)), outOfTotal: 10, withFontSize: 14.0)
      }
    }
    
    override func layoutSubviews() {
        
    }
      
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      delegate?.didTouch(annotationView: self)
    }

}

// Reference: https://stackoverflow.com/questions/16100378/is-there-any-controls-available-for-star-rating
extension NSMutableAttributedString{

    func starWithRating(rating:Float, outOfTotal totalNumberOfStars:NSInteger, withFontSize size:CGFloat) ->NSAttributedString{


        let currentFont = UIFont(name: "Futura", size: size)!

        let activeStarFormat = [ NSAttributedString.Key.font:currentFont, NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 0.64, blue: 0.10, alpha: 1.00)];

        let inactiveStarFormat = [ NSAttributedString.Key.font:currentFont, NSAttributedString.Key.foregroundColor: UIColor.lightGray];

        let starString = NSMutableAttributedString()

        for i in 0...totalNumberOfStars-1{

            if(rating >= Float(i+1)){

                starString.append(NSAttributedString(string: "\u{2605}", attributes: activeStarFormat))
            }else{
                starString.append(NSAttributedString(string: "\u{2605}", attributes: inactiveStarFormat))
            }
        }

        return starString
    }
}

