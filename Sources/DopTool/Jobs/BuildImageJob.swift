import Foundation
import Common

/// Builds the production Linux image.
public final class BuildImageJob: Job {
    let projectDescriptor: ProjectDescriptor
    
    public init(projectDescriptor: ProjectDescriptor) {
        self.projectDescriptor = projectDescriptor
    }

    public func run() {
        let pd = projectDescriptor
        let shell = Shell()
        
        // TODO: Actually, it's building the release version (using a linux-tools container)
        // TODO: Keep the Dockerfile-tools image in the directory, like idt
        // TODO: try to avoid the hard-coded home paths.
        shell.execute(script: (
            """
            docker rm -f build-swift
            docker run -it -d --name build-swift -v /Users/gmoschovitis/Code:/Users/gmoschovitis/Code reizu/ubuntu-build-swift /bin/bash
            docker exec -i build-swift bash <<EOF
            cd /Users/gmoschovitis/Code/Fund/FundNotifications
            swift package clean
            swift package update
            swift build --configuration=release
            EOF
            """
        ))
    }
}
