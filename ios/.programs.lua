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
    term.write("Installer")
  elseif nOption == 2 then
    term.write("Minesweeper")
  elseif nOption == 3 then
    term.write("Reversi")
  elseif nOption == 4 then
    term.write("Back")
  else
  end
end


-- GUI
term.clear()
local function drawFrontend()
  printCentered(math.floor(h/2) - 3, "")
  printCentered(math.floor(h/2) - 2, "Programs")
  printCentered(math.floor(h/2) - 1, "")
  printCentered(math.floor(h/2) + 0, ((nOption == 1) and "> Make OS Installer <") or "Make OS Installer")
  printCentered(math.floor(h/2) + 1, ((nOption == 2) and "> Minesweeper <      ") or "Minesweeper      ")
  printCentered(math.floor(h/2) + 2, ((nOption == 3) and "> Reversi <          ") or "Reversi          ")
  printCentered(math.floor(h/2) + 3, ((nOption == 4) and "> Back <             ") or "Back             ")
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
shell.run("ios/.programs.lua")
elseif nOption == 2 then
shell.run("ios/programs/mines.lua")
elseif nOption == 3 then
shell.run("ios/programs/othello.lua", "AI")
else
shell.run("ios/mainmenu.lua")
end