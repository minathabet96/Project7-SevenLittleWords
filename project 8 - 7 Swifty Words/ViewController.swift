//
//  ViewController.swift
//  project 8 - 7 Swifty Words
//
//  Created by Mina Thabet on 29/08/2023.
//

import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var hiddenButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "score: \(score)"
        }
    }
    var level = 1
   
    override func loadView() {
        view = UIView()
        
        view.backgroundColor = .white
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "score = 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
                                 
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to enter"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant:  -100),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            clear.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            submit.heightAnchor.constraint(equalToConstant: 44),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        let width = 150
        let height = 80
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                
                let frame = CGRect(x: column*width, y: row*height, width: width, height: height)
                letterButton.frame = frame
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                for letterbutton in letterButtons {
                    letterbutton.layer.borderWidth = 1
                    letterbutton.layer.borderColor = UIColor.lightGray.cgColor
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        sender.isHidden = true
        activatedButtons.append(sender)
    }
    @objc func clearTapped(_ sender: UIButton){
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    @objc func submitTapped(_ sender: UIButton){
        guard let answerText = currentAnswer.text else { return }
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            for button in activatedButtons {
                hiddenButtons.append(button)
            }
            activatedButtons.removeAll()
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""
            score += 1
            
                if hiddenButtons.count == 20 {
                    let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "let's go", style: .default, handler: levelUp))
                    present(ac, animated: true)
                }
        }
        else {
            let vc = UIAlertController(title: "That's not quite right", message: "try again", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "OK", style: .default))
            present(vc, animated: true)
            score -= 1
            currentAnswer.text = ""
            for button in activatedButtons
            {button.isHidden = false}
        }
    }
    func levelUp(action: UIAlertAction){
        level+=1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
        
    }
    
  func loadLevel(){
      var clueString = ""
      var solutionString = ""
      var letterBits = [String]()
      DispatchQueue.global(qos: .userInteractive).async { [weak self] in
          if let levelFileURL = Bundle.main.url(forResource: "level\(self?.level ?? 0)", withExtension: "txt") {
              if let levelContents = try? String(contentsOf: levelFileURL){
                  var lines = levelContents.components(separatedBy: "\n")
                  lines.shuffle()
                  
                  for (index, line) in lines.enumerated() {
                      let parts = line.components(separatedBy: ": ")
                      let answer = parts[0]
                      let clue = parts[1]
                      clueString += "\(index+1). \(clue)\n"
                      let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                      self?.solutions.append(solutionWord)
                      solutionString += "\(solutionWord.count) letters\n"
                      let bits = answer.components(separatedBy: "|")
                      letterBits += bits
                      self?.letterButtons.shuffle()
                  }
              }
          }
      
                     DispatchQueue.main.async { [weak self] in
                         if self?.letterButtons.count == letterBits.count {
                             for i in 0..<(self?.letterButtons.count ?? 20) {
                                 self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
                         self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                         self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
       }
      }
    }
}

