import Foundation
import Utility
import DopTool

let parser = ArgumentParser(usage: "subcommand <options>", overview: "Support devops workflows")
parser.add(subparser: "init", overview: "Initialize the package for managegement by dop")

let context: DopContext

if let projectDescriptor = loadProjectDescriptor() {
    context = DopContext(projectDescriptor: projectDescriptor)
} else {
    print("Cannot load `dop.json`")
    fatalError()
}

do {
    let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
    let result = try parser.parse(arguments)

    guard let subcommand = result.subparser(parser) else {
//        parser.printUsage(on: stdoutStream)
        fatalError()
    }

    switch (subcommand) {
    case "init":
        let job = InitJob(context: context)
        job.run()

    default:
        print("Unrecognized command '\(subcommand)'")
    }
} catch {
    print(error.localizedDescription)
}

