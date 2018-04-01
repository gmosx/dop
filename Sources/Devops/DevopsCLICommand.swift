public class DevopsCLICommand: CLICommand {
    let project: Project

    init(name: String, summary: String, usage: String? = nil, project: Project) {
        self.project = project
        super.init(name: name, summary: summary, usage: usage)
    }
}
