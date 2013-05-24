## Scoots!
=======

Scoots is a very simple and lightweight **IRC link information bot** written in Ruby that runs as a *nix daemon.

This bot is still in development. Scoots requires the 'mechanize' and 'daemons' gems to function properly.

For Lincense information view the LICENSE file.


**Setup & Installation**

You can use Scoots on your own IRC server or in your own IRC channel on another server.

1. Edit the settings.yml file to fit your bot, server, and channel information.

2. Make sure you have the 'mechanize' and 'daemons' gems installed.

3. Run the init script; simply "ruby init.rb start".


**Operations**

Scoots operates as a daemon, and as such, can be controlled using standard start/stop/restart commands. Even as a daemon Scoots will store all log information inside the Scoots directory. Scoots will rejoin a channel upon an unexpected timeout, but will not rejoin if kicked.
