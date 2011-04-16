--------------------------------------------------
-- localization.es.lua (Spanish)
--------------------------------------------------
if GetLocale() == "esES" or GetLocale() == "esMX" then

SOUNDTRACK_DANCE_EMOTES = {
    "Te pones a bailar.",
    "Bailas con ",
    " baila contigo.",
    " se pone a bailar." };
    
	
SOUNDTRACK_TITLE = "Soundtrack"


-- Main Frame
SOUNDTRACK_CLOSE = "Cerrar la ventana"
SOUNDTRACK_CLOSE_TIP = "Cierra la ventana principal de banda sonora. Si el tema estaba siendo visto de antemano que ser� detenido, y los eventos activos se reanud�."
	--"If a playlist was started, it will continue to play."   -- Currently not functioning.

SOUNDTRACK_TRACK_FILTER = "Filtro de la canci�n"
SOUNDTRACK_TRACK_FILTER_TIP = "Permite realizar un filtrado de las canciones. El filtro se compara con los nombres de las canciones de archivo, caminos, t�tulo, artista y nombre del �lbum. Desactive la casilla para mostrar la lista completa de las canciones de nuevo."

SOUNDTRACK_EVENT_SETTINGS = "Configuraci�n de eventos"
SOUNDTRACK_EVENT_SETTINGS_TIP = "Permite la edici�n de la configuraci�n del evento seleccionado, tales como su nombre y el comportamiento de la reproducci�n."

SOUNDTRACK_ALL = "Todas las canciones"
SOUNDTRACK_ALL_TIP = "Agrega todas las canciones disponibles asignados a las canciones de este evento. Es �til si desea crear una lista de reproducci�n o cualquier otro evento que jugar en cualquiera de sus canciones."

SOUNDTRACK_CLEAR = "Borrar canciones"
SOUNDTRACK_CLEAR_TIP = "Removes all assigned tracks from this event's tracks."

SOUNDTRACK_DOWN = "Bajar canci�n"
SOUNDTRACK_DOWN_TIP = "Mueve hacia abajo la canci�n asignada, seleccione en la lista. Esto le permite establecer un orden espec�fico de sus canciones de evento."

SOUNDTRACK_UP = "Subir canci�n"
SOUNDTRACK_UP_TIP = "Sube la canci�n asignada, seleccione en la lista. Esto le permite establecer un orden espec�fico de sus canciones de evento."

SOUNDTRACK_NAME = "Nombre del evento"
SOUNDTRACK_NAME_TIP = "Este es el nombre del evento seleccionado. Puede cambiar el nombre de su evento. Pulse Intro para confirmar."

SOUNDTRACK_RANDOM = "Fortuito"
SOUNDTRACK_RANDOM_TIP = "Alterna entre reproducci�n continua y aleatoria para el evento seleccionado."

SOUNDTRACK_SOUND_EFFECT = "Efectos de sonido"
SOUNDTRACK_SOUND_EFFECT_TIP = "Reproduce la canci�n una vez, como un efecto de sonido, sin parar la m�sica de otros. Esto es �til para un sonido de efectos a corto como m�sica de la victoria o la b�squeda de sonido completo."

SOUNDTRACK_CONTINUOUS = "Continuo"
SOUNDTRACK_CONTINUOUS_TIP = "Reproduce las canciones de forma continua en un bucle. Si usted desactivar esta opci�n, la canci�n se reproduce una vez, y luego se quita de la pila."

SOUNDTRACK_REMOVE_TRACK = "Eliminar canci�n"


-- Button Names
SOUNDTRACK_ADD_BUTTON = "Sumar"
SOUNDTRACK_REMOVE_BUTTON = "Alejar"
SOUNDTRACK_EDIT_BUTTON = "Editar"
SOUNDTRACK_RENAME_BUTTON = "Llamar"


-- Minimap
SOUNDTRACK_MINIMAP = "Assign your own music to various events in the game or play your own playlists. You can drag this icon around the minimap."


