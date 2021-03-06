----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
----------------------------------------------------------

-- {{{ Grab environment
local io = { open = io.open }
local setmetatable = setmetatable
-- }}}


-- Thermal: provides temperature levels of ACPI thermal zones
module("vicious.thermal")


-- {{{ Thermal widget type
local function worker(format, thermal_zone)
    -- Get thermal zone
    local f = io.open("/sys/class/hwmon/hwmon0/device/temp2_input")
    local line = f:read("*line")
    f:close()

    -- Get temperature data
    local temperature = line:match("[%d]?[%d]")

    return {temperature}
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
