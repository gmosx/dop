import Foundation

// TODO: rename to init-project
// TODO: render Dockerfile, help charts, how-to-deploy, etc.
// TODO: check if files exist
// TODO: add --force option
// TODO: emit instructions how-to-deploy, etc.

/// Intialize the package for mangement by `dop`.
public class InitJob: DevopsJob {
    private var dockerfileContents: String {
        return (
            """
            FROM ibmcom/swift-ubuntu-runtime:4.0.3
            LABEL Description="\(project.description)"
            MAINTAINER \(project.maintainer ?? "Unknown")
            
            RUN apt-get update # && apt-get install -y libpq-dev

            WORKDIR /root

            COPY .build/release/\(project.executableName) bin/\(project.executableName)

            ENV LD_LIBRARY_PATH /usr/lib/swift/linux

            CMD bin/\(project.executableName)
            """
        )
    }

    public override func run() {
        do {
            try shell.writeTextFile(atPath: "Dockerfile", contents: dockerfileContents)
            
            InitHelmJob(project: project).run()
        } catch {
            print(error.localizedDescription)
        }
    }
}
