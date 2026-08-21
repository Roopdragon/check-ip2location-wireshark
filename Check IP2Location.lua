--[[
Wireshark Lua plugin: look up a packet's IP address on ip2location.com.

Right-click a packet in the packet list -> Check IP2Location.
Only appears when the selected packet has ip.src/ip.dst (IPv4) or ipv6.src/ipv6.dst (IPv6) fields.
Shows both addresses in a window with "Source" and "Destination" buttons.

Requires Wireshark 4.2+ (register_packet_menu's FieldInfo-argument support was added then).
--]]

local function open_ip(ip_str)
    if not ip_str or ip_str == "" then
        print("check_ip2location: no IP available")
        return
    end
    browser_open_url("https://www.ip2location.com/" .. ip_str .. "#link-share")
end

-- Packet context menu
local function packet_menu_action(...)
    local src_finfo, dst_finfo
    for _, finfo in ipairs({...}) do
        local name = finfo.name
        if name == "ip.src" or name == "ipv6.src" then
            src_finfo = src_finfo or finfo
        elseif name == "ip.dst" or name == "ipv6.dst" then
            dst_finfo = dst_finfo or finfo
        end
    end

    if not src_finfo or not dst_finfo then
        print("check_ip2location: couldn't find both src and dst IP fields on this packet")
        return
    end

    local src_ip = tostring(src_finfo)
    local dst_ip = tostring(dst_finfo)

    -- Returns Wireshark's "hostname (ip)" format when resolution succeeds "one.one.one.one (1.1.1.1)", or just the bare ip when it doesn't.
    local function label(finfo, ip)
        local disp = finfo.display
        if disp and disp ~= "" then
            return disp
        end
        return ip
    end

    local win = TextWindow.new("Check IP2Location")
    win:set("Source:      " .. label(src_finfo, src_ip) .. "\nDestination: " .. label(dst_finfo, dst_ip))

    win:add_button("Source", function()
        open_ip(src_ip)
        win:close()
    end)
    win:add_button("Destination", function()
        open_ip(dst_ip)
        win:close()
    end)
end

if gui_enabled() then
    -- separate registrations so it works on both IPv4 and IPv6 packets
    register_packet_menu("Check IP2Location", packet_menu_action, "ip.src,ip.dst")
    register_packet_menu("Check IP2Location", packet_menu_action, "ipv6.src,ipv6.dst")
end
