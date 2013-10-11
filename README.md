Scoots
================================

Scoots is a very simple and lightweight **IRC link information bot** written in Ruby that runs as a *nix daemon.

This bot is still in development. Scoots requires a host of gems to function properly- all are listed in the scoots.rb file. These will be slimmed in the future.

For Lincense information view the LICENSE file.


How to Start
-------------------------

You can use Scoots on your own IRC server or in your own IRC channel on another server. Scoots is designed to run as a daemon in the background. Errors will be logged inside the logs folder.

1. Edit the settings.yml file to set your bot, server, and channel information.

2. Run the init script;

    ruby init.rb start


Operations
-------------------------

Scoots operates as a daemon, and as such, can be controlled using standard start/stop/restart commands. Even as a daemon Scoots will store all log information inside the Scoots directory.
