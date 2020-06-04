Sample init scripts and service configuration for pyeongtaekcoind
==========================================================

Sample scripts and configuration files for systemd, Upstart and OpenRC
can be found in the contrib/init folder.

    contrib/init/pyeongtaekcoind.service:    systemd service unit configuration
    contrib/init/pyeongtaekcoind.openrc:     OpenRC compatible SysV style init script
    contrib/init/pyeongtaekcoind.openrcconf: OpenRC conf.d file
    contrib/init/pyeongtaekcoind.conf:       Upstart service configuration file
    contrib/init/pyeongtaekcoind.init:       CentOS compatible SysV style init script

Service User
---------------------------------

All three Linux startup configurations assume the existence of a "pyeongtaekcoin" user
and group.  They must be created before attempting to use these scripts.
The macOS configuration assumes pyeongtaekcoind will be set up for the current user.

Configuration
---------------------------------

At a bare minimum, pyeongtaekcoind requires that the rpcpassword setting be set
when running as a daemon.  If the configuration file does not exist or this
setting is not set, pyeongtaekcoind will shutdown promptly after startup.

This password does not have to be remembered or typed as it is mostly used
as a fixed token that pyeongtaekcoind and client programs read from the configuration
file, however it is recommended that a strong and secure password be used
as this password is security critical to securing the wallet should the
wallet be enabled.

If pyeongtaekcoind is run with the "-server" flag (set by default), and no rpcpassword is set,
it will use a special cookie file for authentication. The cookie is generated with random
content when the daemon starts, and deleted when it exits. Read access to this file
controls who can access it through RPC.

By default the cookie is stored in the data directory, but it's location can be overridden
with the option '-rpccookiefile'.

This allows for running pyeongtaekcoind without having to do any manual configuration.

`conf`, `pid`, and `wallet` accept relative paths which are interpreted as
relative to the data directory. `wallet` *only* supports relative paths.

For an example configuration file that describes the configuration settings,
see `share/examples/pyeongtaekcoin.conf`.

Paths
---------------------------------

### Linux

All three configurations assume several paths that might need to be adjusted.

Binary:              `/usr/bin/pyeongtaekcoind`  
Configuration file:  `/etc/pyeongtaekcoin/pyeongtaekcoin.conf`  
Data directory:      `/var/lib/pyeongtaekcoind`  
PID file:            `/var/run/pyeongtaekcoind/pyeongtaekcoind.pid` (OpenRC and Upstart) or `/var/lib/pyeongtaekcoind/pyeongtaekcoind.pid` (systemd)  
Lock file:           `/var/lock/subsys/pyeongtaekcoind` (CentOS)  

The configuration file, PID directory (if applicable) and data directory
should all be owned by the pyeongtaekcoin user and group.  It is advised for security
reasons to make the configuration file and data directory only readable by the
pyeongtaekcoin user and group.  Access to pyeongtaekcoin-cli and other pyeongtaekcoind rpc clients
can then be controlled by group membership.

### macOS

Binary:              `/usr/local/bin/pyeongtaekcoind`  
Configuration file:  `~/Library/Application Support/Pyeongtaekcoin/pyeongtaekcoin.conf`  
Data directory:      `~/Library/Application Support/Pyeongtaekcoin`  
Lock file:           `~/Library/Application Support/Pyeongtaekcoin/.lock`  

Installing Service Configuration
-----------------------------------

### systemd

Installing this .service file consists of just copying it to
/usr/lib/systemd/system directory, followed by the command
`systemctl daemon-reload` in order to update running systemd configuration.

To test, run `systemctl start pyeongtaekcoind` and to enable for system startup run
`systemctl enable pyeongtaekcoind`

NOTE: When installing for systemd in Debian/Ubuntu the .service file needs to be copied to the /lib/systemd/system directory instead.

### OpenRC

Rename pyeongtaekcoind.openrc to pyeongtaekcoind and drop it in /etc/init.d.  Double
check ownership and permissions and make it executable.  Test it with
`/etc/init.d/pyeongtaekcoind start` and configure it to run on startup with
`rc-update add pyeongtaekcoind`

### Upstart (for Debian/Ubuntu based distributions)

Upstart is the default init system for Debian/Ubuntu versions older than 15.04. If you are using version 15.04 or newer and haven't manually configured upstart you should follow the systemd instructions instead.

Drop pyeongtaekcoind.conf in /etc/init.  Test by running `service pyeongtaekcoind start`
it will automatically start on reboot.

NOTE: This script is incompatible with CentOS 5 and Amazon Linux 2014 as they
use old versions of Upstart and do not supply the start-stop-daemon utility.

### CentOS

Copy pyeongtaekcoind.init to /etc/init.d/pyeongtaekcoind. Test by running `service pyeongtaekcoind start`.

Using this script, you can adjust the path and flags to the pyeongtaekcoind program by
setting the PYEONGTAEKCOIND and FLAGS environment variables in the file
/etc/sysconfig/pyeongtaekcoind. You can also use the DAEMONOPTS environment variable here.

### macOS

Copy org.pyeongtaekcoin.pyeongtaekcoind.plist into ~/Library/LaunchAgents. Load the launch agent by
running `launchctl load ~/Library/LaunchAgents/org.pyeongtaekcoin.pyeongtaekcoind.plist`.

This Launch Agent will cause pyeongtaekcoind to start whenever the user logs in.

NOTE: This approach is intended for those wanting to run pyeongtaekcoind as the current user.
You will need to modify org.pyeongtaekcoin.pyeongtaekcoind.plist if you intend to use it as a
Launch Daemon with a dedicated pyeongtaekcoin user.

Auto-respawn
-----------------------------------

Auto respawning is currently only configured for Upstart and systemd.
Reasonable defaults have been chosen but YMMV.
