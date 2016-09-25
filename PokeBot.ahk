;----------------------------PokéBot Script------------------------------------------------------------------
#NoEnv
#Warn
#SingleInstance Force
SetWorkingDir %A_ScriptDir%


;---------------------------- About -------------------------

/*
	Name : PokéBot
	Version : 0.1.4
	Last update : 14/09/2016
	Author : Undershell
	Repository : https://github.com/undershell/pokebot
*/

;---------------------------- TODO --------------------------





;---------------------------- Var ---------------------------


; You can edit the variables here


;------------

	; Series of move's keys. For example : ["w", "s"] or ["a", "d"] or ["w", "a", "s", "d"]
	moves := ["a", "d"]	


;------------
	
	; Pokemon Recognation

	Pokemons_colors := [ ]

	Pokemons_names  := [ ]

;------------


;End of editable Vars

;------------------------ Load Data ------------------------

	IsPaused := false
	nbrWindows = 0	; in case you want to play/switch many windows
	Walk = false	; walk or fish
	xpSecond = false	;  Exp the 1st pokemon using the 2nd
	

	IniRead, win_Title, config.ini, Settings, Win_Title

	IniRead, RefreshButtonX, config.ini, Settings, RefreshButtonX
	IniRead, RefreshButtonY, config.ini, Settings, RefreshButtonY
	IniRead, enable_bug_refresh, config.ini, Settings, enable_bug_refresh

	; Principle Button coordinates "Fight"
	IniRead, ButtonPixelColor, config.ini, Fight Button, ButtonPixelColor
	IniRead, ButtonPixelX, config.ini, Fight Button, ButtonPixelX
	IniRead, ButtonPixelY, config.ini, Fight Button, ButtonPixelY


	; Pokemon Recognation
	IniRead, enable_pokemon_recognation, config.ini, Pokemon Recognation, enable_pokemon_recognation
	IniRead, PokemonPixelX, config.ini, Pokemon Recognation, PokemonPixelX
	IniRead, PokemonPixelY, config.ini, Pokemon Recognation, PokemonPixelY



;---------------------------------------------------------------------------------------------------------





;---------------------------- GUI ---------------------------

Menu Tray, Icon, icons\UltraBall.ico
Gui PokeBot: New, -MaximizeBox +AlwaysOnTop

Gui Add, Tab2, x2 y1 w205 h180, Game|Config|Help

Gui,Tab, Game

	Gui Add, Text, x16 y33 w95 h23, Multi Windows :
	Gui Add, Edit, x118 y30 w41 h21 vnbrWindows, 0

	Gui Add, CheckBox, x13 y55 w188 h23 vXpSecond, Exp the 1st pokemon using the 2nd 
	Gui Add, CheckBox, x13 y75 w120 h23 vWalk, Walk
	Gui Add, CheckBox, x13 y95 w180 h23 venable_pokemon_recognation, Pokemon Recognation
	Gui Add, CheckBox, x13 y115 w180 h23 venable_bug_refresh, Bug Refresh

	Gui Add, Text, x8 y142 w198 h2 0x10

	Gui Add, Button, x40 y150 w60 h23 gRun, Run
	;Gui Add, Button, x85 y130 w48 h23 gPauseB vPauseButton, Pause
	Gui Add, Button, x110 y150 w60 h23 gOpen, Open


Gui,Tab, Config

	Gui Add, Button, x30 y30 w160 h23 gLocalizeFightButton, Localize Fight button
	Gui Add, Button, x30 y60 w160 h23 gLocalizePokemon, Localize Pokemon's Pixel
	Gui Add, Button, x30 y90 w160 h23 gLocalizeRefreshButton, Localize Refresh Button

	Gui Add, Text, x8 y142 w198 h2 0x10

	Gui Add, Button, x30 y150 w160 h23 gSaveLocations, Save Locations

	;Gui Add, Button, x30 y80 w150 h23 gCapture, Capture color
	Gui Show, w481 h381, Window


Gui,Tab, Help

	Gui Add, Text, x9 y50 w198 h2 0x10


Gui Show, w209 h200, PokeBot
Return

PokeBotGuiEscape:
PokeBotGuiClose:
    ExitApp

; End of the GUI section

;---------------------------------------------------------------------------------------------------------


;------------
Run:
	Gui, Submit ;,NoHide
	play(walk, xpSecond, Win_Title, nbrWindows, ButtonPixelColor, ButtonPixelX, ButtonPixelY, PokemonPixelX, PokemonPixelY, moves, enable_pokemon_recognation, Pokemons_colors, Pokemons_names, RefreshButtonX, RefreshButtonY, enable_bug_refresh)