-- Battle Tab
SOUNDTRACK_UNKNOWN_BATTLE = "Batalla Desconocido"
SOUNDTRACK_NORMAL_MOB = "Mob Normal"
SOUNDTRACK_ELITE_MOB = "Mob Elite"
-- Added 1/22/2010
SOUNDTRACK_CRITTER = "Critter"

SOUNDTRACK_RARE = "Rare"
SOUNDTRACK_BOSS_BATTLE = "Batalla Repujado"
SOUNDTRACK_WORLD_BOSS_BATTLE = "Batalla Repujado del Mundo"
SOUNDTRACK_PVP_BATTLE = "Batalla JcJ"

SOUNDTRACK_REMOVE_BATTLE = "Remove Battle Event"
SOUNDTRACK_REMOVE_BATTLE_TIP = "Removes the selected battle event."


-- Bosses Tab
SOUNDTRACK_ADD_TARGET = "Add Target"
SOUNDTRACK_ADD_TARGET_TIP = "Adds the currently targeted mob to the list, or enter the name of a mob to add to the list."
SOUNDTRACK_ADD_BOSS_TIP = "Add named mob:"

SOUNDTRACK_REMOVE_TARGET = "Remove Target"
SOUNDTRACK_REMOVE_TARGET_TIP = "Removes the selected mob from the list."


-- Zones Tab
SOUNDTRACK_ADD_ZONE = "Add Zone"
SOUNDTRACK_ADD_ZONE_TIP = "Adds your current locations to the zone list so that you can assign tracks to them. This can be done automatically with the 'Automatically Add New Zones' option."

SOUNDTRACK_REMOVE_ZONE = "Remove Zone"
SOUNDTRACK_REMOVE_ZONE_TIP = "Removes the selected zone."


-- Dances Tab


-- Misc Tab
SOUNDTRACK_DUEL_REQUESTED = "Duel requerido"

SOUNDTRACK_STATUS_EVENTS = "Estatus"
SOUNDTRACK_DEATH = "Estatus/Muerte"
SOUNDTRACK_FLIGHT = "Estatus/Trayectoria de vuelo"
SOUNDTRACK_GHOST = "Estatus/Fantasma"
SOUNDTRACK_MOUNT_FLYING = "Estatus/Montura voladora"
SOUNDTRACK_MOUNT_GROUND = "Estatus/Montura suelo"
SOUNDTRACK_STEALTHED = "Estatus/Sigilo"
SOUNDTRACK_SWIMMING = "Estatus/Nataci�n"
-- Added 1/17/2011
SOUNDTRACK_CINEMATIC = "Estatus/Cinematogr�fico"

SOUNDTRACK_GROUP_EVENTS = "Grupo y aut�nomos"
SOUNDTRACK_ACHIEVEMENT = "Grupo y aut�nomos/Achievement"
SOUNDTRACK_JOIN_PARTY = "Grupo y aut�nomos/Unirse a la fiesta"
SOUNDTRACK_JOIN_RAID = "Grupo y aut�nomos/�nete a Raid"
SOUNDTRACK_JUMP = "Grupo y aut�nomos/Saltar"
SOUNDTRACK_LEVEL_UP = "Grupo y aut�nomos/Elevar a mismo nivel"
SOUNDTRACK_LFG_COMPLETE = "Grupo y aut�nomos/LFG completa"
SOUNDTRACK_QUEST_COMPLETE = "Grupo y aut�nomos/Quest completa"

SOUNDTRACK_NPC_EVENTS = "NPC"
SOUNDTRACK_AUCTION_HOUSE = "NPC/Casa de Subastas"
SOUNDTRACK_BANK = "NPC/Banco"
SOUNDTRACK_MERCHANT = "NPC/Comerciante"
-- Added 1/17/2011
SOUNDTRACK_BARBERSHOP = "NPC/Barber�a"
SOUNDTRACK_NPC_EMOTE = "NPC/Emoci�n"
SOUNDTRACK_NPC_SAY = "NPC/Decir"
SOUNDTRACK_NPC_WHISPER = "NPC/Susurrar"
SOUNDTRACK_NPC_YELL = "NPC/Gritar"

