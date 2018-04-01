import Foundation
import Basic
import Utility
import Devops

func main() {
    do {
        let project = try Project(from: URL(fileURLWithPath: "dop.json"))

        let cli = CLI(command: DopCommand(project: project))
        try cli.route()
    } catch let error as ArgumentParserError {
        print(error.description)
    } catch {
        print(error.localizedDescription)
    }
}

main()
