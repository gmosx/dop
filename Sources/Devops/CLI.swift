import Utility

// TODO: consider CLIHandler?
// TODO: subsube CLI into CLICommand?

public class CLI {
    internal let command: CLICommand

    public init(command: CLICommand) {
        let argumentParser = ArgumentParser(usage: command.usage ?? "subcommand <options>", overview: command.summary)
        command.setup(argumentParser: argumentParser)
        self.command = command
    }

    public var argumentParser: ArgumentParser {
        return command.argumentParser
    }

    public func parse() throws {
        let result = try argumentParser.parse(Array(CommandLine.arguments.dropFirst()))

        if let subcommandName = result.subparser(argumentParser) {
            if let subcommand = command.subcommands[subcommandName] {
                subcommand.run(result: result)
            } else {
                print("Unrecognized command '\(subcommandName)'")
            }
        } else {
            command.run(result: result)
        }
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

    open func setup(argumentParser: ArgumentParser) {
        self.argumentParser = argumentParser
    }

    public func add(subcommand: CLICommand) {
        let subparser = argumentParser.add(subparser: subcommand.name, overview: subcommand.summary)
        subcommand.setup(argumentParser: subparser)
        subcommands[subcommand.name] = subcommand
    }

    open func run(result: ArgumentParser.Result) {
    }
}
