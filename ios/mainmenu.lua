-- Main Menu
os.pullEvent = os.pullEventRaw

local w,h = term.getSize()

-- Usage: printCentered(int y, string s)
function printCentered(y, s)
   local x = math.floor((w - string.len(s)) / 2)
   term.setCursorPos(x,y)
   term.clearLine()
   term.write(s)
end

local nOption = 1
local sVersion = "0.1 (DEV)"

local function drawMenu()
  term.clear()
  term.setCursorPos(1, 1)
  term.write("ImpendingOS Alpha // Ver " .. sVersion)
  --term.setCursorPos(1, 2)
  --shell.run("id")
  
  term.setCursorPos(w - 11, 1)
  if nOption == 1 then
    term.write("Shell")
  elseif nOption == 2 then
    term.write("Programs")
  elseif nOption == 3 then
    term.write("Shutdown")
  elseif nOption == 4 then
    term.write("Reboot")
  else
  end
end


-- GUI
term.clear()
local function drawFrontend()
  printCentered(math.floor(h/2) - 3, "")
  printCentered(math.floor(h/2) - 2, "Main Menu")
  printCentered(math.floor(h/2) - 1, "")
  printCentered(math.floor(h/2) + 0, ((nOption == 1) and "> Shell    <") or "Shell   ")
  printCentered(math.floor(h/2) + 1, ((nOption == 2) and "> Programs <") or "Programs")
  printCentered(math.floor(h/2) + 2, ((nOption == 3) and "> Shutdown <") or "Shutdown")
  printCentered(math.floor(h/2) + 3, ((nOption == 4) and "> Reboot   <") or "Reboot  ")
  printCentered(math.floor(h/2) + 4, "")
end

drawMenu()
drawFrontend()

-- Menu loop
while true do
  local e,p = os.pullEvent()
  if e == "key" then
    local key = p
	if key == 17 or key == 200 then
	  if nOption > 1 then
	    nOption = nOption - 1
		drawMenu()
		drawFrontend()
	  end
	elseif key == 31 or key == 208 then
	  if nOption < 4 then nOption = nOption + 1
	  drawMenu()
	  drawFrontend()
	end
	elseif key == 28 then
	break
	end
  end
end
term.clear()

-- Commands
if nOption == 1 then
--shell.run("ios/.command.lua")
elseif nOption == 2 then
shell.run("ios/.programs.lua")
elseif nOption == 3 then
os.shutdown()
else
os.reboot()
end
