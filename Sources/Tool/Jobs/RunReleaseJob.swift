import Foundation

/// Runs the production Linux image.
public final class RunReleaseJob: BaseToolJob {
    public override func run() {
        let shell = Shell()

        shell.execute(script: (
            """
            docker rm -f \(project.name)
            docker build -t \(project.imageName) .
            docker run -t --name \(project.name) \(project.imageName)
            """
        ))
    }
}
