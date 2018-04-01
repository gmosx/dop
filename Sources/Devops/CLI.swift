import Utility

// TODO: consider CLIHandler?
// TODO: subsume CLI into CLICommand?

//public protocol CLIRouter {
//    var name: String { get }
//    var description: String { get }
//    var usage: String { get }
//
//    func route(result: ArgumentParser.Result)
//}

public class CLI {
    internal let command: CLICommand

    public init(command: CLICommand) {
        let argumentParser = ArgumentParser(usage: command.usage ?? "subcommand <options>", overview: command.summary)
        command.setup(argumentParser: argumentParser)
        command.setup()
        self.command = command
    }

    public var argumentParser: ArgumentParser {
        return command.argumentParser
    }

    public func route(arguments: [String]? = nil) throws {
        let result = try argumentParser.parse(arguments ?? Array(CommandLine.arguments.dropFirst()))
        command.route(result: result)
    }
}

open class CLICommand {
    public let name: String
    public let summary: String
    public let usage: String?
    public private(set) var argumentParser: ArgumentParser!
    public private(set) var subcommands: [String: CLICommand]

    public init(name: String, summary: String, usage: String? = nil) {
        self.name = name
        self.summary = summary
        self.usage = usage
        self.subcommands = [:]
    }

    public func setup(argumentParser: ArgumentParser) {
        self.argumentParser = argumentParser
    }

    open func setup() {
        // Override this method to setup options, flags, subcommands, etc.
        return
    }

    public func add(subcommand: CLICommand) {
        let subparser = argumentParser.add(subparser: subcommand.name, overview: subcommand.summary)
        subcommand.setup(argumentParser: subparser)
        subcommand.setup()
        subcommands[subcommand.name] = subcommand
    }

    public func route(result: ArgumentParser.Result) {
        if let subcommandName = result.subparser(argumentParser) {
            if let subcommand = subcommands[subcommandName] {
                subcommand.route(result: result)
            } else {
                print("Unrecognized command '\(subcommandName)'")
            }
        } else {
            run(result: result)
        }
    }

    open func run(result: ArgumentParser.Result) {
    }
}
