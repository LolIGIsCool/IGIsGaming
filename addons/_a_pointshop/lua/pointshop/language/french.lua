return {
	-- Common
	hats = "Tête",
	accessories = "Accessoires",
	trails = "Traînées",
	player_models = "Modèles",
	weapons = "Armes",
	powerups = "Boosts",
	free = "Gratuit",
	buy = "Acheter",
	sell = "Vendre",
	equip = "Porter",
	unequip = "Enlever",
	adjust = "Ajuster",
	position = "Position",
	angle = "Angle",
	scale = "Taille",
	target = "Cible",
	save = "Sauvegarder",

	-- General
	standard_points = "Points Standard",
	premium_points = "Points Premium",
	you_have_x_items_out_of_y_in_category = "Vous avez {amount} objets sur {total} dans cette catégorie.",
	reset_adjustments = "Réinitialiser ajustements",

	-- Tooltips
	this_item_equipped = "Vous portez cet objet.",
	this_item_possessed = "Cet objet est dans votre inventaire.",
	adjust_tooltip = "Ajustez la position, l'angle et la taille de cet objet pour mieux correspondre au modèle.",

	-- Messages
	no_permission = "Vous n'avez pas le droit de faire cet action.",
	you_cannot_afford_x = "Vous ne pouvez pas vous permettre {item} ! Vous devez avoir {cost}.",
	you_have_already_purchased_x = "Vous avez déjà {item} !",
	you_have_purchased_x_for_y = "Vous avez acheté {item} contre {spent}!",
	you_have_sold_x_for_y = "Vous avez vendu {item} pour {gain}!",
	your_inventory_is_full = "Votre inventaire est plein !",
	you_dont_possess_item = "Vous ne possédez pas cet objet !",
	equipped_x = "Vous portez {item}",
	unequipped_x = "Vous ne portez plus {item}",
	action_failed_try_again = "Échec de l'action. Veuillez réessayer.",
	target_not_found = "Cible introuvable.",
	given_x_by_admin = "Un administrateur vous a donné {item} !",

	-- Formats
	x_standard_points = "{amount} Points",
	x_premium_points = "{amount} Points Premium",

	-- MODULE: Points for Activity
	pa_message = "Vous avez reçu {award} pour votre activité sur le serveur !",

	-- MODULE: Points Transfer
	transfer_points = "Transfert de points",
	transfer_points_desc = "Vous pouvez transférer vos points à un autre joueur ici.",
	pt_success = "Vous avez envoyé {points} à {recipient} !",
	pt_receipt = "{sender} vous a envoyé {points} !",
	pt_limitreached = "{recipient} a atteint la limite maximale de Points !",
	pt_notenough = "Vous n'avez pas assez de Points !",

	-- MODULE: Item Manager
	item_manager = "Gestionnaire d'objets",
	item_manager_desc = "Gérez et créez des objets ici en-jeu.",
	im_manage_items = "Gérer les objets",
	im_create_items = "Créer un objet",

	im_template = "Modèle d'objet :",
	im_classname = "Nom de classe (lettres miniscules, nombres et underscores seulement):",
	im_category = "Catégorie :",
	im_displayname = "Nom d'affichage :",
	im_description = "Description :",
	im_model = "Modèle :",
	im_price_std = "Prix (Points Standard):",
	im_price_prm = "Prix (Points Premium):",
	im_addtoinventory = "Ajouter à l'inventaire à l'achat ? (Si non, peut être acheté plusieurs fois):",
	im_camerafocus = "Point focal :",
	im_adjustable = "Ajustable ?",
	im_sckdata = "Nom de fichier SWEP Construction Kit :",
	im_pacdata = "Nom de fichier PAC3:",
	im_registeritem = "Enregistrer l'objet",
	im_list_category = "Catégorie",
	im_list_name = "Nom",
	im_custom = "Custom",
	im_lua = "Fichier Lua (non éditable)",
	im_editing_x = "Modification de {itemname}",
	im_reset_changes = "Réinitialiser les changements",
	im_apply_changes = "Appliquer les changements",
	im_go_back = "Retour",
	im_delete = "Supprimer objet",
	im_confirm = "Confirmer ?",

	im_failed_to_load_sck = "Échec du chargement du fichier SWEP Construction Kit",
	im_failed_to_load_pac = "Échec du chargement du fichier PAC3",
	im_missing_or_invalid_info = "Des informations requises sont manquantes ou invalides.",
	im_file_already_exists = "Un objet avec ce nom de fichier existe déjà !",
	im_failed_loading_item = "Échec du chargement de {class} ({errorcode}) !",
	im_hardcoded_file = "Cet objet se trouve dans un fichier .lua et ne peut pas être édité.",
	im_item_doesnt_exist = "Cet objet n'existe pas.",
	im_successfully_created = "L'objet {class} a été crée avec succès !",
	im_changes_applied = "Changements appliqués pour {class} !",
	im_item_deleted = "L'objet {class} a été supprimé avec succès !",
	im_sck_must_be_installed = "SWEP Construction Kit doit être installé pour charger des fichiers SCK.",

	-- MODULE: Options
	opt_options = "Options de client",
	opt_options_desc = "Configurez vos options ici.",
	opt_render_distance = "Distance de rendu",
	opt_disable_hats_on_players = "Désactiver les cosmétiques sur les joueurs",
	opt_disable_hats_on_ragdolls = "Désactiver les cosmétiques sur les corps",
	opt_simple_item_icons = "Icônes d'objetes simples",
	opt_interface = "Interface",
	opt_rendering = "Rendu",

	-- MODULE: Integration
	int_earned_x_points_this_round = "Vous avez gagné {points} lors de cette manche !",
}