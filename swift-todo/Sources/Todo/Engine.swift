//
//  Engine.swift
//  Todo
//
//  Created by Paul on 2018/4/4.
//

import Foundation

struct Engine {
    static func run(on model: Model, applying messages: [Message]) -> Model {
        return runWithHistory(on: model, applying: messages).last!
    }

    static func runWithHistory(on model: Model, applying messages: [Message]) -> [Model] {
        return messages.map { message in
          let model = message.apply(to: model)
          return model
        }
    }
}
