# Wireshark Check IP2Location Lua Plugin
This Lua plugin lets you right-click on a packet to look up its source or destination IP on IP2Location ([ip2location.com](https://ip2location.com)) in your default browser.
It works with both IPv4 and IPv6 addresses, showing the resolved hostname next to each if "Resolve network (IP) addresses" is enabled.

## Installation
Copy the script into your Lua plugins directory
(check `About Wireshark → Folders → Personal Lua Plugins`):

- Windows: `%APPDATA%\Wireshark\plugins\`
- macOS/Linux: `~/.local/lib/wireshark/plugins/`

Reload without restarting: **Analyze → Reload Lua Plugins** (Ctrl/Cmd+Shift+L).

## How to use
Right-click a packet in the packet list -> Check IP2Location.
It shows both addresses in a window with "Source" and "Destination" buttons. Click one to open it in your browser.

## Requirements
Wireshark 4.2+