SOUNDTRACK_COMBAT_EVENTS = "Combate"
SOUNDTRACK_RANGE_CRIT = "Combate/Range Crit"
SOUNDTRACK_RANGE_HIT = "Combate/Range"
SOUNDTRACK_HEAL_CRIT = "Combate/Spell Heal Crit"
SOUNDTRACK_HEAL_HIT = "Combate/Spell Heal"
SOUNDTRACK_HOT_CRIT = "Combate/Spell HoT Crit"
SOUNDTRACK_HOT_HIT = "Combate/Spell HoT"
SOUNDTRACK_SPELL_CRIT = "Combate/Spell Damage Crit"
SOUNDTRACK_SPELL_HIT = "Combate/Spell Damage"
SOUNDTRACK_DOT_CRIT = "Combate/Spell DoT Crit"
SOUNDTRACK_DOT_HIT = "Combate/Spell DoT"
SOUNDTRACK_SWING_CRIT = "Combate/Swing Crit"
SOUNDTRACK_SWING_HIT = "Combate/Swing"
SOUNDTRACK_VICTORY = "Combate/Victoria"


SOUNDTRACK_DK = "Caballero de la Muerte"
SOUNDTRACK_DK_CHANGE = "Caballero de la Muerte/Change Presence"

SOUNDTRACK_DRUID = "Druida"
SOUNDTRACK_DRUID_CHANGE = "Druida/Change Form"
SOUNDTRACK_DRUID_AQUATIC = "Druida/Forma acu�tica"
SOUNDTRACK_DRUID_BEAR = "Druida/Forma de oso"
SOUNDTRACK_DRUID_CAT = "Druida/Forma felina"
SOUNDTRACK_DRUID_DASH = "Druida/Dash"
SOUNDTRACK_DRUID_FLIGHT = "Druida/Forma de Vuelo"
SOUNDTRACK_DRUID_MOONKIN = "Druida/Forma de Moonkin"
SOUNDTRACK_DRUID_PROWL = "Druida/Prowl"
SOUNDTRACK_DRUID_TRAVEL = "Druida/Forma de Viaje"
SOUNDTRACK_DRUID_TREE = "Druida/Forma de Tree of Life"

SOUNDTRACK_HUNTER = "Cazador"
SOUNDTRACK_HUNTER_CAMO = "Cazador/Camuflaje"

SOUNDTRACK_MAGE = "Mago"

SOUNDTRACK_PALADIN = "Paladin"
SOUNDTRACK_PALADIN_CHANGE = "Paladin/Change Aura"

SOUNDTRACK_PRIEST = "Sacerdotisa"
SOUNDTRACK_PRIEST_CHANGE = "Sacerdotisa/Change Form"

SOUNDTRACK_ROGUE = "Picaro"
SOUNDTRACK_ROGUE_CHANGE = "Picaro/Change Stealth"
SOUNDTRACK_ROGUE_SPRINT = "Picaro/Sprint"
SOUNDTRACK_ROGUE_STEALTH = "Picaro/Stealth"

SOUNDTRACK_SHAMAN = "Chaman"
SOUNDTRACK_SHAMAN_CHANGE = "Chaman/Change Form"
SOUNDTRACK_SHAMAN_GHOST_WOLF = "Chaman/Ghost Wolf"

SOUNDTRACK_WARLOCK = "Bruja"

SOUNDTRACK_WARRIOR = "Guerrero"
SOUNDTRACK_WARRIOR_CHANGE = "Guerrero/Change Stance"

-- Old misc events
SOUNDTRACK_DEATH_OLD = "Death"
SOUNDTRACK_FLIGHT_OLD = "Trayectoria de vuelo"
SOUNDTRACK_GHOST_OLD = "Ghost"
SOUNDTRACK_MOUNT_FLYING_OLD = "Montura voladora"
SOUNDTRACK_MOUNT_GROUND_OLD = "Montura suelo"
SOUNDTRACK_STEALTHED_OLD = "Sigilo"
SOUNDTRACK_SWIMMING_OLD = "Nataci�n"

