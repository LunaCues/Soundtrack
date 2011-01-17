--------------------------------------------------
-- localization.fr.lua (French)
--------------------------------------------------
if GetLocale() == "frFR" then

SOUNDTRACK_DANCE_EMOTES = {};


SOUNDTRACK_TITLE = "Soundtrack"


-- Main Frame
SOUNDTRACK_CLOSE = "Close Window"
SOUNDTRACK_CLOSE_TIP = "Closes Soundtrack's main window. If a track was being previewed it will be stopped, and the active events are resumed."
	--"If a playlist was started, it will continue to play."   -- Currently not functioning.

SOUNDTRACK_TRACK_FILTER = "Track Filter"
SOUNDTRACK_TRACK_FILTER_TIP = "Allows filtering of the tracks. The filter is compared against the track file names, paths, title, artist and album name. Clear the box to show the full list of tracks again."

SOUNDTRACK_EVENT_SETTINGS = "Event Settings"
SOUNDTRACK_EVENT_SETTINGS_TIP = "Allows editing of the selected event's settings such as its name, and playback behavior."

SOUNDTRACK_ALL = "All Tracks"
SOUNDTRACK_ALL_TIP = "Adds all available tracks to this event's assigned tracks. Useful if you want to create a playlist or other event which will play any of your songs."

SOUNDTRACK_CLEAR = "Clear Tracks"
SOUNDTRACK_CLEAR_TIP = "Removes all assigned tracks from this event's tracks."

SOUNDTRACK_DOWN = "Move Track Down"
SOUNDTRACK_DOWN_TIP = "Moves the selected assigned track down in the list. This allows you to set a specific order to your event's tracks."

SOUNDTRACK_UP = "Move Track Up"
SOUNDTRACK_UP_TIP = "Moves the selected assigned track up in the list. This allows you to set a specific order to your event's tracks."

SOUNDTRACK_NAME = "Event Name"
SOUNDTRACK_NAME_TIP = "This is the name of the selected event. You can rename your event. Press Enter to confirm."

SOUNDTRACK_RANDOM = "Shuffle"
SOUNDTRACK_RANDOM_TIP = "Toggles shuffle for the selected event."

SOUNDTRACK_SOUND_EFFECT = "Sound Effect"
SOUNDTRACK_SOUND_EFFECT_TIP = "Plays the music track once as a sound effect, without stopping other music. This is useful for short sound-effects like victory music or a quest complete sound."

SOUNDTRACK_CONTINUOUS = "Repeat"
SOUNDTRACK_CONTINUOUS_TIP = "Plays the tracks continuously in a loop. If you turn this off, the track is played once, and then is removed from the stack."

SOUNDTRACK_REMOVE_TRACK = "Supprimer Track"


-- Button Names
SOUNDTRACK_ADD_BUTTON = "Ajouter"
SOUNDTRACK_REMOVE_BUTTON = "Supprimer"
SOUNDTRACK_EDIT_BUTTON = "Éditer"
SOUNDTRACK_RENAME_BUTTON = "Rebaptiser"


-- Minimap
SOUNDTRACK_MINIMAP = "Attribuez votre propre musique à divers événements dans le jeu ou jouer vos propres playlists. Vous pouvez faire glisser cette icône autour de la minicarte."


-- Battle Tab
SOUNDTRACK_UNKNOWN_BATTLE = "Inconnu Bataille"
SOUNDTRACK_NORMAL_MOB = "Plein Mob"
SOUNDTRACK_ELITE_MOB = "Elite Mob"

SOUNDTRACK_RARE = "Rare"
SOUNDTRACK_BOSS_BATTLE = "Boss Bataille"
SOUNDTRACK_WORLD_BOSS_BATTLE = "Monde Boss Bataille"
SOUNDTRACK_PVP_BATTLE = "JcJ Bataille"

SOUNDTRACK_REMOVE_BATTLE = "Supprimer bataille événement"
SOUNDTRACK_REMOVE_BATTLE_TIP = "Supprime l'événement sélectionné bataille."


-- Bosses Tab
SOUNDTRACK_ADD_TARGET = "Ajouter cible"
SOUNDTRACK_ADD_TARGET_TIP = "Ajoute la foule actuellement ciblée à la liste, ou entrez le nom d'une foule d'ajouter à la liste."
SOUNDTRACK_ADD_BOSS_TIP = "Ajouter mob nommé:"

SOUNDTRACK_REMOVE_TARGET = "Supprimer cible"
SOUNDTRACK_REMOVE_TARGET_TIP = "Supprime le mob ciblé sur la liste."


