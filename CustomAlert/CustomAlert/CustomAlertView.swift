	//
	//  CustomAlertView.swift
	//  CustomAlert
	//
	//  Created by Doe on 3/20/18.
	//  Copyright © 2018 Doe. All rights reserved.
	//
import UIKit
import CoreMotion
import AVFoundation

public class CustomAlertView: UIView , AVAudioPlayerDelegate {
	@IBOutlet var content: UIView!
	@IBOutlet weak var alertLabel: UILabel!
	@IBOutlet weak var aButton: RoundedButton!
	@IBOutlet weak var bButton: RoundedButton!
	@IBOutlet weak var cButton: RoundedButton!
	@IBOutlet weak var dButton: RoundedButton!
	@IBOutlet weak var backgroundView: BackgroundView!
	@IBOutlet weak var correctAnswersLabel: UILabel!
	
	let requiredCorrectAnswers = 5
	public var delegate : AVAudioPlayer?
	
	var correctAnswers = 0
	var randomGenerator = RandomQuestionAnswerGenerator()
	
	public override init(frame: CGRect) {
		super.init(frame:frame)
		let nib = UINib(nibName: "CustomAlertView", bundle: Bundle(for: type(of: self)))
		nib.instantiate(withOwner: self, options: nil)
		content.frame = frame
		self.autoresizingMask = [.flexibleHeight,.flexibleWidth]
		setTextLabels(randomize())
		self.addSubview(content)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func  setTextLabels(_ customTextString : [String]) {
		alertLabel.text = randomGenerator.question
		aButton.setTitle(customTextString[0], for: .normal)
		bButton.setTitle(customTextString[1], for: .normal)
		cButton.setTitle(customTextString[2], for: .normal)
		dButton.setTitle(customTextString[3], for: .normal)
		
	}
	
	func randomize() -> [String]{
		var generatedLabelTexts = [String]()
		generatedLabelTexts.append(contentsOf: self.randomGenerator.generate().map({String($0)}))
		return generatedLabelTexts
	}
	
	@IBAction func answerClicked(_ sender: UIButton) {
		UIView.animate(withDuration: 1, animations: {
			let animation = CABasicAnimation(keyPath: "shadowOpacity")
			animation.toValue = 0
			animation.byValue = 0.5
			animation.duration = 0.1
			animation.autoreverses = true
			sender.layer.add(animation, forKey: "shadowOpacity")
		})
		
		var answer = String(randomGenerator.result)
		if sender.titleLabel?.text == answer {
			correctAnswers += 1
			correctAnswersLabel.text = "Correct : \(String(correctAnswers)) of \(requiredCorrectAnswers)"
		}
		
		if (correctAnswers >= requiredCorrectAnswers) {
			self.removeFromSuperview()
			delegate?.stop()
		}
		
		if (correctAnswers < requiredCorrectAnswers) {
			setTextLabels(randomize())
			answer = String(randomGenerator.result)
		}
	}
}