return

;------------
Open:
	run http://pokemon-planet.com/gameFullscreen.php
return

;------------
PauseB:
	;clear tooltips
	controlSend,, {ctrl down}f{ctrl up}, Win_Title
	sleep 5000
	
	SetTitleMatchMode, 2
	controlSend,, {ctrl down}F5{ctrl up}, Chrome

	if IsPaused
	{
		;Pause Off
		IsPaused := false
		GuiControl,, PauseButton, Pause
		ToolTip, Bot Paused
	}
	else{
		;Pause On
		IsPaused := true
		GuiControl,, PauseButton, Resume	
	}	

return

;------------
LocalizeFightButton:
	KeyWait, LButton, D ; Wait for the left mouse button to be pressed down.
		MouseGetPos, ButtonPixelX, ButtonPixelY
	KeyWait, LButton, U ; Wait for the left mouse button to be pressed down.
	WinGetTitle, Win_Title, A
	ToolTip, Button Center defined at : {%ButtonPixelX%.%ButtonPixelY%} - {%Win_Title%},  %ButtonPixelX%, %ButtonPixelY%,

return

;------------
LocalizePokemon:
	KeyWait, LButton, D ; Wait for the left mouse button to be pressed down.
		MouseGetPos, PokemonPixelX, PokemonPixelY
	KeyWait, LButton, U ; Wait for the left mouse button to be pressed down.
	ToolTip, Pokemon Pixel defined at : {%PokemonPixelX%.%PokemonPixelY%},  %PokemonPixelX%, %PokemonPixelY%,

return

;------------
LocalizeRefreshButton:
	KeyWait, LButton, D ; Wait for the left mouse button to be pressed down.
		MouseGetPos, RefreshButtonX, RefreshButtonY
	KeyWait, LButton, U ; Wait for the left mouse button to be pressed down.
	ToolTip, Pokemon Pixel defined at : {%RefreshButtonX%.%PokemonPixelY%},  %RefreshButtonX%, %RefreshButtonY%,
return

;------------
SaveLocations: ; Save Data

	IniWrite, %Win_Title%, config.ini, Settings, Win_Title

	; Principle Button coordinates "Fight"
	IniWrite, %ButtonPixelX%, config.ini, Fight Button, ButtonPixelX
	IniWrite, %ButtonPixelY%, config.ini, Fight Button, ButtonPixelY

	; Pokemon Recognation
	IniWrite, %PokemonPixelX%, config.ini, Pokemon Recognation, PokemonPixelX
	IniWrite, %PokemonPixelY%, config.ini, Pokemon Recognation, PokemonPixelY

	; Browser refresh button
	IniWrite, %RefreshButtonX%, config.ini, Settings, RefreshButtonX
	IniWrite, %RefreshButtonY%, config.ini, Settings, RefreshButtonY

return

;------------
Capture:
	PixelGetColor, ButtonPixelColor, ButtonPixelX, ButtonPixelY
	ToolTip, Captured color :  {%ButtonPixelColor%} %ButtonPixelX% %ButtonPixelY% ,  %ButtonPixelX%, %ButtonPixelY%,
return


;---------------------------------------------------------------------------------------------------------
	


;---------------------------------------------------------------------------------------------------------


;-------------------------- Pokemon Recognation ------------------------

pokemonRecognation(PokemonPixelX, PokemonPixelY, Pokemons_colors, Pokemons_names){

	PixelGetColor, PColor, PokemonPixelX, PokemonPixelY

	toretrun := false

	for key, value in Pokemons_colors{
		if( value = PColor )
			toretrun := Pokemons_names[key]
	}
	
	ToolTip, Pokemon Recognation :  %PColor% - %toretrun%, 846, 413
	
	return toretrun
}

;---------------------------- Function Play ---------------------------

