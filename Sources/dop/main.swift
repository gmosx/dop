import Foundation
import Utility

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let parser = ArgumentParser(usage: "<options>", overview: "Support devops workflows")
let parsedArguments = try parser.parse(arguments)
