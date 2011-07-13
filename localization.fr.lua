--------------------------------------------------
-- localization.fr.lua (French)
--------------------------------------------------
if GetLocale() == "frFR" then

SOUNDTRACK_DANCE_EMOTES = {};


SOUNDTRACK_TITLE = "Soundtrack"
BINDING_HEADER_SOUNDTRACK = SOUNDTRACK_TITLE


-- Main Frame
SOUNDTRACK_CLOSE = "Fermer la fenetre"
SOUNDTRACK_CLOSE_TIP = "Ferme la fenetre principale de Soundtrack. Si une piste etait lue en apercu, elle sera arretee."
	--"Si une playlist est lue, elle continuera."   -- Currently not functioning.

SOUNDTRACK_TRACK_FILTER = "Filtre des Pistes"
SOUNDTRACK_TRACK_FILTER_TIP = "Permet le filtrage des pistes. Le filtre est compare a la piste des noms de fichiers, les chemins, titre, artiste et nom de l'album. Decochez la case pour voir la liste complete des titres."

SOUNDTRACK_EVENT_SETTINGS = "Reglages des Evenements"
SOUNDTRACK_EVENT_SETTINGS_TIP = "Permet de modifier les parametres de l'evenement selectionne, telles que son nom, et le comportement de lecture."

SOUNDTRACK_ALL = "Toutes les Pistes"
SOUNDTRACK_ALL_TIP = "Ajoute toutes les pistes disponibles a des pistes assignees de cette manifestation. Utile si vous souhaitez creer une playlist ou un autre evenement qui jouera l'une de vos chansons."

SOUNDTRACK_CLEAR = "Enlever les Pistes"
SOUNDTRACK_CLEAR_TIP = "Supprime toutes les pistes assignees a partir des pistes de cet evenement."

SOUNDTRACK_DOWN = "Deplacer la(les) piste(s) vers le bas"
SOUNDTRACK_DOWN_TIP = "Deplace la piste selectionnee attribue a la liste. Cela vous permet de definir un ordre specifique pour les pistes de votre evenement."

SOUNDTRACK_UP = "Deplacer la(les) piste(s) vers le haut"
SOUNDTRACK_UP_TIP = "Deplace la piste selectionnee attribue a la liste. Cela vous permet de definir un ordre specifique pour les pistes de votre evenement."

SOUNDTRACK_NAME = "Nom de l'evenement"
SOUNDTRACK_NAME_TIP = "Il s'agit du nom de l'evenement selectionne. Vous pouvez renommer votre evenement. Appuyez sur Entree pour confirmer."

SOUNDTRACK_RANDOM = "Lecture Aleatoire"
SOUNDTRACK_RANDOM_TIP = "Active la lecture aleatoire pour l'evenement selectionne."

SOUNDTRACK_SOUND_EFFECT = "Effet Sonore"
SOUNDTRACK_SOUND_EFFECT_TIP = "Joue le morceau de musique une fois comme un effet sonore, sans arreter la musique actuelle. Ceci est utile a court d'effets sonores comme musique de la victoire ou une quete."

SOUNDTRACK_CONTINUOUS = "Repeter"
SOUNDTRACK_CONTINUOUS_TIP = "Lit les pistes en continu en boucle. Si vous desactivez cette option, la piste est jouee une seule fois, et est ensuite retire de la file."

SOUNDTRACK_REMOVE_TRACK = "Supprimer la Piste"


-- Button Names
SOUNDTRACK_ADD_BUTTON = "Ajouter"
SOUNDTRACK_REMOVE_BUTTON = "Supprimer"
SOUNDTRACK_EDIT_BUTTON = "Editer"
SOUNDTRACK_RENAME_BUTTON = "Renommer"


-- Minimap
SOUNDTRACK_MINIMAP = "Attribuez votre propre musique a divers evenements dans le jeu ou jouer vos propres playlists. Vous pouvez faire glisser cette icone autour de la minicarte."


-- Battle Tab
SOUNDTRACK_UNKNOWN_BATTLE = "Combat Aggro"
SOUNDTRACK_NORMAL_MOB = "Mob Normal"
SOUNDTRACK_ELITE_MOB = "Mob Elite"
-- Added 1/22/2010
SOUNDTRACK_CRITTER = "Bestiole"