SOUNDTRACK_ACHIEVEMENT_OLD = "Achievement"
SOUNDTRACK_JOIN_PARTY_OLD = "Unirse a la fiesta"
SOUNDTRACK_JOIN_RAID_OLD = "�nete a Raid"
SOUNDTRACK_JUMP_OLD = "Jump"
SOUNDTRACK_LEVEL_UP_OLD = "Elevar a mismo nivel"
SOUNDTRACK_LFG_COMPLETE_OLD = "LFG Complete"
SOUNDTRACK_QUEST_COMPLETE_OLD = "Quest completa"

SOUNDTRACK_AUCTION_HOUSE_OLD = "Casa de Subastas"
SOUNDTRACK_BANK_OLD = "Banco"
SOUNDTRACK_MERCHANT_OLD = "Comerciante"

SOUNDTRACK_RANGE_CRIT_OLD = "Range Crit"
SOUNDTRACK_RANGE_HIT_OLD = "Range"
SOUNDTRACK_HEAL_CRIT_OLD = "Spell Heal Crit"
SOUNDTRACK_HEAL_HIT_OLD = "Spell Heal"
SOUNDTRACK_HOT_CRIT_OLD = "Spell HoT Crit"
SOUNDTRACK_HOT_HIT_OLD = "Spell HoT"
SOUNDTRACK_SPELL_CRIT_OLD = "Spell Damage Crit"
SOUNDTRACK_SPELL_HIT_OLD = "Spell Damage"
SOUNDTRACK_DOT_CRIT_OLD = "Spell DoT Crit"
SOUNDTRACK_DOT_HIT_OLD = "Spell DoT"
SOUNDTRACK_SWING_CRIT_OLD = "Swing Crit"
SOUNDTRACK_SWING_HIT_OLD = "Swing"
SOUNDTRACK_VICTORY_OLD = "Victory"


SOUNDTRACK_REMOVE_MISC = "Remove Misc. Event"
SOUNDTRACK_REMOVE_MISC_TIP = "Removes the selected misc. event."


-- Custom Event Tab
SOUNDTRACK_ADD_CUSTOM = "Add Custom Event"
SOUNDTRACK_ADD_CUSTOM_TIP = "Creates a new custom event. Custom events are events that you can define yourself through a variety of methods including scripting."

SOUNDTRACK_EDIT_CUSTOM = "Edit Custom Event"
SOUNDTRACK_EDIT_CUSTOM_TIP = "Switches to the custom event editing interface so you can adjust the selected custom event."

SOUNDTRACK_REMOVE_CUSTOM = "Remove Custom Event"
SOUNDTRACK_REMOVE_CUSTOM_TIP = "Removes the selected custom event."

SOUNDTRACK_RANDOM = "Shuffle"
SOUNDTRACK_SOUND_EFFECT = "Sound Effect"
SOUNDTRACK_CUSTOM_CONTINUOUS = "Continuous"
SOUNDTRACK_CUSTOM_CONTINUOUS_TIP = "Determines if this event will loop or play once. When an event plays continuously, it can be stopped by its own script, or through another event replacing it."

SOUNDTRACK_EVENT_TYPE = "Event Type"
SOUNDTRACK_EVENT_TYPE_TIP = "The type of event affects how the custom event is edited."

SOUNDTRACK_ENTER_CUSTOM_NAME = "Enter Custom Event Name:"



-- Playlists Tab
SOUNDTRACK_ADD_PLAYLIST = "Add Playlist"
SOUNDTRACK_ADD_PLAYLIST_TIP = "Adds a new playlist. Playlists override all other events, so they never get interrupted by other events."

SOUNDTRACK_REMOVE_PLAYLIST = "Remove Playlist"
SOUNDTRACK_REMOVE_PLAYLIST_TIP = "Removes the selected playlist."