-- Zones Tab
SOUNDTRACK_ADD_ZONE = "Ajouter secteur"
SOUNDTRACK_ADD_ZONE_TIP = "Ajoute votre emplacement actuel à la liste de zone afin que vous pouvez attribuer des titres à leur disposition. Cela peut être fait automatiquement avec le option 'Ajouter automatiquement nouvelles secteurs'."

SOUNDTRACK_REMOVE_ZONE = "Supprimer secteur"
SOUNDTRACK_REMOVE_ZONE_TIP = "Supprime la secteur sélectionnée."


-- Dances Tab


-- Misc Tab
SOUNDTRACK_DUEL_REQUESTED = "Duel demandé"

SOUNDTRACK_STATUS_EVENTS = "Statut"
SOUNDTRACK_DEATH = "Statut/Décès"
SOUNDTRACK_FLIGHT = "Statut/Trajectoire de vol"
SOUNDTRACK_GHOST = "Statut/Fantôme"
SOUNDTRACK_MOUNT_FLYING = "Statut/Monture volante"
SOUNDTRACK_MOUNT_GROUND = "Statut/Mont-chaussée"
SOUNDTRACK_STEALTHED = "Statut/Camouflé"
SOUNDTRACK_SWIMMING = "Statut/Natation"
-- Added 1/17/2011
SOUNDTRACK_CINEMATIC = "Statut/Cinématographique"

SOUNDTRACK_GROUP_EVENTS = "Groupe & Auto"
SOUNDTRACK_ACHIEVEMENT = "Groupe & Auto/Accomplissement"
SOUNDTRACK_JOIN_PARTY = "Groupe & Auto/S'adhérer à un parti"
SOUNDTRACK_JOIN_RAID = "Groupe & Auto/Rejoignez Raid"
SOUNDTRACK_JUMP = "Groupe & Auto/Sauter de joie"
SOUNDTRACK_LEVEL_UP = "Groupe & Auto/Niveau de gain"
SOUNDTRACK_LFG_COMPLETE = "Groupe & Auto/LFG complète"
SOUNDTRACK_QUEST_COMPLETE = "Groupe & Auto/Quête complète"

SOUNDTRACK_NPC_EVENTS = "NPC"
SOUNDTRACK_AUCTION_HOUSE = "NPC/Enchères"
SOUNDTRACK_BANK = "NPC/Talus"
SOUNDTRACK_MERCHANT = "NPC/Négociant"
-- Added 1/17/2011
SOUNDTRACK_BARBERSHOP = "NPC/Salon de coiffure"
SOUNDTRACK_EMOTE = "NPC/Émotion"
SOUNDTRACK_SAY = "NPC/Dire"
SOUNDTRACK_WHISPER = "NPC/Chuchoter"
SOUNDTRACK_YELL = "NPC/Crier"

SOUNDTRACK_COMBAT_EVENTS = "Combattre"
SOUNDTRACK_HEAL_CRIT = "Combattre/Spell Heal Crit"
SOUNDTRACK_HEAL_HIT = "Combattre/Spell Heal"
SOUNDTRACK_HOT_CRIT = "Combattre/Spell HoT Crit"
SOUNDTRACK_HOT_HIT = "Combattre/Spell HoT"
SOUNDTRACK_RANGE_CRIT = "Combattre/Range Crit"
SOUNDTRACK_RANGE_HIT = "Combattre/Range"
SOUNDTRACK_SPELL_CRIT = "Combattre/Spell Damage Crit"
SOUNDTRACK_SPELL_HIT = "Combattre/Spell Damage"
SOUNDTRACK_DOT_CRIT = "Combattre/Spell DoT Crit"
SOUNDTRACK_DOT_HIT = "Combattre/Spell DoT"
SOUNDTRACK_SWING_CRIT = "Combattre/Swing Crit"
SOUNDTRACK_SWING_HIT = "Combattre/Swing"
SOUNDTRACK_VICTORY = "Combattre/Victoire"


SOUNDTRACK_DK = "Death Knight"
SOUNDTRACK_DK_CHANGE = "Death Knight/Change Presence"

