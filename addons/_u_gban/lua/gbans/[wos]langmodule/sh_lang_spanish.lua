--[[-------------------------------------------------------------------
	Global Ban! (gBan):
		A simple solution to banning.
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
					
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
	
	Web Developer: BearWoolley
	Contact: N/A
	Purchased at www.scriptfodder.com
	
	File Information: Spanish translations courtesy of the wonderful KarinaSan AKA TheSands 
----------------------------------------]]--

local LANGUAGE = {}

LANGUAGE.Name = "Spanish"  -- The name of the language 

--Default Ban Message Translation
LANGUAGE.BanMessage = [[
	Perdon, parece ser que se te ha prohibido jugar aqui: 
	Estas prohibido por: {admin}
	Razon: {reason}
	Fecha Prohibido: {date_banned}
	Fecha prohibicion es removida: {unban_date}
]]

LANGUAGE.TTTBanMessage = "Prohibido por tener el Karma muy bajo."

-- ULX/Command Translations
LANGUAGE.ULXBanTime = "Tiempo en minutos ( 0 = permanent )"
LANGUAGE.ULXBanReason = "Razon por ser prohibido"
LANGUAGE.ULXBan = "Prohibe un jugador globalmente."
LANGUAGE.ULXBanID = "Prohibe un STeamID globalmente."
LANGUAGE.ULXUnban = "Remueve la prohibicion a SteamID"
LANGUAGE.ULXLookup = "Busca a un SteamID"

-- VGUI Tab Text
LANGUAGE.CurBans = "PROHIBICIONES ACTIVAS" 
LANGUAGE.CurHistory = "HISTORIAL DE PROHIBICIONES"
LANGUAGE.Controls = "PANEL DE CONTROL"
LANGUAGE.Close = "CERRAR"

-- VGUI Control Dock Text
LANGUAGE.LoadingBans = "CARGANDO PROHIBICIONES.."
LANGUAGE.LoadingHistory = "CARGANDO HISTORIAL.."
LANGUAGE.SelectBans = "SELECTIONE UNA ENTRADA PARA OPCIONES "
LANGUAGE.Search = "BUSCAR.."
LANGUAGE.SelectFunc = "SELECCIONE UNA ACTION  PARA EJECUTAR"

-- VGUI Button Text
LANGUAGE.BanBySteamID = "PROHIBIDO POR STEAMID"
LANGUAGE.UnBanSteamID = "REMOVER PROHIBICION A STEAMID"
LANGUAGE.BanPlayer = "PROHIBIR JUGADOR"
LANGUAGE.UnbanPlayer = "REMOVER PROHIBICION A JUGADOR"
LANGUAGE.Refresh = "REFRESCAR LISTA"
LANGUAGE.ChangeLanguage = "CAMBIAR LENGUAJE"

-- VGUI Table Categories
LANGUAGE.CatName = "Nombre"
LANGUAGE.CatPriors = "Prohibiciones Anteriores"
LANGUAGE.CatLastBan = "Ultima Fecha Prohibido"
LANGUAGE.CatAdminBan = "Prohibido Por"
LANGUAGE.CatDateBanned = "Fecha Prohibido"
LANGUAGE.CatDateUnbanned = "Fecha Prohibicion Es Removida"
LANGUAGE.CatReason = "Razon"
LANGUAGE.CatAdminUnban = "Removicion de Prohibicion Por"

-- VGUI Help Texts
LANGUAGE.STIDOR64 = "SteamID O SteamID64"

-- In-Game Translations
LANGUAGE.MenuCooldown = "Debes esperar antes de usar esta orden otra vez!"
LANGUAGE.NonExist = "Jugador no existe!"
LANGUAGE.InvalidID = "Por favor ingresa un SteamID valido!"
LANGUAGE.AlreadyBanned = "Jugador ya esta prohibido!"
LANGUAGE.NotBanned = "Jugador no esta prohibido!"
LANGUAGE.BanBuffer = "Obteninedo nombre de jugador.."
LANGUAGE.NoAccess = "No puedes accesar esta orden."
LANGUAGE.TargetHigh = "Jugador tiene privilegios mayores a los tuyos!"

-- Console Translations
LANGUAGE.ConsoleMessage = [[Jugador "{name}" ( {steamid} ) intento a connectar fallo, jugador prohibido.]]
LANGUAGE.FamilyConsoleMessage = [[Jugador "{name}" ( {steamid} ) intento a connectar fallo, famila compartiendo con "{name2}" ( {steamid2} ) el cual esta prohibido.]]
LANGUAGE.APIKey = "Error! verifique que su clave API esta colocada en la carpeta de configuration!"

-- Log Translations
LANGUAGE.LogUnban = [[Jugador {name} removio prohibicion a {steamid}]]
LANGUAGE.LogBan = [[Jugador {name} prohibio {steamid} por {time} minutos ( {reason} )]]

-- MISC Words
LANGUAGE.Player = "Jugador"
LANGUAGE.HasBanned = "ha prohibido"
LANGUAGE.HasUnBanned = " ha removio prohibicion"
LANGUAGE.Duration = "Duracion"
LANGUAGE.Reason = "Razon"
LANGUAGE.Permanent = "Indefinitivamente"
LANGUAGE.Select = "SELECCIONAR"
LANGUAGE.Never = "Nunca"

gBan:RegisterLanguage( LANGUAGE )