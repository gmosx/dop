import Foundation

/// Runs the container image.
public final class RunImageJob: DevopsJob {
    public override func run() {
        let shell = Shell()

        do {
            try shell.execute(script:
                """
                docker rm -f \(project.name)
                docker build -t \(project.fullImageName) .
                docker run -t --name \(project.name) \(project.fullImageName)
                """
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