SOUNDTRACK_RENAME_PLAYLIST = "Rename Playlist"
SOUNDTRACK_RENAME_PLAYLIST_TIP = "Rename the selected playlist."

SOUNDTRACK_ENTER_PLAYLIST_NAME = "Enter Playlist Name:"


-- Options Tab


-- Playback Controls
SOUNDTRACK_PREVIOUS = "Canci�n anterior"
SOUNDTRACK_PREVIOUS_TIP = "Skips to the previous track in this event."

SOUNDTRACK_PLAY = "Jugar"
SOUNDTRACK_PLAY_TIP = "Click to resume this event."

SOUNDTRACK_PAUSE = "Poner en pausa"
SOUNDTRACK_PAUSE_TIP = "Click to pause this event."

SOUNDTRACK_NEXT = "�ltima  canci�n"
SOUNDTRACK_NEXT_TIP = "Skips to the next track in this event."

SOUNDTRACK_STOP = "Detener"
SOUNDTRACK_STOP_TIP = "Stops the event."

SOUNDTRACK_INFO = "Informaci�n"
SOUNDTRACK_INFO_TIP = "Gives information on the currently playing track."

SOUNDTRACK_REPORT = "Informar "
SOUNDTRACK_REPORT_TIP = "Report currently playing track to say, party/raid, or guild."

-- Options Tab
SOUNDTRACK_SHOW_MINIMAP_BUTTON = "Mostrar minimapa bot�n "
SOUNDTRACK_SHOW_MINIMAP_BUTTON_TIP = "Muestra el icono de la banda sonora en el minimapa. El icono puede cambiar de posici�n arrastr�ndolo todo el minimapa."

SOUNDTRACK_SHOW_PLAYBACK_CONTROLS = "Controles de reproducci�n"
SOUNDTRACK_SHOW_PLAYBACK_CONTROLS_TIP = "Muestra una barra de herramientas mini con una pausa anterior, y situado junto al control de la reproducci�n."

SOUNDTRACK_LOCK_PLAYBACK_CONTROLS = "Bloquear los controles de reproducci�n"
SOUNDTRACK_LOCK_PLAYBACK_CONTROLS_TIP = "Hace que los controles de reproducci�n inamovible."

SOUNDTRACK_SHOW_TRACK_INFO = "Mostrar informaci�n de la canci�n"
SOUNDTRACK_SHOW_TRACK_INFO_TIP = "Cuando los cambios de pista, la pista de t�tulo, �lbum y artista en breve aparecer� en la pantalla. " 
	.."El marco de seguimiento de la informaci�n puede cambiar de posici�n, arrastre cuando aparezca."

SOUNDTRACK_SHOW_DEFAULT_MUSIC = "Mostrar m�sica predeterminada"
SOUNDTRACK_SHOW_DEFAULT_MUSIC_TIP = "Agrega todas las pistas de m�sica disponibles se incluye con el juego en tu colecci�n de m�sica."

SOUNDTRACK_LOCK_NOW_PLAYING = "Bloquear Track Info. Frame"
SOUNDTRACK_LOCK_NOW_PLAYING_TIP = "Bloquea el marco de informaci�n de la pista por lo que no se pueden mover o hacer clic."

SOUNDTRACK_SHOW_DEBUG = "informaci�n de sacar error de la computadora"
SOUNDTRACK_SHOW_DEBUG_TIP = "Salidas detallada informaci�n de depuraci�n en el marco del chat. Salida se env�a a marco de chat o el marco nombrado 'Soundtrack' si est� disponible."

SOUNDTRACK_SHOW_EVENT_STACK = "Pila de eventos"
SOUNDTRACK_SHOW_EVENT_STACK_TIP = "Pantalla pila de eventos (conveniente para sacar error de la computadora)."

SOUNDTRACK_AUTO_ADD_ZONES = "A�adir autom�ticamente las zonas"
SOUNDTRACK_AUTO_ADD_ZONES_TIP = "A�adir nuevas zonas a la lista de eventos de zona mientras viajas."
							
