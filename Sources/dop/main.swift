import Foundation
import Basic
import Utility
import CLIHandler
import Devops

func main() {
    do {
        try CLIHandler().handle(CommandLine.arguments, with: DopCommand())
    } catch {
        print(error.localizedDescription)
    }
}

main()
