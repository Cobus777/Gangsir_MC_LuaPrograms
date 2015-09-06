--[[
Opencomputers port of pulse by KingofGamesYami, who's original thread can be found at
http://www.computercraft.info/forums2/index.php?/topic/24500-pulse-it-just-looks-cool/
At least tier 2 screen and graphics card required, but use tier 3 for best results.
This program generates cool looking designs using text.
Causes high power usage when using tier 3 screens, so plan accordingly
Press a key to cleanly end the program.
Char and colour table reading is dynamic, so add more if you want more variety.
--]]


local term = require("term")
local component = require("component")
local gpu = component.gpu
local event = require("event")
running = true --should the program keep running

--list of characters to pick from (More can be added)
local chartbl = {"*","%","@","?","/","&","+","-","!"}
--list of colours to pick from (Note: Since oc's colours library returns numbers and not hex codes, I made my own)
local colortbl = { 0x000000, 0xFFFFFF, 0x0000FF, 0x00F2FF, 0x00FFFF, 0x00FF00, 0x3CFF00, 0xEFFF0D, 0xFF04D3, 0xFF0090, 0x660099}

local curCol, incCol, reverse, maxx, maxy = 1, 1, false, gpu.maxResolution()

local function advClear( c, b, t )
        gpu.setBackground( b ) --set the background colour
        gpu.setForeground( t ) --set the text colour
        for y = 1, maxy do
                term.setCursor( 1, y )
                term.write( c:rep( maxx ) )
        end
end

--exits the program cleanly, by returning gpu settings to default.
local function exitProgram()
  running = false
  gpu.setBackground(0x000000) --default
  gpu.setForeground(0xFFFFFF) --default
  term.clear()
  os.execute("clear")
  event.ignore("key_up",exitProgram) --remove the event listen
  print("Successfully ended Pulse.")
  os.sleep(1)
  os.exit() --kill program.
end


print("To exit cleanly once the program starts, press a key.")
os.sleep(3)
event.listen("key_up",exitProgram) --register the event listener for a key press
term.clear()
while running do
        for theChar = (reverse and #chartbl or 1), (reverse and 1 or #chartbl), (reverse and -1 or 1) do
                if running then advClear( chartbl[ theChar ], colortbl[ curCol ], colortbl[ curCol + (reverse and -1 or 1) ] ) else break end
                os.sleep( 0.05 ) --to prevent fail to yield crashes
        end
        for theChar = (reverse and 1 or #chartbl), (reverse and #chartbl or 1), (reverse and 1 or -1 ) do
                if running then advClear( chartbl[ theChar ], colortbl[ curCol + (reverse and -1 or 1) ], colortbl[ curCol ]  ) else break end
                os.sleep( 0.05 )
        end
        curCol = curCol + (reverse and -1 or 1)
        if curCol == 1 or curCol == #colortbl then
                reverse = not reverse
        end
end
--eof
