import Foundation
import Utility
import DopTool

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let parser = ArgumentParser(usage: "<options>", overview: "Support devops workflows")
let parsedArguments = try parser.parse(arguments)

//let job = BuildImageJob()
//job.run()

let job = InitJob()
job.run()