SOUNDTRACK_RARE = "Rare"
SOUNDTRACK_BOSS_BATTLE = "Combat Boss"
SOUNDTRACK_BOSS_LOW_HEALTH = "Combat Boss Low Health"
SOUNDTRACK_LOW_HEALTH = "Low Health"
SOUNDTRACK_WORLD_BOSS_BATTLE = "Combat World Boss"
SOUNDTRACK_WORLD_BOSS_LOW_HEALTH = "Combat World Boss Low Health"
SOUNDTRACK_PVP_BATTLE = "Combat PvP"

SOUNDTRACK_REMOVE_BATTLE = "Supprimer l'evenement de bataille"
SOUNDTRACK_REMOVE_BATTLE_TIP = "Supprime l'evenement selectionne de bataille."


-- Bosses Tab
SOUNDTRACK_ADD_TARGET_PARTY_BUTTON = "Ajouter Party"
SOUNDTRACK_ADD_TARGET_RAID_BUTTON = "Ajouter Raid"
SOUNDTRACK_ADD_TARGET_PARTY = "Ajouter la cible en Party Boss"
SOUNDTRACK_ADD_TARGET_RAID = "Ajouter la cible en Raid Boss"
SOUNDTRACK_ADD_TARGET_TIP = "Ajoute la cible a la liste, ou entrez le nom d'un PNJ pour l'ajouter a la liste."
SOUNDTRACK_ADD_BOSS_TIP = "Ajouter nom du mob:"

SOUNDTRACK_REMOVE_TARGET = "Supprimer cible"
SOUNDTRACK_REMOVE_TARGET_TIP = "Supprime le mob cible sur la liste."


-- Zones Tab
SOUNDTRACK_ADD_ZONE = "Ajouter le Lieu"
SOUNDTRACK_ADD_ZONE_TIP = "Ajoute votre emplacement actuel a la liste de zone afin que vous pouvez attribuer des titres a leur disposition. Cela peut etre fait automatiquement avec le option 'Ajouter automatiquement nouvelles secteurs'."

SOUNDTRACK_REMOVE_ZONE = "Supprimer le Lieu"
SOUNDTRACK_REMOVE_ZONE_TIP = "Supprime le lieu selectionne."

SOUNDTRACK_INSTANCES = "Instances"
SOUNDTRACK_PVP = "PvP"
SOUNDTRACK_UNCATEGORIZED = "Uncategorized"
SOUNDTRACK_UNKNOWN = "Unknown"


-- Dances Tab


-- Misc Tab
SOUNDTRACK_DUEL_REQUESTED = "Demande de Duel"

SOUNDTRACK_STATUS_EVENTS = "Joueur"
SOUNDTRACK_DEATH = "Joueur/Mort"
SOUNDTRACK_FLIGHT = "Joueur/Trajectoire de Vol"
SOUNDTRACK_GHOST = "Joueur/Fantome"
SOUNDTRACK_MOUNT_FLYING = "Joueur/Monture Volante"
SOUNDTRACK_MOUNT_GROUND = "Joueur/Monture"
SOUNDTRACK_STEALTHED = "Statut/Camouflage"
SOUNDTRACK_SWIMMING = "Statut/Nage"
-- Added 1/17/2011
SOUNDTRACK_CINEMATIC = "Statut/Cinematique"

SOUNDTRACK_GROUP_EVENTS = "Groupe & Auto"
SOUNDTRACK_ACHIEVEMENT = "Groupe & Auto/Haut-Fait"
SOUNDTRACK_JOIN_PARTY = "Groupe & Auto/Rejoindre Groupe"
SOUNDTRACK_JOIN_RAID = "Groupe & Auto/Rejoindre Raid"
SOUNDTRACK_JUMP = "Groupe & Auto/Saut"
SOUNDTRACK_LEVEL_UP = "Groupe & Auto/Niveau Superieur"
SOUNDTRACK_LFG_COMPLETE = "Groupe & Auto/Donjon Termine"
SOUNDTRACK_QUEST_COMPLETE = "Groupe & Auto/Quete Terminee"

SOUNDTRACK_NPC_EVENTS = "PNJ"
SOUNDTRACK_AUCTION_HOUSE = "PNJ/Encheres"
SOUNDTRACK_BANK = "PNJ/Banque"
SOUNDTRACK_MERCHANT = "PNJ/Marchand"
-- Added 1/17/2011
SOUNDTRACK_BARBERSHOP = "PNJ/Salon de Coiffure"
SOUNDTRACK_NPC_EMOTE = "PNJ/Emote"
SOUNDTRACK_NPC_SAY = "PNJ/Dire"
SOUNDTRACK_NPC_WHISPER = "PNJ/Chuchoter"
SOUNDTRACK_NPC_YELL = "PNJ/Crier"

