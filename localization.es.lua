--------------------------------------------------
-- localization.es.lua (Spanish)
--------------------------------------------------
if GetLocale() == "esES" then

SOUNDTRACK_DANCE_EMOTES = {
    "Te pones a bailar.",
    "Bailas con ",
    " baila contigo.",
    " se pone a bailar." };
    
	
SOUNDTRACK_TITLE = "Soundtrack"


-- Main Frame
SOUNDTRACK_CLOSE = "Cerrar la ventana"
SOUNDTRACK_CLOSE_TIP = "Cierra la ventana principal de banda sonora. Si el tema estaba siendo visto de antemano que será detenido, y los eventos activos se reanudó."
	--"If a playlist was started, it will continue to play."   -- Currently not functioning.

SOUNDTRACK_TRACK_FILTER = "Filtro de la canción"
SOUNDTRACK_TRACK_FILTER_TIP = "Permite realizar un filtrado de las canciones. El filtro se compara con los nombres de las canciones de archivo, caminos, título, artista y nombre del álbum. Desactive la casilla para mostrar la lista completa de las canciones de nuevo."

SOUNDTRACK_EVENT_SETTINGS = "Configuración de eventos"
SOUNDTRACK_EVENT_SETTINGS_TIP = "Permite la edición de la configuración del evento seleccionado, tales como su nombre y el comportamiento de la reproducción."

SOUNDTRACK_ALL = "Todas las canciones"
SOUNDTRACK_ALL_TIP = "Agrega todas las canciones disponibles asignados a las canciones de este evento. Es útil si desea crear una lista de reproducción o cualquier otro evento que jugar en cualquiera de sus canciones."

SOUNDTRACK_CLEAR = "Borrar canciones"
SOUNDTRACK_CLEAR_TIP = "Removes all assigned tracks from this event's tracks."

SOUNDTRACK_DOWN = "Bajar canción"
SOUNDTRACK_DOWN_TIP = "Mueve hacia abajo la canción asignada, seleccione en la lista. Esto le permite establecer un orden específico de sus canciones de evento."

SOUNDTRACK_UP = "Subir canción"
SOUNDTRACK_UP_TIP = "Sube la canción asignada, seleccione en la lista. Esto le permite establecer un orden específico de sus canciones de evento."

SOUNDTRACK_NAME = "Nombre del evento"
SOUNDTRACK_NAME_TIP = "Este es el nombre del evento seleccionado. Puede cambiar el nombre de su evento. Pulse Intro para confirmar."

SOUNDTRACK_RANDOM = "Fortuito"
SOUNDTRACK_RANDOM_TIP = "Alterna entre reproducción continua y aleatoria para el evento seleccionado."

SOUNDTRACK_SOUND_EFFECT = "Efectos de sonido"
SOUNDTRACK_SOUND_EFFECT_TIP = "Reproduce la canción una vez, como un efecto de sonido, sin parar la música de otros. Esto es útil para un sonido de efectos a corto como música de la victoria o la búsqueda de sonido completo."

SOUNDTRACK_CONTINUOUS = "Continuo"
SOUNDTRACK_CONTINUOUS_TIP = "Reproduce las canciones de forma continua en un bucle. Si usted desactivar esta opción, la canción se reproduce una vez, y luego se quita de la pila."

SOUNDTRACK_REMOVE_TRACK = "Eliminar canción"


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
SOUNDTRACK_SWIMMING = "Estatus/Natación"
-- Added 1/17/2011
SOUNDTRACK_CINEMATIC = "Estatus/Cinematográfico"

SOUNDTRACK_GROUP_EVENTS = "Grupo y autónomos"
SOUNDTRACK_ACHIEVEMENT = "Grupo y autónomos/Achievement"
SOUNDTRACK_JOIN_PARTY = "Grupo y autónomos/Unirse a la fiesta"
SOUNDTRACK_JOIN_RAID = "Grupo y autónomos/Únete a Raid"
SOUNDTRACK_JUMP = "Grupo y autónomos/Saltar"
SOUNDTRACK_LEVEL_UP = "Grupo y autónomos/Elevar a mismo nivel"
SOUNDTRACK_LFG_COMPLETE = "Grupo y autónomos/LFG completa"
SOUNDTRACK_QUEST_COMPLETE = "Grupo y autónomos/Quest completa"

SOUNDTRACK_NPC_EVENTS = "NPC"
SOUNDTRACK_AUCTION_HOUSE = "NPC/Casa de Subastas"
SOUNDTRACK_BANK = "NPC/Banco"
SOUNDTRACK_MERCHANT = "NPC/Comerciante"
-- Added 1/17/2011
SOUNDTRACK_BARBERSHOP = "NPC/Barbería"
SOUNDTRACK_NPC_EMOTE = "NPC/Emoción"
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


