local easynet = SH_POINTSHOP.easynet

-- SERVER -> CLIENT
easynet.Start("SH_POINTSHOP.OpenMenu")
easynet.Register()

easynet.Start("SH_POINTSHOP.SendNotification")
	easynet.Add("message", EASYNET_STRING)
	easynet.Add("positive", EASYNET_BOOL)
easynet.Register()

easynet.Start("SH_POINTSHOP.SendFull")
	easynet.Add("entity", EASYNET_PLAYER)
	easynet.Add("standard", EASYNET_UINT32)
	easynet.Add("premium", EASYNET_UINT32)
	easynet.Add("inventory", EASYNET_JSON, true)
	easynet.Add("equipped", EASYNET_JSON, true)
easynet.Register()

easynet.Start("SH_POINTSHOP.SendPoints")
	easynet.Add("entity", EASYNET_PLAYER)
	easynet.Add("standard", EASYNET_UINT32)
	easynet.Add("premium", EASYNET_UINT32)
easynet.Register()

easynet.Start("SH_POINTSHOP.SendInventory")
	easynet.Add("entity", EASYNET_PLAYER)
	easynet.Add("inventory", EASYNET_JSON, true)
easynet.Register()

easynet.Start("SH_POINTSHOP.SendEquipped")
	easynet.Add("entity", EASYNET_PLAYER)
	easynet.Add("equipped", EASYNET_JSON, true)
easynet.Register()

easynet.Start("SH_POINTSHOP.SendAdjustment")
	easynet.Add("entity", EASYNET_PLAYER)
	easynet.Add("class", EASYNET_STRING)
	easynet.Add("pos", EASYNET_VECTOR)
	easynet.Add("ang", EASYNET_ANGLE)
	easynet.Add("scale", EASYNET_VECTOR)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemBought")
	easynet.Add("itm", EASYNET_JSON)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemSold")
	easynet.Add("itm", EASYNET_JSON)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemEquipped")
	easynet.Add("itm", EASYNET_JSON)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemUnequipped")
	easynet.Add("itm", EASYNET_JSON)
easynet.Register()

-- CLIENT -> SERVER
easynet.Start("SH_POINTSHOP.PurchaseItem")
	easynet.Add("class", EASYNET_STRING)
easynet.Register()

easynet.Start("SH_POINTSHOP.SellItem")
	easynet.Add("id", EASYNET_UINT32)
easynet.Register()

easynet.Start("SH_POINTSHOP.EquipItem")
	easynet.Add("id", EASYNET_UINT32)
easynet.Register()

easynet.Start("SH_POINTSHOP.UnequipItem")
	easynet.Add("id", EASYNET_UINT32)
easynet.Register()

easynet.Start("SH_POINTSHOP.ApplyAdjustment")
	easynet.Add("class", EASYNET_STRING)
	easynet.Add("px", EASYNET_FLOAT)
	easynet.Add("py", EASYNET_FLOAT)
	easynet.Add("pz", EASYNET_FLOAT)
	easynet.Add("ax", EASYNET_FLOAT)
	easynet.Add("ay", EASYNET_FLOAT)
	easynet.Add("az", EASYNET_FLOAT)
	easynet.Add("sx", EASYNET_FLOAT)
	easynet.Add("sy", EASYNET_FLOAT)
	easynet.Add("sz", EASYNET_FLOAT)
easynet.Register()

easynet.Start("SH_POINTSHOP.PlayerReady")
easynet.Register()