/*--------------------------------------------------
	=============== Dinosaur ConVars ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load ConVars for Dinosaur
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
-------------------------------------------------------------------
local AddConvars = {}


AddConvars["vj_allosaurus_h"] = 460
AddConvars["vj_allosaurus_d"] = 18

AddConvars["vj_hadro_h"] = 560
AddConvars["vj_hadro_d"] = 15

AddConvars["vj_carno_h"] = 890
AddConvars["vj_carno_d"] = 30

AddConvars["vj_cerato_h"] = 135
AddConvars["vj_cerato_d"] = 15

AddConvars["vj_trex_l2_h"] = 2300
AddConvars["vj_trex_l2_d"] = 45

AddConvars["vj_trex_h"] = 2010
AddConvars["vj_trex_d"] = 40

AddConvars["vj_triceratops_h"] = 820
AddConvars["vj_triceratops_d"] = 45

AddConvars["vj_dilop_h"] = 320
AddConvars["vj_dilop_d"] = 20

AddConvars["vj_gigantosaur_h"] = 2320
AddConvars["vj_gigantosaur_d"] = 35

AddConvars["vj_trex_jp_h"] = 3200
AddConvars["vj_trex_jp_d"] = 45

AddConvars["vj_carha_h"] = 2400
AddConvars["vj_carha_d"] = 35

AddConvars["vj_droma_h"] = 70
AddConvars["vj_droma_d"] = 20

AddConvars["vj_spino_jp_h"] = 3500
AddConvars["vj_spino_jp_d"] = 165

AddConvars["vj_raptor_jp_h"] = 150
AddConvars["vj_raptor_jp_d"] = 16

AddConvars["vj_rugops_h"] = 350
AddConvars["vj_rugops_d"] = 20

AddConvars["vj_trex_huge_h"] = 2800
AddConvars["vj_trex_huge_d"] = 50

AddConvars["vj_raptor_t_h"] = 60
AddConvars["vj_raptor_t_d"] = 10

AddConvars["vj_brah_h"] = 9200


for k, v in pairs(AddConvars) do
	if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_NONE} ) end
end