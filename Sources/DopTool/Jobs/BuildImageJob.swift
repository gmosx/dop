import Foundation
import Common

let shellScript = (
    // """
    // #!/bin/sh
    //
    // docker rm -f build-swift
    // docker run -it -d --name build-swift -v /Users/gmoschovitis/Code:/Users/gmoschovitis/Code reizu/ubuntu-build-swift /bin/bash
    // docker exec -i build-swift bash <<EOF
    // cd /Users/gmoschovitis/Code/Fund/FundNotifications
    // swift package clean
    // swift package update
    // swift build --configuration=release
    // EOF
    // """
    """
    echo "Hello"
    echo "World"
    """
)

/// Builds the production Linux image.
public final class BuildImageJob: Job {
    public init() {
    }

    public func run() {
        let shell = Shell()
        shell.execute(script: shellScript)
    }
}
