import Utility

// TODO: also clean helm packages?

class CleanCommand: DevopsCommand {
    convenience init() {
        self.init(name: "clean", summary: "Remove all generated files")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            if shell.confirm("Are you sure you want to delete all generated files?") {
                try shell.removeFile(atPath: "Dockerfile")
                try shell.removeDirectory(atPath: "chart")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
