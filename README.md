# Dop

Automation for common 'Devops' workflows.

## Stability

This tool should be considered alpha, and not stable. Breaking changes will happen often.

## Instalation

```
swift build -c release
rm /usr/local/bin/dop
ln -s `pwd`/.build/release/dop /usr/local/bin/dop
```

## Usage

To see the available commands, run `dop` without parameters:

```
dop
```

Within your project's directory create the dop.json 'descriptor' file:

```
{
    "clusterName" : "your-cluster-name",
    "maintainer" : "your@email.com",
    "executableName" : "executable-name",
    "packagePath" : "path-of-package-in-repo",
    "version" : "xx.yy.zz",
    "description" : "Description of your project",
    "name" : "name-of-the-project"
}
```

To initialise your project, run:

```
dop init
```

## Licence

The software and all related files are licensed under the MIT license.

(c) 2018 Reizu