SOUNDTRACK_COMBAT_EVENTS = "Combat"
SOUNDTRACK_HEAL_CRIT = "Combat/Spell Heal Crit"
SOUNDTRACK_HEAL_HIT = "Combat/Spell Heal"
SOUNDTRACK_HOT_CRIT = "Combat/Spell HoT Crit"
SOUNDTRACK_HOT_HIT = "Combat/Spell HoT"
SOUNDTRACK_RANGE_CRIT = "Combat/Range Crit"
SOUNDTRACK_RANGE_HIT = "Combat/Range"
SOUNDTRACK_SPELL_CRIT = "Combat/Spell Damage Crit"
SOUNDTRACK_SPELL_HIT = "Combat/Spell Damage"
SOUNDTRACK_DOT_CRIT = "Combat/Spell DoT Crit"
SOUNDTRACK_DOT_HIT = "Combat/Spell DoT"
SOUNDTRACK_SWING_CRIT = "Combat/Swing Crit"
SOUNDTRACK_SWING_HIT = "Combat/Swing"
SOUNDTRACK_VICTORY = "Combat/Victoire"
SOUNDTRACK_VICTORY_BOSS = "Combat/Victoire, Boss"

local n

SOUNDTRACK_DK = "Chevalier de la Mort"
SOUNDTRACK_DK_CHANGE = "Chevalier de la Mort/Changer Presence"

SOUNDTRACK_DRUID = "Druide"
SOUNDTRACK_DRUID_CHANGE = "Druide/Changer Forme"
n = GetSpellInfo(1066)
SOUNDTRACK_DRUID_AQUATIC = "Druide/"..n
n = GetSpellInfo(5487)
SOUNDTRACK_DRUID_BEAR = "Druide/"..n
n = GetSpellInfo(768)
SOUNDTRACK_DRUID_CAT = "Druide/"..n
n = GetSpellInfo(1850)
SOUNDTRACK_DRUID_DASH = "Druide/"..n
n = GetSpellInfo(33943)
SOUNDTRACK_DRUID_FLIGHT = "Druide/"..n
n = GetSpellInfo(24858)
SOUNDTRACK_DRUID_MOONKIN = "Druide/"..n
n = GetSpellInfo(5215)
SOUNDTRACK_DRUID_PROWL = "Druide/"..n
n = GetSpellInfo(783)
SOUNDTRACK_DRUID_TRAVEL = "Druide/"..n
n = GetSpellInfo(65139)
SOUNDTRACK_DRUID_TREE = "Druide/"..n

SOUNDTRACK_HUNTER = "Chasseur"
n = GetSpellInfo(51755)
SOUNDTRACK_HUNTER_CAMO = "Chasseur/"..n

SOUNDTRACK_MAGE = "Mage"

SOUNDTRACK_PALADIN = "Paladin"
SOUNDTRACK_PALADIN_CHANGE = "Paladin/Changer Aura"

SOUNDTRACK_PRIEST = "Pretre"
SOUNDTRACK_PRIEST_CHANGE = "Pretre/Changer Forme"

SOUNDTRACK_ROGUE = "Voleur"
n = GetSpellInfo(2983)
SOUNDTRACK_ROGUE_SPRINT = "Voleur/"..n
n = GetSpellInfo(1784)
SOUNDTRACK_ROGUE_STEALTH = "Voleur/"..n
SOUNDTRACK_ROGUE_CHANGE = "Voleur/Changer "..n

SOUNDTRACK_SHAMAN = "Chaman"
SOUNDTRACK_SHAMAN_CHANGE = "Chaman/Changer Forme"
n = GetSpellInfo(2645)
SOUNDTRACK_SHAMAN_GHOST_WOLF = "Chaman/"..n

SOUNDTRACK_WARLOCK = "Demoniste"

SOUNDTRACK_WARRIOR = "Guerrier"
SOUNDTRACK_WARRIOR_CHANGE = "Guerrier/Changer Posture"

