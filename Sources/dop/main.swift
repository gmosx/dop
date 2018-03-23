import Foundation
import Basic
import Utility
import Tool

// TODO: A higher-level 'CommandHandler' is needed.
// https://www.hackingwithswift.com/articles/44/apple-s-new-utility-library-will-power-up-command-line-apps

guard let project = loadProject() else {
    print("Cannot load `dop.json`")
    exit(1)
}

do {
    let parser = ArgumentParser(usage: "subcommand <options>", overview: "Support devops workflows")

//    let initParser = parser.add(subparser: "init", overview: "Initialize the package for managegement by dop")
//    let numbers = initParser.add(positional: "numbers", kind: [Int].self, usage: "List of numbers to operate with.")
    
    parser.add(subparser: "init", overview: "Initialize the package for managegement by dop")
    parser.add(subparser: "init-helm", overview: "Initialize helm support files")
    parser.add(subparser: "login", overview: "Connect to IBM Cloud")
    parser.add(subparser: "build-executable", overview: "Build the release executable") // TODO: rename to build-executable
    parser.add(subparser: "run-executable", overview: "Run the release executable locally")
    parser.add(subparser: "build-image", overview: "Build the release image")
    parser.add(subparser: "push-image", overview: "Push the release image to the registry")
    parser.add(subparser: "bump-version", overview: "Bump the version")
    parser.add(subparser: "clean", overview: "Remove all files generated by dop")

    let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))

    guard let subcommand = result.subparser(parser) else {
        parser.printUsage(on: stdoutStream)
        exit(0)
    }

    switch (subcommand) {
    case "init":
        // result.get(numbers)!
        InitJob(project: project).run()

    case "init-helm":
        InitHelmJob(project: project).run()

    case "clean":
        CleanJob().run()

    case "build-executable":
        BuildExecutableJob(project: project).run()

    case "run-release":
        RunReleaseJob(project: project).run()

    case "login":
        LoginJob(project: project).run()

    case "push-image":
        PushImageJob(project: project).run()

    case "bump-version":
        BumpVersionJob(project: project).run()

    default:
        print("Unrecognized command '\(subcommand)'")
    }
} catch let error as ArgumentParserError {
    print(error.description)
} catch {
    print(error.localizedDescription)
}