SOUNDTRACK_DK = "Death Knight"
SOUNDTRACK_DK_CHANGE = "Death Knight/Change Presence"

SOUNDTRACK_DRUID = "Druida"
SOUNDTRACK_DRUID_CHANGE = "Druida/Change Form"
SOUNDTRACK_DRUID_AQUATIC = "Druida/Forma acuática"
SOUNDTRACK_DRUID_BEAR = "Druida/Forma de oso"
SOUNDTRACK_DRUID_CAT = "Druida/Forma felina"
SOUNDTRACK_DRUID_DASH = "Druida/Dash"
SOUNDTRACK_DRUID_FLIGHT = "Druida/Forma de Vuelo"
SOUNDTRACK_DRUID_MOONKIN = "Druida/Forma de Moonkin"
SOUNDTRACK_DRUID_PROWL = "Druida/Prowl"
SOUNDTRACK_DRUID_TRAVEL = "Druida/Forma de Viaje"
SOUNDTRACK_DRUID_TREE = "Druida/Forma de Tree of Life"

SOUNDTRACK_HUNTER = "Hunter"
SOUNDTRACK_HUNTER_CAMO = "Hunter/Camuflaje"

SOUNDTRACK_PALADIN = "Paladin"
SOUNDTRACK_PALADIN_CHANGE = "Paladin/Change Aura"

SOUNDTRACK_PRIEST = "Priest"
SOUNDTRACK_PRIEST_CHANGE = "Priest/Change Form"

SOUNDTRACK_ROGUE = "Rogue"
SOUNDTRACK_ROGUE_CHANGE = "Rogue/Change Stealth"
SOUNDTRACK_ROGUE_SPRINT = "Rogue/Sprint"
SOUNDTRACK_ROGUE_STEALTH = "Rogue/Stealth"

SOUNDTRACK_SHAMAN = "Shaman"
SOUNDTRACK_SHAMAN_CHANGE = "Shaman/Change Form"
SOUNDTRACK_SHAMAN_GHOST_WOLF = "Shaman/Ghost Wolf"

SOUNDTRACK_WARRIOR = "Warrior"
SOUNDTRACK_WARRIOR_CHANGE = "Warrior/Change Stance"

-- Old misc events
SOUNDTRACK_DEATH_OLD = "Death"
SOUNDTRACK_FLIGHT_OLD = "Trayectoria de vuelo"
SOUNDTRACK_GHOST_OLD = "Ghost"
SOUNDTRACK_MOUNT_FLYING_OLD = "Montura voladora"
SOUNDTRACK_MOUNT_GROUND_OLD = "Montura suelo"
SOUNDTRACK_STEALTHED_OLD = "Sigilo"
SOUNDTRACK_SWIMMING_OLD = "Natación"

SOUNDTRACK_ACHIEVEMENT_OLD = "Achievement"
SOUNDTRACK_JOIN_PARTY_OLD = "Unirse a la fiesta"
SOUNDTRACK_JOIN_RAID_OLD = "Únete a Raid"
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
SOUNDTRACK_PREVIOUS = "Previous Track"
SOUNDTRACK_PREVIOUS_TIP = "Skips to the previous track in this event."

SOUNDTRACK_PLAY = "Play"
SOUNDTRACK_PLAY_TIP = "Click to resume this event."

SOUNDTRACK_PAUSE = "Pause"
SOUNDTRACK_PAUSE_TIP = "Click to pause this event."

SOUNDTRACK_NEXT = "Next Track"
SOUNDTRACK_NEXT_TIP = "Skips to the next track in this event."

SOUNDTRACK_STOP = "Stop"
SOUNDTRACK_STOP_TIP = "Stops the event."

SOUNDTRACK_INFO = "Info"
SOUNDTRACK_INFO_TIP = "Gives information on the currently playing track."

SOUNDTRACK_REPORT = "Report"
SOUNDTRACK_REPORT_TIP = "Report currently playing track to say, party/raid, or guild."

-- Options Tab
SOUNDTRACK_SHOW_MINIMAP_BUTTON = "Show Minimap Button"
SOUNDTRACK_SHOW_MINIMAP_BUTTON_TIP = "Displays the Soundtrack icon on the minimap. The icon can be repositioned by dragging it around the minimap. If you turn off this button, you can open Soundtrack's main window with a keybinding or with the /soundtrack command."

SOUNDTRACK_SHOW_PLAYBACK_CONTROLS = "Playback Controls"
SOUNDTRACK_SHOW_PLAYBACK_CONTROLS_TIP = "Displays a mini toolbar with a previous, pause, and next button to control the playback. The controls can be repositioned by dragging the name area."

SOUNDTRACK_LOCK_PLAYBACK_CONTROLS = "Lock Playback Controls"
SOUNDTRACK_LOCK_PLAYBACK_CONTROLS_TIP = "Makes the Playback Controls unmovable."

