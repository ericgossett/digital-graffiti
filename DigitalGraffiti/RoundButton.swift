//
//  RoundButton.swift
//  NoahsProject
//
//  Created by YUNHAN WANG on 11/12/17.
//  Copyright © 2017 Duke University. All rights reserved.
//
/* This class is used to create a round button easily in the storyboard
   tutorial from https://www.youtube.com/watch?v=JQ5i2YKwvJ8 by Mark Moeykens
*/
import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