play(walk, xpSecond, Win_Title, nbrWindows, ButtonPixelColor, ButtonPixelX, ButtonPixelY, PokemonPixelX, PokemonPixelY, moves, enable_pokemon_recognation, Pokemons_colors, Pokemons_names, RefreshButtonX, RefreshButtonY, enable_bug_refresh){
	
	index := 0
	checked = 1
	refreshed = 0
	


	;-------------------------------------------------------------------------------------------------
	Loop
	{

		if(nbrWindows>0)
			switchWindows(nbrWindows)
		
		if(walk = 0)
			Sleep % rand(2000, 4000)
		
		PixelGetColor, Color, ButtonPixelX, ButtonPixelY
		
		ToolTip, Check Pixel Color, ButtonPixelX, ButtonPixelY
		
		if (Color = ButtonPixelColor)
		{
			refreshed = 0

			if (enable_pokemon_recognation>0) && (pokemonRecognation(PokemonPixelX, PokemonPixelY, Pokemons_colors, Pokemons_names) = false){
				Pause
			}

			Sleep % rand(1200, 1500)
			
			ToolTip, %a_index%- Pixel Checking : Affirmative, ButtonPixelX, ButtonPixelY
			checked++
			Sleep % rand(800, 1000)
			
			;---------------------------- XP Second -------------------------
			if(xpSecond){
				
				Sleep % rand(1500, 2000)
				
				LOOP, 2 {
					SetMouseDelay % rand(30, 300)
					ControlClick, x363 y674, %Win_Title%

					ToolTip, Switch pokemon : Click  %a_index%, 363, 674

					Sleep % rand(3000, 4000)
				}
				
				ToolTip, Switch done, 363, 674
				Sleep % rand(4500, 6000)
			}
			
			;---------------------------- Fight ------------------------------
			;If you want autofight & avoid missings & other problems,
			;you can check the color here as well
			; PixelGetColor, Color, ButtonPixelX, ButtonPixelY ;if (Color= ButtonPixelColor){ }else{}
			
			Loop,   ; %nbrAttacks% max nbr of attacks needed
			{
				PixelGetColor, Color, ButtonPixelX, ButtonPixelY
				if (Color= ButtonPixelColor){ 
					Loop, 2{
						RX := rand(ButtonPixelX-5, ButtonPixelX+5)
						RY := rand(ButtonPixelY-5, ButtonPixelY+5)
						ToolTip, Fighting : Click %a_index%, RX, RY

						SetMouseDelay % rand(30, 300)
						ControlClick, x%RX% y%RY%, %Win_Title%
					}
					Sleep % rand(1500, 2000)
					ToolTip, Fighting done, RX, RY
					;Sleep % rand(4500, 6000)
				}else{	
					ToolTip, Fighting done, ButtonPixelX, ButtonPixelY
					;Sleep % rand(4500, 6000)
					break
				}
				
			}
			

			
		}else{

			if(enable_bug_refresh>0)
				checkBug(walk, refreshed,RefreshButtonX, RefreshButtonY, ButtonPixelX-20, ButtonPixelY-50, Win_Title)

			ToolTip, %a_index%- Pixel Checking : Negative, ButtonPixelX, ButtonPixelY
			checked--
			
			if walk{

				Loop, {
				
					move := moves[index]
					ToolTip, Move %a_index% : %move%, 300, 300
					
					PixelGetColor, Color, ButtonPixelX, ButtonPixelY
					if (Color = ButtonPixelColor){
						ToolTip, Attack, 300, 300
						break
						
					}else{
						if(enable_bug_refresh>0)
							checkBug(walk, refreshed,RefreshButtonX, RefreshButtonY, ButtonPixelX-20, ButtonPixelY-50, Win_Title)

						Send {%move% down}	;ControlSend
						
						Sleep % rand(1000, 2000)
						
						Send {%move% up}	;ControlSend

					}
					
					Sleep % rand(10, 60)

					if index = 2 ;lengh if moves
						index = 1 
					else
						index++
					
				}
			}else{
				; removed temporarily
			}

		} 
		
		
	}
}

;---------------------------------------------------------------------------------------------------------


;---------------------------- Helpers ---------------------------

rand(x,y){
	Random, value, %x%, %y%
	Return value
}


switchWindows(num)
{
	send {alt down}
	loop, %num%{
		send {tab down}{tab up}
		sleep , 25
	}
	send {alt up}
	ControlClick, x410 y500, Win_Title
	sleep, 500
}


; if a bug on the browser or connection turned the flash screen on dark or white
checkBug(walk, refreshed, RefreshButtonX, RefreshButtonY, x, y, Win_Title){ 

		PixelGetColor, Color, x-30, y+10
		; check x-i / y+i to be sure

		if (Color= 0x000000) || (Color= 0xFFFFFF){
			
			ToolTip, Bug : Refresh the page and sleep, x, y
			if(refreshed = 0) || (refreshed > 4){
				ControlClick, x%RefreshButtonX% y%RefreshButtonY%, %Win_Title% 
				; Send {F5} / shortkeys don't work with flash objects
				refreshed ++
			}

			Sleep % rand(30000, 60000)


			ControlClick, x%x% y%y%, %Win_Title% 

			if(walk = 0){
				send {f} ; fish
			}else{
				send {b} ; ride the bike
			}
		}
}


;---------------------------------------------------------------------------------------------------------
 