SOUNDTRACK_SHOW_TRACK_INFO = "Show Track Information"
SOUNDTRACK_SHOW_TRACK_INFO_TIP = "When track changes, the track's title, album and artist are shortly displayed on the screen. The track information frame can be repositioned by dragging it when it appears."

SOUNDTRACK_SHOW_DEFAULT_MUSIC = "Show Default Music"
SOUNDTRACK_SHOW_DEFAULT_MUSIC_TIP = "Adds all the available music tracks included with the game to your music library."

SOUNDTRACK_LOCK_NOW_PLAYING = "Lock Track Info. Frame"
SOUNDTRACK_LOCK_NOW_PLAYING_TIP = "Locks the track information frame so it cannot be moved or clicked."

SOUNDTRACK_SHOW_DEBUG = "Output Debug Information"
SOUNDTRACK_SHOW_DEBUG_TIP = "Outputs verbose debug information to the chat frame. Output is sent to default chat frame or the frame named 'Soundtrack' if available."

SOUNDTRACK_SHOW_EVENT_STACK = "Event Stack"
SOUNDTRACK_SHOW_EVENT_STACK_TIP = "Displays the currently active events in the stack, below the minimap (useful for debugging)."

SOUNDTRACK_AUTO_ADD_ZONES = "Automatically Add Zones"
SOUNDTRACK_AUTO_ADD_ZONES_TIP = "Adds new zones to the list of zone events as you travel. Zones are added hierarchically at all levels (e.g. continents, major areas, cities, towns, inns, etc."

SOUNDTRACK_ESCALATE_BATTLE = "Escalate Battle Music"
SOUNDTRACK_ESCALATE_BATTLE_TIP = "If during a battle a stronger enemy is detected, allows the music to switch to the higher battle music."

SOUNDTRACK_BATTLE_CD = "Battle Cooldown"
SOUNDTRACK_BATTLE_CD_TIP = "The time it takes for battle music to stop when disengaged from battle."

SOUNDTRACK_LOOP_MUSIC = "Loop Music"
SOUNDTRACK_LOOP_MUSIC_TIP = "Enable to continuously play background music. This is the same setting exposed in the default Sound options."

SOUNDTRACK_MAX_SILENCE = "Maximum Silence"
SOUNDTRACK_MAX_SILENCE_TIP = "The maximum amount of silence to insert between tracks for zone music. Increase this value if you wish the music would take a break once in a while."

SOUNDTRACK_PROJECT = "Project"
SOUNDTRACK_PROJECT_TIP = "Soundtrack Project to load or remove from Soundtrack"

SOUNDTRACK_ENABLE_MUSIC = "Enable Music"
SOUNDTRACK_ENABLE_MUSIC_TIP = "Master toggle to turn off all music. Use this to temporarily disable all of Soundtrack's music."

SOUNDTRACK_ENABLE_ZONE_MUSIC = "Enable Zone Music"
SOUNDTRACK_ENABLE_ZONE_MUSIC_TIP = "Enable zone music. Use this to temporarily stop all zone music from playing."

SOUNDTRACK_ENABLE_BATTLE_MUSIC = "Enable Battle Music"
SOUNDTRACK_ENABLE_BATTLE_MUSIC_TIP = "Enable battle music. Use this to temporarily stop all battle music."

SOUNDTRACK_ENABLE_MISC_MUSIC = "Enable Misc Music"
SOUNDTRACK_ENABLE_MISC_MUSIC_TIP = "Enable misc music. Use this to temporarily turn off all misc music."

SOUNDTRACK_ENABLE_CUSTOM_MUSIC = "Enable Custom Music"
SOUNDTRACK_ENABLE_CUSTOM_MUSIC_TIP = "Enable custom music. Use this to temporarily turn off all custom music."


-- Other
SOUNDTRACK_NO_TRACKS_PLAYING = "No tracks playing"
SOUNDTRACK_NO_EVENT_PLAYING = "No event playing"
SOUNDTRACK_NOW_PLAYING = "Now playing"
SOUNDTRACK_MINIMAP_BUTTON_HIDDEN = "The minimap button was hidden. You can access Soundtrack's UI by using the /soundtrack command."

SOUNDTRACK_REMOVE_QUESTION =  "Do you want to remove this?"
SOUNDTRACK_PURGE_EVENTS_QUESTION = "MyTracks.lua changed.\n\nPurge obsolete tracks?"
SOUNDTRACK_GEN_LIBRARY = "Exit the game, run GenerateMyLibrary.py, and reenter game to create MyTracks.lua for Soundtrack to work properly."
SOUNDTRACK_NO_MYTRACKS = "MyTracks.lua not found.\n\nRun Soundtrack without MyTracks.lua?"
SOUNDTRACK_ERROR_LOADING = "Cannot load MyTracks.lua. You probably forgot to run GenerateMyLibrary.py. Read the setup instructions for more details."


end