import Foundation
import Utility
import DopTool

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
let parser = ArgumentParser(usage: "<options>", overview: "Support devops workflows")
let command = parser.add(positional: "command", kind: String.self)

//let job = BuildImageJob()
//job.run()

let context: DopContext

if let projectDescriptor = loadProjectDescriptor() {
    context = DopContext(projectDescriptor: projectDescriptor)
} else {
    print("Cannot load `dop.json`")
    exit(0)
}

do {
    let result = try parser.parse(arguments)

    if let c = result.get(command) {
        switch (c) {
        case "init":
            let job = InitJob(context: context)
            job.run()

        default:
            print("Unrecognized command '\(c)'")
        }
    }
} catch {
    print(error.localizedDescription)
}

