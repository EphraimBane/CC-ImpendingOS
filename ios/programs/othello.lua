--Othello by KingofGamesYami

term.clear()
local board = {}
for i = 1, 8 do
	board[ i ] = {}
end
board[ 0 ] = {}
board[ 9 ] = {}

board[ 4 ][ 4 ] = colors.white
board[ 4 ][ 5 ] = colors.black
board[ 5 ][ 4 ] = colors.black
board[ 5 ][ 5 ] = colors.white

local hideMoves, AI, mon

local tArgs = { ... }
for k, v in pairs( tArgs ) do
	if v:lower() == "hidemoves" then
		hideMoves = true
	elseif v:lower() == "ai" then
		AI = true
	elseif v:lower() == "monitor" then
		for k, v in pairs( peripheral.getNames() ) do
			if peripheral.getType( v ) == "monitor" and peripheral.call( v, "isColor" ) then
				--y 14
				--x 33
				peripheral.call( v, "setTextScale", 1 )
				local x, y = peripheral.call( v, "getSize" )
				peripheral.call( v, "setTextScale", math.floor( math.min( y/12, x/33 ) ) )
				term.redirect( peripheral.wrap( v ) )
				mon = true
			end
		end
	end
end

local maxx, maxy = term.getSize()
xOffset = math.floor( maxx/2 ) - 4
yOffset = math.floor( maxy/2 ) - 4
local turn = colors.white
local moves = 60

local function flip( x, y, color )
	term.setCursorPos( x +xOffset, y +yOffset )
	term.setBackgroundColor( colors.green )
	term.setTextColor( color == colors.white and colors.black or colors.white )
	term.write( "|" )
	sleep( 0.1 )
	term.setCursorPos( x +xOffset, y +yOffset )
	term.setTextColor( color )
	term.write( "|" )
	term.setCursorPos( x +xOffset, y +yOffset )
	sleep( 0.2 )
	board[ x ][ y ] = color
	term.setTextColor( color or colors.red )
	term.write( "0" )
end