-- Old misc events, DO NOT EDIT
--[[
SOUNDTRACK_FLIGHT_OLD = "Trajectoire de vol"
SOUNDTRACK_DEATH_OLD = "Death"
SOUNDTRACK_GHOST_OLD = "Ghost"
SOUNDTRACK_MOUNT_FLYING_OLD = "Monture volante"
SOUNDTRACK_MOUNT_GROUND_OLD = "Monture"
SOUNDTRACK_STEALTHED_OLD = "Camouflage"
SOUNDTRACK_SWIMMING_OLD = "Nage"

SOUNDTRACK_ACHIEVEMENT_OLD = "Haut-Fait"
SOUNDTRACK_JOIN_PARTY_OLD = "Rejoindre Groupe"
SOUNDTRACK_JOIN_RAID_OLD = "Rejoindre Raid"
SOUNDTRACK_JUMP_OLD = "Saut"
SOUNDTRACK_LEVEL_UP_OLD = "Niveau Superieur"
SOUNDTRACK_LFG_COMPLETE_OLD = "Donjon Termine"
SOUNDTRACK_QUEST_COMPLETE_OLD = "Quete Terminee"

SOUNDTRACK_AUCTION_HOUSE_OLD = "Encheres"
SOUNDTRACK_BANK_OLD = "Banque"
SOUNDTRACK_MERCHANT_OLD = "Marchand"

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
SOUNDTRACK_VICTORY_OLD = "Victoire"
--]]

SOUNDTRACK_REMOVE_MISC = "Supprimer misc. Evenement"
SOUNDTRACK_REMOVE_MISC_TIP = "Supprime l'evenement selectionne misc."


-- Custom Event Tab
SOUNDTRACK_ADD_CUSTOM = "Ajouter un evenement personalise"
SOUNDTRACK_ADD_CUSTOM_TIP = "Cree un nouvel evenement personalise. Les evenements personalises sont des evenements que vous pouvez definir vous-meme a travers une variete de methodes de  scripts."

SOUNDTRACK_EDIT_CUSTOM = "Editer l'evenement personalise"
SOUNDTRACK_EDIT_CUSTOM_TIP = "Passe a l'interface d'edition d'evenements personnalise de sorte que vous pouvez regler l'evenement selectionne comme bon vous semble."

SOUNDTRACK_REMOVE_CUSTOM = "Supprimer evenement personnalise"
SOUNDTRACK_REMOVE_CUSTOM_TIP = "Supprime l'evenement selectionne personnalise."

SOUNDTRACK_RANDOM = "Aleatoire"
SOUNDTRACK_SOUND_EFFECT = "Effet Sonore"
SOUNDTRACK_CUSTOM_CONTINUOUS = "Continu"
SOUNDTRACK_CUSTOM_CONTINUOUS_TIP = "Determine si cet evenement sera une boucle ou joue une fois. Quand un evenement se lit en permanence, il peut etre arrete par son propre script, ou par un autre evenement remplace."

SOUNDTRACK_EVENT_TYPE = "Type d'evenement"
SOUNDTRACK_EVENT_TYPE_TIP = "Le type d'evenement affecte la façon dont l'evenement personnalise est modifie."

SOUNDTRACK_ENTER_CUSTOM_NAME = "Entrez le nom de l'evenement personnalise:"



-- Playlists Tab
SOUNDTRACK_ADD_PLAYLIST = "Ajouter liste de lecture"
SOUNDTRACK_ADD_PLAYLIST_TIP = "Ajoute une nouvelle liste de lecture. Les Playlists ont la priorite sur tous les autres evenements, et ne modifie pas les autres."

SOUNDTRACK_REMOVE_PLAYLIST = "Supprimer liste de lecture"
SOUNDTRACK_REMOVE_PLAYLIST_TIP = "Supprime la liste de lecture selectionnee."

SOUNDTRACK_RENAME_PLAYLIST = "Renommer liste de lecture"
SOUNDTRACK_RENAME_PLAYLIST_TIP = "Renommer la liste de lecture selectionnee."

SOUNDTRACK_ENTER_PLAYLIST_NAME = "Entrez le nom de la liste de lecture:"


-- Options Tab


-- Playback Controls
SOUNDTRACK_PREVIOUS = "Piste precedente"
SOUNDTRACK_PREVIOUS_TIP = "Passe a la piste precedente de cet evenement."

SOUNDTRACK_PLAY = "Lire"
SOUNDTRACK_PLAY_TIP = "Cliquez pour reprendre cet evenement."

SOUNDTRACK_PAUSE = "Pause"
SOUNDTRACK_PAUSE_TIP = "Cliquez pour faire une pause cet evenement."

SOUNDTRACK_NEXT = "Piste suivante"
SOUNDTRACK_NEXT_TIP = "Passe a la piste suivante de cet evenement."

