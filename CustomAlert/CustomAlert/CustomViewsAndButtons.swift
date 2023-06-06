	//
	//  BackgroundView.swift
	//  CustomAlert
	//
	//  Created by Doe on 3/23/18.
	//  Copyright © 2018 Doe. All rights reserved.
	//

import UIKit

@IBDesignable public class BackgroundView: UIView {
  @IBInspectable public var shadowingColor: UIColor? {
    didSet {layer.shadowColor = shadowingColor?.cgColor }
  }
  
  @IBInspectable public var shadowRadius: CGFloat = 0 {
    didSet {layer.shadowRadius = shadowRadius}
  }
  
  @IBInspectable public var shadowTransperancy : Float = 0 {
    didSet {layer.shadowOpacity = shadowTransperancy }
  }
  
  @IBInspectable public var cornerRadius : CGFloat = 0 {
    didSet { layer.cornerRadius = cornerRadius}
  }
  
  @IBInspectable public var shadowOff: CGFloat = 0 {
    didSet{ layer.shadowOffset = CGSize(width: shadowOff, height: shadowOff)}
  }

  
}
