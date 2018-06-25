import Utility

class ContainerLogsCommand: DevopsCommand {
    convenience init() {
        self.init(name: "container-logs", summary: "Presents a snapshot of the container logs")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            try shell.execute("kubectl logs -lapp=\(project.containerAppLabel)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
