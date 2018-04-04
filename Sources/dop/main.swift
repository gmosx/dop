import Foundation
import Basic
import Utility
import CLIHandler
import Devops

func main() {
    do {
        let project = try Project(from: URL(fileURLWithPath: "dop.json"))
        try CLIHandler().handle(CommandLine.arguments, with: DopCommand(project: project))
    } catch {
        print(error.localizedDescription)
    }
}

main()
