import CLIHandler
import Shell

public class DevopsCommand: CLICommand {
    let project: Project
    let shell: Shell

    init(name: String, summary: String, usage: String? = nil, project: Project) {
        self.project = project
        self.shell = Shell()
        super.init(name: name, summary: summary, usage: usage)
    }
}
