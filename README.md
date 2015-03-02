Blog example using Scala, Play, AngularJS, CoffeeScript and Reactive Mongo Driver

Getting Started
----------

Your development environment will require:
*  SBT / Play see [here]() for installation instructions.
*  MongoDB see [here]() for installation instructions.

Once the prerequisites have been installed, you will be able to execute the following from a terminal.

```
../modern-web-template >  play run
```

This should fetch all the dependencies and start a Web Server listening on *localhost:9000*

```
[info] Loading project definition from ../modern-web-template/project
[info] Set current project to modern-web-template
[info] Updating modern-web-template...
...
[info] Done updating.

--- (Running the application from SBT, auto-reloading is enabled) ---

[info] play - Listening for HTTP on /0:0:0:0:0:0:0:0:9000

(Server started, use Ctrl+D to stop and go back to the console...)

```

Note: This will create a MongoDB Collection for you automatically, a free-be from the Driver! 