# Package

version       = "0.1.0"
author        = "MyAirPods2"
description   = "A new awesome nimble package"
license       = "Apache-2.0"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["a3"]


# Dependencies

requires "nim >= 2.0.2"
requires "https://github.com/ire4ever1190/mike"
requires "db_connector"
requires "nimja"
