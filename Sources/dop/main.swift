import Foundation
import Basic
import Utility
import DopTool

let parser = ArgumentParser(usage: "subcommand <options>", overview: "Support devops workflows")
parser.add(subparser: "init", overview: "Initialize the package for managegement by dop")
parser.add(subparser: "clean", overview: "Remove all files generated by dop")

let context: DopContext

if let projectDescriptor = loadProjectDescriptor() {
    context = DopContext(projectDescriptor: projectDescriptor)
} else {
    print("Cannot load `dop.json`")
    fatalError()
}

do {
    let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))

    guard let subcommand = result.subparser(parser) else {
        parser.printUsage(on: stdoutStream)
        exit(0)
    }

    switch (subcommand) {
    case "init":
        let job = InitJob(context: context)
        job.run()

    default:
        print("Unrecognized command '\(subcommand)'")
    }
} catch let error as ArgumentParserError {
    print(error.description)
} catch {
    print(error.localizedDescription)
}