SOUNDTRACK_STOP = "Stop"
SOUNDTRACK_STOP_TIP = "Stoppe cet evenement."

SOUNDTRACK_INFO = "Info"
SOUNDTRACK_INFO_TIP = "Donne des informations sur la piste en cours de lecture."

SOUNDTRACK_REPORT = "Reporter"
SOUNDTRACK_REPORT_TIP = "Reporter la piste actuelle sur le canal desire."

-- Options Tab
SOUNDTRACK_SHOW_MINIMAP_BUTTON = "Montr. boutton de Minimap"
SOUNDTRACK_SHOW_MINIMAP_BUTTON_TIP = "Affiche l'icone de soundtrack sur la minicarte. L'icone peut etre deplacee en la faisant glisser autour de la minicarte. Si vous desactivez ce bouton, vous pouvez ouvrir la fenetre principale Soundtrack avec un raccourci clavier ou avec la commande /soundtrack."

SOUNDTRACK_SHOW_PLAYBACK_CONTROLS = "Commandes de lecture"
SOUNDTRACK_SHOW_PLAYBACK_CONTROLS_TIP = "Affiche une barre d'outils avec un mini boutton precedent, pause, et suivant pour controler la lecture. Les controles peuvent etre repositionnes en faisant glisser la zone du nom."

SOUNDTRACK_LOCK_PLAYBACK_CONTROLS = "Verr. Commandes de lecture"
SOUNDTRACK_LOCK_PLAYBACK_CONTROLS_TIP = "Rend les controles de lecture immobile."

SOUNDTRACK_SHOW_TRACK_INFO = "Aff. Infos Piste"
SOUNDTRACK_SHOW_TRACK_INFO_TIP = "Lorsque le suivi des modifications, le titre de la piste, album et artiste est brievement affiche a l'ecran. La trame d'information piste peut etre repositionnee en la faisant glisser quand elle apparait."

SOUNDTRACK_SHOW_DEFAULT_MUSIC = "Montrer musiques Blizz."
SOUNDTRACK_SHOW_DEFAULT_MUSIC_TIP = "Ajoute tous les morceaux de musique disponibles inclus avec le jeu a votre bibliotheque musicale."

SOUNDTRACK_LOCK_NOW_PLAYING = "Verr. Infos Piste"
SOUNDTRACK_LOCK_NOW_PLAYING_TIP = "Verrouille la trame d' informations sur la piste."

SOUNDTRACK_SHOW_DEBUG = "Sortie des infos de debogage"
SOUNDTRACK_SHOW_DEBUG_TIP = "Outputs verbose debug information to the chat frame. Output is sent to default chat frame or the frame named 'Soundtrack' if available."

SOUNDTRACK_SHOW_EVENT_STACK = "Event Stack"
SOUNDTRACK_SHOW_EVENT_STACK_TIP = "Displays the currently active events in the stack, below the minimap (useful for debugging)."

SOUNDTRACK_AUTO_ADD_ZONES = "Ajouter Auto. nouvelles zones"
SOUNDTRACK_AUTO_ADD_ZONES_TIP = "Ajoute de nouvelles zones a la liste des evenements zone lors de votre voyage. Les zones sont ajoutes a tous les niveaux hierarchiques (par exemple continents, grandes regions, villes, villages, auberges, etc)."

SOUNDTRACK_ESCALATE_BATTLE = "Escalade Musique Combat"
SOUNDTRACK_ESCALATE_BATTLE_TIP = "Si au cours d'une bataille un ennemi plus fort est detecte, la musique permet de passer a la musique de l'ennemi."

SOUNDTRACK_YOUR_ENEMY_LEVEL = "Your Enemy Level Only"
SOUNDTRACK_YOUR_ENEMY_LEVEL_TIP = "Only use you and your pet's target to calculate current enemy level."

SOUNDTRACK_BATTLE_CD = "Silence Combat"
SOUNDTRACK_BATTLE_CD_TIP = "Le temps qu'il faut pour la musique de combat pour arreter au desengagement de la bataille."

SOUNDTRACK_LOW_HEALTH_PERCENT = "Boss Low Health %"
SOUNDTRACK_LOW_HEALTH_PERCENT_TIP = "The amount of health when Boss and World Boss events switch to Boss Low Health."

SOUNDTRACK_LOOP_MUSIC = "Musique en boucle"
SOUNDTRACK_LOOP_MUSIC_TIP = "Activer la lecture en boucle pour les pistes en arr. plan. C'est le meme parametre expose dans les options de son par defaut."

