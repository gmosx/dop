import CLIHandler
import Shell

class DevopsCommand: CLICommand {
    var shell: Shell! = nil
    var project: Project! = nil

    override open func willRun() {
        do {
            shell = Shell()
            project = try Project()
        } catch {
            print(error.localizedDescription)
        }
    }
}