local function checkMove( x, y, color )
	if not board[ x ] or board[ x ][ y ] then
		return false
	end
	local isValid = false
	local toFlip = {}
	local flip = false
	for i = y + 1, 8 do
		if not board[ x ][ i ] then
			break
		elseif board[ x ][ i ] ~= color then
			flip = true
		elseif flip then
			isValid = true
			for _i = i - 1, y, -1 do
				toFlip[ #toFlip + 1 ] = {x = x, y = _i}
			end
			break
		else
			break
		end
	end
	flip = false
	for i = y - 1, 1, -1 do
		if not board[ x ][ i ] then
			break
		elseif board[ x ][ i ] ~= color then
			flip = true
		elseif flip then
			isValid = true
			for _i = i + 1, y do
				toFlip[ #toFlip + 1 ] = {x = x, y = _i}
			end
			break
		else
			break
		end
	end
	flip = false
	for i = x + 1, 8 do
		if not board[ i ][ y ] then
			break
		elseif board[ i ][ y ] ~= color then
			flip = true
		elseif flip then
			isValid = true
			for _i = i - 1, x, -1 do
				toFlip[ #toFlip + 1 ] = {x = _i, y = y}
			end
			break
		else
			break
		end
	end
	flip = false
	for i = x - 1, 1, -1 do
		if not board[ i ][ y ] then
			break
		elseif board[ i ][ y ] ~= color then
			flip = true
		elseif flip then
			isValid = true
			for _i = i + 1, x do
				toFlip[ #toFlip + 1 ] = {x = _i, y = y}
			end
			break
		else
			break
		end
	end
	--begin diagonal checking
	flip = false
	local _x, _y = x, y
	while _x <= 8 and _y <= 8 do
		_x = _x + 1
		_y = _y + 1
		if not board[ _x ][ _y ] then
			break
		elseif board[ _x ][ _y ] ~= color then
			flip = true
		elseif flip then
			isValid = true
			while _x ~= x and _y ~= y do
				_x = _x - 1
				_y = _y - 1
				toFlip[ #toFlip + 1 ] = { x = _x, y = _y }
			end
			break
		else
			break
		end
	end
	flip = false
	local _x, _y = x, y
	while _x <= 8 and _y >= 1 do
		_x = _x + 1
		_y = _y - 1
		if not board[ _x ][ _y ] then
			break
		elseif board[ _x ][ _y ] ~= color then
			flip = true
		elseif flip then
			isValid = true
			while _x ~= x and _y ~= y do
				_x = _x - 1
				_y = _y + 1
				toFlip[ #toFlip + 1 ] = { x = _x, y = _y }
			end
			break
		else
			break
		end
	end
	flip = false
	local _x, _y = x, y
	while _x >= 1 and _y <= 8 do
		_x = _x - 1
		_y = _y + 1
		if not board[ _x ][ _y ] then
			break
		elseif board[ _x ][ _y ] ~= color then
			flip = true
		elseif flip then
			isValid = true
			while _x ~= x and _y ~= y do
				_x = _x + 1
				_y = _y - 1
				toFlip[ #toFlip + 1 ] = { x = _x, y = _y }
			end
			break
		else
			break
		end
	end
	flip = false
	local _x, _y = x, y
	while _x >=1 and _y >= 1 do
		_x = _x - 1
		_y = _y - 1
		if not board[ _x ][ _y ] then
			break
		elseif board[ _x ][ _y ] ~= color then
			flip = true
		elseif flip then
			isValid = true
			while _x ~= x and _y ~= y do
				_x = _x + 1
				_y = _y + 1
				toFlip[ #toFlip + 1 ] = { x = _x, y = _y }
			end
			break
		else
			break
		end
	end
	return isValid and toFlip or false
end

local function getScore()
	local black, white = 0, 0
	for x = 1, 8 do
		for y = 1, 8 do
			if board[ x ][ y ] == colors.white then
				white = white + 1
			elseif board[ x ][ y ] == colors.black then
				black = black + 1
			end
		end
	end
	return black, white
end

local function showValidMoves( color )
	local moves = 0
	term.setTextColor( colors.brown )
	for x = 1, 8 do
		for y = 1, 8 do
			if checkMove( x, y, color ) then
				if not hideMoves then
					term.setCursorPos( x + xOffset, y + yOffset )
					term.write( "0" )
				end
				moves = moves + 1
			end
		end
	end
	return moves == 0
end

local function render()
	term.setBackgroundColor( colors.green )
	for x = 1, 8 do
		for y = 1, 8 do
			term.setCursorPos( x +xOffset, y+yOffset )
			term.setTextColor( board[ x ][ y ] or colors.lightGray )
			term.write( "0" )
		end
	end
end

local function showStats()
	local black, white = getScore()
	term.setTextColor( colors.lightBlue )
	term.setBackgroundColor( colors.blue )
	term.setCursorPos( xOffset - 11, yOffset + 4 )
	term.write( "Black: " .. (tostring( black ):reverse() .. "0" ):match( "%d%d" ):reverse() )
	term.setCursorPos( xOffset + 12, yOffset + 4 )
	term.write( "White: " .. (tostring( white ):reverse() .. "0" ):match( "%d%d" ):reverse() )
	term.setCursorPos( xOffset + 2, yOffset - 2 )
	term.write( "Turn: " .. (turn == colors.white and "W" or "B") )
end

local function drawBorder()
	term.setBackgroundColor( colors.blue )
	term.setTextColor( colors.lightBlue )
	term.setCursorPos( xOffset, yOffset )
	term.write( "\\||||||||/" )
	term.setCursorPos( xOffset, yOffset + 9 )
	term.write( "/||||||||\\" )
	for i = 1, 8 do
		term.setCursorPos( xOffset, yOffset + i )
		term.write( "=" )
		term.setCursorPos( xOffset + 9, yOffset + i )
		term.write( "=" )
	end
end

local function AIMove()
	local numDots, flips, move = 1, 0
	term.setBackgroundColor( colors.blue )
	term.setTextColor( colors.lightBlue )
	for x = 1, 8 do
		term.setCursorPos( xOffset - 9, yOffset + 3 )
		term.write( string.rep( ".", numDots ) )
		term.write( string.rep( " ", 3 - numDots ) )
		numDots = (numDots + 1) % 4
		for y = 1, 8 do
			local results = checkMove( x, y, colors.black )
			if results and #results > flips then
				move = { x = x, y = y }
				flips = #results
			elseif results and #results == flips and math.random( 1, 2 ) == 1 then
				move = { x = x, y = y }
			end
		end
		sleep(0.05)
	end
	term.setBackgroundColor( colors.black )
	term.setCursorPos( xOffset - 9, yOffset + 3 )
	term.write( "   " )
	return move
end

drawBorder()
render()
showValidMoves( colors.white )
showStats()

while moves > 0 do
	local event = {os.pullEvent()}
	if (mon and event[ 1 ] == "monitor_touch") or event[ 1 ] == "mouse_click" then
		event[ 3 ] = event[ 3 ] - xOffset
		event[ 4 ] = event[ 4 ] - yOffset
		if event[ 3 ] >= 1 and event[ 3 ] <= 8 and event[ 4 ] <= 8 and event[ 4 ] >= 1 then
			local result = checkMove( event[ 3 ], event[ 4 ], turn )
			if result then
				board[ event[ 3 ] ][ event[ 4 ] ] = turn
				term.setCursorPos( event[ 3 ] + xOffset, event[ 4 ] + yOffset )
				term.setTextColor( turn )
				term.setBackgroundColor( colors.green )
				term.write( "0" )
				for _, v in ipairs( result ) do
					if v.x == event[ 3 ] and v.y == event[ 4 ] then
						--do nothing
					else
						flip( v.x, v.y, turn )
					end
				end
				turn = turn == colors.white and colors.black or colors.white
				moves = moves - 1
				render()
				if showValidMoves( turn ) then
					turn = turn == colors.white and colors.black or colors.white
					if showValidMoves( turn ) then
						break
					end
				end
			end
			showStats()
		end
		if AI and turn == colors.black then
			local result = AIMove()
			os.queueEvent( "mouse_click", 1, result.x + xOffset, result.y + yOffset )
		end
	elseif event[ 1 ] == "char" and event[ 2 ] == "m" then
		hideMoves = not hideMoves
		render()
		showValidMoves( turn )
	end
end

term.setBackgroundColor( colors.black )
term.setTextColor( colors.white )
term.clear()
term.setCursorPos( 1, 1 )
local black, white = getScore()
print( "Congrats " .. (black > white and "black" or "white") .. "! You won the game!" )