SOUNDTRACK_DRUID = "Druide"
SOUNDTRACK_DRUID_CHANGE = "Druide/Change Form"
SOUNDTRACK_DRUID_AQUATIC = "Druide/Forme aquatique"
SOUNDTRACK_DRUID_BEAR = "Druide/Forme d'ours"
SOUNDTRACK_DRUID_CAT = "Druide/Forme de félin"
SOUNDTRACK_DRUID_DASH = "Druide/Dash"
SOUNDTRACK_DRUID_FLIGHT = "Druide/Forme de fuite"
SOUNDTRACK_DRUID_MOONKIN = "Druide/Forme de Moonkin"
SOUNDTRACK_DRUID_PROWL = "Druide/Prowl"
SOUNDTRACK_DRUID_TRAVEL = "Druide/Forme de voyage"
SOUNDTRACK_DRUID_TREE = "Druide/Forme de Tree of Life"

SOUNDTRACK_PALADIN = "Paladin"
SOUNDTRACK_PALADIN_CHANGE = "Paladin/Change Aura"

SOUNDTRACK_PRIEST = "Priest"
SOUNDTRACK_PRIEST_CHANGE = "Priest/Change Form"

SOUNDTRACK_ROGUE = "Rogue"
SOUNDTRACK_ROGUE_CHANGE = "Rogue/Change Stealth"
SOUNDTRACK_ROGUE_SPRINT = "Rogue/Sprint"

SOUNDTRACK_SHAMAN = "Shaman"
SOUNDTRACK_SHAMAN_CHANGE = "Shaman/Change Form"
SOUNDTRACK_SHAMAN_GHOST_WOLF = "Shaman/Ghost Wolf"

SOUNDTRACK_WARRIOR = "Warrior"
SOUNDTRACK_WARRIOR_CHANGE = "Warrior/Change Stance"

-- Old misc events, DO NOT EDIT
SOUNDTRACK_FLIGHT_OLD = "Trajectoire de vol"
SOUNDTRACK_DEATH_OLD = "Death"
SOUNDTRACK_GHOST_OLD = "Ghost"
SOUNDTRACK_MOUNT_FLYING_OLD = "Monture volante"
SOUNDTRACK_MOUNT_GROUND_OLD = "Mont-chaussée"
SOUNDTRACK_STEALTHED_OLD = "Camouflé"
SOUNDTRACK_SWIMMING_OLD = "Natation"

SOUNDTRACK_ACHIEVEMENT_OLD = "Achievement"
SOUNDTRACK_JOIN_PARTY_OLD = "S'adhérer à un parti"
SOUNDTRACK_JOIN_RAID_OLD = "Rejoignez Raid"
SOUNDTRACK_JUMP_OLD = "Jump"
SOUNDTRACK_LEVEL_UP_OLD = "Level Up"
SOUNDTRACK_LFG_COMPLETE_OLD = "LFG Complete"
SOUNDTRACK_QUEST_COMPLETE_OLD = "Quest complet"

SOUNDTRACK_AUCTION_HOUSE_OLD = "Enchères"
SOUNDTRACK_BANK_OLD = "Talus"
SOUNDTRACK_MERCHANT_OLD = "Négociant"

SOUNDTRACK_HEAL_CRIT_OLD = "Spell Heal Crit"
SOUNDTRACK_HEAL_HIT_OLD = "Spell Heal"
SOUNDTRACK_HOT_CRIT_OLD = "Spell HoT Crit"
SOUNDTRACK_HOT_HIT_OLD = "Spell HoT"
SOUNDTRACK_RANGE_CRIT_OLD = "Range Crit"
SOUNDTRACK_RANGE_HIT_OLD = "Range"
SOUNDTRACK_SPELL_CRIT_OLD = "Spell Damage Crit"
SOUNDTRACK_SPELL_HIT_OLD = "Spell Damage"
SOUNDTRACK_DOT_CRIT_OLD = "Spell DoT Crit"
SOUNDTRACK_DOT_HIT_OLD = "Spell DoT"
SOUNDTRACK_SWING_CRIT_OLD = "Swing Crit"
SOUNDTRACK_SWING_HIT_OLD = "Swing"
SOUNDTRACK_VICTORY_OLD = "Victory"


SOUNDTRACK_REMOVE_MISC = "Supprimer misc. événement"
SOUNDTRACK_REMOVE_MISC_TIP = "Supprime l'événement sélectionné misc."


-- Custom Event Tab
SOUNDTRACK_ADD_CUSTOM = "Ajouter un événement coutume"
SOUNDTRACK_ADD_CUSTOM_TIP = "Crée un nouvel événement sur mesure. Les événements coutumes sont des événements que vous pouvez définir vous-même à travers une variété de méthodes, y compris de script."

SOUNDTRACK_EDIT_CUSTOM = "Edit événement coutume"
SOUNDTRACK_EDIT_CUSTOM_TIP = "Passe à l'interface d'édition d'événements personnalisés de sorte que vous pouvez régler l'événement sélectionné coutume."