SOUNDTRACK_ESCALATE_BATTLE = "Escalar la m�sica de batalla"
SOUNDTRACK_ESCALATE_BATTLE_TIP = "Si durante una batalla se detecta a un enemigo m�s fuerte, permite que la m�sica para cambiar a la m�sica de batalla m�s alto."

SOUNDTRACK_BATTLE_CD = "Batalla reutilizacion"
SOUNDTRACK_BATTLE_CD_TIP = "El tiempo que toma para la m�sica de batalla para detener cuando se separan de la batalla."

SOUNDTRACK_LOOP_MUSIC = "M�sica continua"
SOUNDTRACK_LOOP_MUSIC_TIP = "Activar reproducci�n de m�sica continua"

SOUNDTRACK_MAX_SILENCE = "M�ximo Silencio"
SOUNDTRACK_MAX_SILENCE_TIP = "El importe m�ximo de silencio para insertar entre las canciones o la m�sica de zona."

SOUNDTRACK_PROJECT = "Proyecto"
SOUNDTRACK_PROJECT_TIP = "Proyecto de Soundtrack por instalar o deinstalar."

SOUNDTRACK_PROJECT_LOAD = "Instalar proyecto"
SOUNDTRACK_PROJECT_LOAD_TIP = "Instalar configuraci�n de evento-canci�n de proyecto."

SOUNDTRACK_PROJECT_REMOVE = "Desinstalar proyecto"
SOUNDTRACK_PROJECT_REMOVE_TIP = "Desinstalar configuraci�n de evento-canci�n de proyecto."

SOUNDTRACK_ENABLE_MUSIC = "Activar toda la m�sica"
SOUNDTRACK_ENABLE_MUSIC_TIP = "Activar o desactivar toda la m�sica de Soundtrack."

SOUNDTRACK_ENABLE_ZONE_MUSIC = "Activar la m�sica de Zone"
SOUNDTRACK_ENABLE_ZONE_MUSIC_TIP = "Activar o desactivar la m�sica de Zone."

SOUNDTRACK_ENABLE_BATTLE_MUSIC = "Activar la m�sica de Battle"
SOUNDTRACK_ENABLE_BATTLE_MUSIC_TIP = "Activar o desactivar la m�sica de Battle."

SOUNDTRACK_ENABLE_MISC_MUSIC = "Activar la m�sica de Misc"
SOUNDTRACK_ENABLE_MISC_MUSIC_TIP = "Activar o desactivar la m�sica de Misc."

SOUNDTRACK_ENABLE_CUSTOM_MUSIC = "Activar la m�sica de Custom"
SOUNDTRACK_ENABLE_CUSTOM_MUSIC_TIP = "Activar o desactivar la m�sica de Custom."


-- Other
SOUNDTRACK_NO_TRACKS_PLAYING = "No hay canci�n que suena"
SOUNDTRACK_NO_EVENT_PLAYING = "No hay juego evento"
SOUNDTRACK_NOW_PLAYING = "Jugando ahora"
SOUNDTRACK_MINIMAP_BUTTON_HIDDEN = "El bot�n del minimapa se ocultaba. Puede acceder a la interfaz de usuario Soundtrack con /soundtrack o /st."

SOUNDTRACK_REMOVE_QUESTION =  "�Quieres eliminar este?"
SOUNDTRACK_PURGE_EVENTS_QUESTION = "MyTracks.lua cambiado.\n\n�Eliminar pistas obsoleto?"
SOUNDTRACK_GEN_LIBRARY = "Salir del juego, ejecutar GenerateMyLibrary.py, y volver a entrar al juego de crear MyTracks.lua de Soundtrack para funcionar correctamente"
SOUNDTRACK_NO_MYTRACKS = "MyTracks.lua no encontrado.\n\n�Ejecutar Soundtrack sin MyTracks.lua?"
SOUNDTRACK_ERROR_LOADING = "No se puede instalar MyTracks.lua. Probablemente se olvid� de ejecutar GenerateMyLibrary.py. Lea las instrucciones de configuraci�n para m�s detalles."


end