SOUNDTRACK_MAX_SILENCE = "Silence Max."
SOUNDTRACK_MAX_SILENCE_TIP = "Le montant maximum de silence a inserer entre les pistes pour la musique zone. Augmentez cette valeur si vous souhaitez que la musique serait de prendre une pause de temps en temps."

SOUNDTRACK_PROJECT = "Project"
SOUNDTRACK_PROJECT_TIP = "Soundtrack Project to load or remove from Soundtrack"

SOUNDTRACK_PROJECT_LOAD = "Charger un Project"
SOUNDTRACK_PROJECT_LOAD_TIP = "Loads a project's event-track settings into Soundtrack"

SOUNDTRACK_PROJECT_REMOVE = "Supprimer un Project"
SOUNDTRACK_PROJECT_REMOVE_TIP = "Removes a project's event-track settings from Soundtrack"

SOUNDTRACK_ENABLE_MUSIC = "Activer Musique"
SOUNDTRACK_ENABLE_MUSIC_TIP = "Desactiver toutes les musiques. Utilisez cette option pour desactiver temporairement l'ensemble de la musique Soundtrack."

SOUNDTRACK_ENABLE_ZONE_MUSIC = "Activer Musique Zone"
SOUNDTRACK_ENABLE_ZONE_MUSIC_TIP = "Activer la musique de zone. Utilisez cette option pour arreter temporairement toute la musique zone de jouer."

SOUNDTRACK_ENABLE_BATTLE_MUSIC = "Activer Musique Combat"
SOUNDTRACK_ENABLE_BATTLE_MUSIC_TIP = "Activer la musique de combat. Utilisez cette option pour arreter temporairement toute la musique de combat."

SOUNDTRACK_ENABLE_MISC_MUSIC = "Activer Musique Divers"
SOUNDTRACK_ENABLE_MISC_MUSIC_TIP = "Activer la musique diverse. Utilisez cette option pour desactiver temporairement toutes les musiques diverses."

SOUNDTRACK_ENABLE_CUSTOM_MUSIC = "Activer Musique Perso"
SOUNDTRACK_ENABLE_CUSTOM_MUSIC_TIP = "Activer la musique personnalisee. Utilisez cette option pour desactiver temporairement toutes les musiques personnalisees."


-- Other
SOUNDTRACK_NO_TRACKS_PLAYING = "Aucune piste en lecture"
SOUNDTRACK_NO_EVENT_PLAYING = "Aucun evenment en lecture"
SOUNDTRACK_NOW_PLAYING = "Lecture en cours"
SOUNDTRACK_MINIMAP_BUTTON_HIDDEN = "Le bouton minimap est cache. Vous pouvez acceder a l'interface utilisateur de Soundtrack en utilisant la commande /soundtrack ou /st."

SOUNDTRACK_REMOVE_QUESTION =  "Voulez-vous le supprimer ?"
SOUNDTRACK_PURGE_EVENTS_QUESTION = "MyTracks.lua  a change.\n\n Retirer pistes obsoletes ?"
SOUNDTRACK_GEN_LIBRARY = "Quittez le jeu, executez GenerateMyLibrary.py , et entrer de nouveau en jeu pour creer MyTracks.lua pour Soundtrack afin de fonctionner correctement."
SOUNDTRACK_NO_MYTRACKS = "MyTracks.lua introuvable.\n\n Executer Soundtrack sans MyTracks.lua ?"
SOUNDTRACK_ERROR_LOADING = "Impossible de charger MyTracks.lua. Vous avez probablement oublie d'executer GenerateMyLibrary.py. Lisez les instructions d'installation pour plus de details."


SOUNDTRACK_COPY_BUTTON = "Copier"
SOUNDTRACK_COPY_TRACKS = "Cop. Pistes"
SOUNDTRACK_COPY_TRACKS_TIP = "Copier les pistes de l'evenement selectionne."

SOUNDTRACK_PASTE_BUTTON = "Coller"
SOUNDTRACK_PASTE_TRACKS = "Coll. Pistes"
SOUNDTRACK_PASTE_TRACKS_TIP = "Coller les pistes de l'evenement selectionne."

SOUNDTRACK_CLEAR_BUTTON = "Nett."
SOUNDTRACK_CLEAR_TRACKS = "Nett. Pistes"
SOUNDTRACK_CLEAR_TRACKS_TIP = "Nettoyer les pistes copiees."

end