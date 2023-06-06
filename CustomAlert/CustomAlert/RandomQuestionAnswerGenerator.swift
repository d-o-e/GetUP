  //
  //  RandomQuestionAnswerGenerator.swift
  //  CustomAlert
  //
  //  Created by Doe on 3/21/18.
  //  Copyright © 2018 Doe. All rights reserved.
  //

import Foundation

public class RandomQuestionAnswerGenerator {
  var operations : Dictionary<String, Operate> = [
    "+" : Operate.sum({$0 + $1}),
    "-" : Operate.minus({$0 - $1}),
    "x" : Operate.multiply({$0 * $1}),
    "÷" : Operate.divide({$0 / $1})
  ]
  
  var question = " "
  var numbers = [Int]()
  var result  = 0
  var operationLitterals = [ "+","-" ,"x" ,"÷" ]
  
  func addNumbers() {
    while (numbers.count < 5){
      let rand = Int(arc4random_uniform(11)) - 5
      let t = rand + result
      if rand != 0  && numbers.contains(t) == false{
        numbers.append(t)
      }
    }
  }
  
  func generate() -> [Int]{
    numbers = [Int]()
    while (numbers.count < 2) {
      let temp = Int(arc4random_uniform(50))
      if  numbers.contains(temp) == false && temp != 0 && temp != 1 {
        numbers.append(temp)
        if numbers[0] == temp-1 || numbers[0] == temp+1 {
          numbers.removeLast()
        }
      }
    }
    if numbers[0] < numbers[1] {
      let temp = numbers[0]
      numbers[0] = numbers[1]
      numbers[1] = temp
    }
    
    let rd = Int(arc4random_uniform(4))
    if let x = operations[operationLitterals[rd]] {
      switch x {
        case .sum(let f):
          question = " What is \(numbers[0]) \(operationLitterals[rd]) \(numbers[1]) ? "
          result = f(numbers[0], numbers[1])
          addNumbers()
        case .minus(let f) :
          question = " What is \(numbers[0]) \(operationLitterals[rd]) \(numbers[1]) ? "
          result = f(numbers[0], numbers[1])
          addNumbers()
        case .divide(let f):
          question = " What is \(numbers[0]) \(operationLitterals[rd]) \(numbers[1]) ? "
//          "*Just quotient without remainder "
          result = f(numbers[0], numbers[1])
          addNumbers()
        case .multiply(let f):
          question = " What is \(numbers[0]) \(operationLitterals[rd]) \(numbers[1]) ? "
          result = f(numbers[0], numbers[1])
          addNumbers()
      }
    }
    let index = Int( arc4random_uniform(4)) + 2
    numbers.insert(result, at: index)
    numbers = Array(numbers.suffix(from: 2))
    return numbers
  }
}

enum Operate{
  case sum ((Int, Int) -> Int)
  case minus ((Int, Int) -> Int)
  case multiply ((Int, Int) -> Int)
  case divide ((Int, Int) -> Int)
}