SOUNDTRACK_REMOVE_CUSTOM = "Supprimer événement coutume"
SOUNDTRACK_REMOVE_CUSTOM_TIP = "Supprime l'événement sélectionné coutume."

SOUNDTRACK_RANDOM = "Mêler"
SOUNDTRACK_SOUND_EFFECT = "Effet sonore"
SOUNDTRACK_CUSTOM_CONTINUOUS = "Continu"
SOUNDTRACK_CUSTOM_CONTINUOUS_TIP = "Détermine si cet événement sera une boucle ou jouer une fois. Quand un événement joue en permanence, il peut être arrêté par son propre script, ou par un autre événement de la remplacer."

SOUNDTRACK_EVENT_TYPE = "Type d'événement"
SOUNDTRACK_EVENT_TYPE_TIP = "Le type d'événement affecte la façon dont l'événement coutume est édité."

SOUNDTRACK_ENTER_CUSTOM_NAME = "Entrez le nom d'événement d'coutume:"



-- Playlists Tab
SOUNDTRACK_ADD_PLAYLIST = "Ajouter liste de lecture"
SOUNDTRACK_ADD_PLAYLIST_TIP = "Ajoute une nouvelle liste de lecture. Playlists priorité sur tous les autres événements, alors qu'ils n'ont jamais interrompu par d'autres événements."

SOUNDTRACK_REMOVE_PLAYLIST = "Supprimer liste de lecture"
SOUNDTRACK_REMOVE_PLAYLIST_TIP = "Supprime la liste de lecture sélectionnée."

SOUNDTRACK_RENAME_PLAYLIST = "Renommer liste de lecture"
SOUNDTRACK_RENAME_PLAYLIST_TIP = "Renommer la liste de lecture sélectionnée."

SOUNDTRACK_ENTER_PLAYLIST_NAME = "Entrez le nom d'liste de lecture:"


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

SOUNDTRACK_AUTO_ADD_ZONES = "Ajouter automatiquement nouvelles secteurs"
SOUNDTRACK_AUTO_ADD_ZONES_TIP = "Ajoute de nouvelles zones à la liste des événements zone que vous Voyage. Les zones sont ajoutés à tous les niveaux hiérarchiques (par exemple continents, grandes régions, villes, villages, auberges, etc)."

SOUNDTRACK_ESCALATE_BATTLE = "Escalate Battle Music"
SOUNDTRACK_ESCALATE_BATTLE_TIP = "If during a battle a stronger enemy is detected, allows the music to switch to the higher battle music."

SOUNDTRACK_BATTLE_CD = "Battle Cooldown"
SOUNDTRACK_BATTLE_CD_TIP = "The time it takes for battle music to stop when disengaged from battle."

SOUNDTRACK_LOOP_MUSIC = "Loop Music"
SOUNDTRACK_LOOP_MUSIC_TIP = "Enable to continuously play background music. This is the same setting exposed in the default Sound options."

SOUNDTRACK_MAX_SILENCE = "Maximum Silence"
SOUNDTRACK_MAX_SILENCE_TIP = "The maximum amount of silence to insert between tracks for zone music. Increase this value if you wish the music would take a break once in a while."

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
SOUNDTRACK_NO_TRACKS_PLAYING = "Aucun chansons en jouant"
SOUNDTRACK_NO_EVENT_PLAYING = "Aucun événement en jouant"
SOUNDTRACK_NOW_PLAYING = "Maintenant, en jouant"
SOUNDTRACK_MINIMAP_BUTTON_HIDDEN = "Le bouton minimap était caché. Vous pouvez accéder à l'interface utilisateur de Soundtrack en utilisant la commande /soundtrack ou /st."

SOUNDTRACK_REMOVE_QUESTION =  "Voulez-vous supprimer ce?"
SOUNDTRACK_PURGE_EVENTS_QUESTION = "MyTracks.lua  a changé.\n\nRetirer pistes obsolètes?"
SOUNDTRACK_GEN_LIBRARY = "Quitter le jeu, exécutez GenerateMyLibrary.py , et entrer de nouveau jeu pour créer MyTracks.lua pour Soundtrack pour fonctionner correctement."
SOUNDTRACK_NO_MYTRACKS = "MyTracks.lua pas trouvé.\n\nExécuter Soundtrack sans MyTracks.lua?"
SOUNDTRACK_ERROR_LOADING = "Impossible de charger MyTracks.lua. Vous avez probablement oublié d'exécuter GenerateMyLibrary.py. Lisez les instructions d'installation pour plus de détails."


end