axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

cfg["hp_price"] 	= 0;
cfg["hp_count"] 	= 0;
cfg["max_hp"]		= 0;
cfg["color"]		= Color(0, 161, 255);
cfg["keypad_color"] = Color(57, 60, 102, 150);
cfg["enable_health"] = false;					// NEED RESTART!!!!!!

cfg["keypad_err"]	= "npc/roller/mine/combine_mine_deploy1.wav";
cfg["keypad_ok"]	= "npc/roller/remote_yes.wav";
cfg["keypad_use"]	= "items/nvg_off.wav";