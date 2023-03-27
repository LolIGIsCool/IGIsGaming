local bountyBoard = bountyBoard or {};

resource.AddFile("materials/vanilla/bh/decal.png");
resource.AddFile("materials/vanilla/bh/chain.png");
resource.AddFile("materials/vanilla/bh/chain2.png");
resource.AddFile("materials/vanilla/bh/background.png");
resource.AddFile("materials/vanilla/bh/select.png");
resource.AddFile("materials/vanilla/bh/price.png");

AddCSLuaFile("bh/bh_imgui.lua");

util.AddNetworkString("VANILLABOUNTY_net_PrettyText");
util.AddNetworkString("VANILLABOUNTY_net_FauxComms");

util.AddNetworkString("VANILLABOUNTY_net_BroadcastBounty");
util.AddNetworkString("VANILLABOUNTY_net_ClaimBounty");

util.AddNetworkString("VANILLABOUNTY_net_LoginBroadcast");

net.Receive("VANILLABOUNTY_net_BroadcastBounty", function( len, ply )
	//lets read us some vars shall we
	local netMethod = net.ReadString();
	local netTarget = net.ReadString();
	local netReward = net.ReadString();
	local netLocation = net.ReadString();

	//exploit check
	if not ply:SH_CanAffordPremium(tonumber(netReward)) then return end

	//if the player already has a bounty added, do not allow them to place another
	local found = false;
	for _, v in ipairs(bountyBoard) do
		if v.owner == ply then
			found = true;
			break;
		end
	end

	if found then
		net.Start("VANILLABOUNTY_net_PrettyText");
		net.WriteString("It seems you already have an active bounty with us. Please wait until this bounty is resolved.");
		net.Send(ply);

		return;
	end

	local targetEnt;

	for _, v in ipairs(player.GetAll()) do
		if v:Nick() == netTarget then
			targetEnt = v;
			break;
		end
	end

	//if the target already has a bounty on them, cancel the bounty
	local popular = false;
	for _, v in ipairs(bountyBoard) do
		if v.target == targetEnt then
			popular = true;
			break;
		end
	end

	if popular then
		net.Start("VANILLABOUNTY_net_PrettyText");
		net.WriteString("It seems your target already has a bounty placed on them. Please wait for our hunters to finish the job.");
		net.Send(ply);

		return;
	end

	//if the target has had a bounty on them recently, cancel the bounty
	if targetEnt:GetVar("VANILLABOUNTY_var_Cooldown", false) then
		net.Start("VANILLABOUNTY_net_PrettyText");
		net.WriteString("It seems this target has had a bounty on them recently. Cancelling the bounty.");
		net.Send(ply);

		return;
	end


	local uid = CurTime();

	bountyBoard[#bountyBoard + 1] = {
		owner = ply, // ent
		target = targetEnt, //ent
		method = netMethod, // string
		reward = netReward, // string
		location = netLocation, // string
		id = uid,
		hunters = {},
		banned = {}
	}

	ply:SH_AddPremiumPoints(-1 * tonumber(netReward), nil, false, false);

	net.Start("VANILLABOUNTY_net_BroadcastBounty");
	net.WriteTable(bountyBoard);
	net.Broadcast();

	net.Start("VANILLABOUNTY_net_PrettyText");
	net.WriteString("Your bounty has been placed onto our network. Thank you for doing business with us.");
	net.Send(ply);

	net.Start("VANILLABOUNTY_net_FauxComms");
	net.WriteString("Twilight here. A new bounty is on the network. Get to work hunters.");
	net.Broadcast();

	//create a timer for no one accepting the bounty
	timer.Create("VANILLABOUNTY_timer_DepressedClient_" .. uid, 1200, 1, function()
		//if nobody thinks the bounty is good, give the client back their creds ffrfrfrf
		for k, v in pairs(bountyBoard) do
			if v.id == uid and table.IsEmpty(v.hunters) then
				if not IsValid(v.owner) then return end

				v.owner:SH_AddPremiumPoints(v.reward, nil, false, false);

				net.Start("VANILLABOUNTY_net_PrettyText");
				net.WriteString("I regret to inform you that no Bounty Hunters have accepted your bounty in the last 20 minutes. Returning your credits now.");
				net.Send(v.owner);

				table.remove(bountyBoard, k);

				net.Start("VANILLABOUNTY_net_BroadcastBounty");
				net.WriteTable(bountyBoard);
				net.Broadcast();
				break;
			end
		end
	end)
end)

net.Receive("VANILLABOUNTY_net_ClaimBounty", function( len, ply )
	local index = net.ReadUInt(6);

	if (bountyBoard[index].target == ply) then
		net.Start("VANILLABOUNTY_net_FauxComms");
		net.WriteString("No, " .. ply:Nick() .. ". I won't let you claim a hit on yourself.");
		net.Broadcast();
		return;
	end

	local ban = false;
	for _, v in ipairs(bountyBoard[index].banned) do
		if v == ply then
			ban = true;

			net.Start("VANILLABOUNTY_net_PrettyText");
			net.WriteString("For various reasons, you are restricted from claiming this case.");
			net.Send(ply);

			break;
		end
	end

	if ban then return end

	//unclaim
	local found = false;
	for k, v in ipairs(bountyBoard[index].hunters) do
		if v == ply then
			table.remove(bountyBoard[index].hunters, k);
			found = true;

			if table.IsEmpty(bountyBoard[index].hunters) and timer.Exists("VANILLABOUNTY_timer_DepressedClient_" .. v.id) then
				timer.Start("VANILLABOUNTY_timer_DepressedClient_" .. v.id);
			end

			break;
		end
	end

	if found then return end

	//claim
	bountyBoard[index].hunters[#bountyBoard[index].hunters + 1] = ply;

	net.Start("VANILLABOUNTY_net_FauxComms");
	net.WriteString("Copy that, " .. ply:Nick() .. ". You have been assigned to: HIT-" .. tostring(bit.tohex(bountyBoard[index].id)) .. ". Good luck.");
	net.Broadcast();

end)

//bounty logic
hook.Add("PlayerDeath", "VANILLABOUNTY_hook_PlayerDeath", function(ply, inflictor, attacker)
	//for every bounty, if the player who died is a target
	for k, v in ipairs(bountyBoard) do
		if v.target == ply then
			//check if the player died to a hunter
			local hunted = false;
			for _, p in ipairs(v.hunters) do
				if IsValid(p) and p == attacker then
					attacker:SH_AddPremiumPoints(v.reward, nil, false, false);

					net.Start("VANILLABOUNTY_net_FauxComms");
					net.WriteString("Good work, " .. attacker:Nick() .. ". Hit complete, transmitting credits now.");
					net.Broadcast();

					//create a timer for target cooldown
					ply:SetVar("VANILLABOUNTY_var_Cooldown", true);
					timer.Create("VANILLABOUNTY_timer_Cooldown_" .. ply:SteamID(), 1800, 1, function()
						if not IsValid(ply) then return end //fuck you linter
						ply:SetVar("VANILLABOUNTY_var_Cooldown", false);
					end)

					//remove from bountyboard + cleanup timer
					table.remove(bountyBoard, k);
					if timer.Exists("VANILLABOUNTY_timer_DepressedClient_" .. v.id) then
						timer.Stop("VANILLABOUNTY_timer_DepressedClient_" .. v.id);
					end

					net.Start("VANILLABOUNTY_net_BroadcastBounty");
					net.WriteTable(bountyBoard);
					net.Broadcast();

					hunted = true;
				end
			end

			if not hunted and ply != attacker then
				net.Start("VANILLABOUNTY_net_FauxComms");
				net.WriteString("Hunters, it seems that " .. ply:Nick() .. " has died of some other means. Since none of you managed to kill them, I'll keep the credits for myself.");
				net.Broadcast();

				//remove from bountyboard + cleanup timer
				table.remove(bountyBoard, k);
				if timer.Exists("VANILLABOUNTY_timer_DepressedClient_" .. v.id) then
					timer.Remove("VANILLABOUNTY_timer_DepressedClient_" .. v.id);
				end

				//create a timer for target cooldown
				ply:SetVar("VANILLABOUNTY_var_Cooldown", true);
				timer.Create("VANILLABOUNTY_timer_Cooldown_" .. ply:SteamID(), 1800, 1, function()
					if not IsValid(ply) then return end
					ply:SetVar("VANILLABOUNTY_var_Cooldown", false);
				end)

				net.Start("VANILLABOUNTY_net_BroadcastBounty");
				net.WriteTable(bountyBoard);
				net.Broadcast();
			end
		end

		// instead, if its a bounty hunter assigned to this case that died.
		for k2, j in ipairs(v.hunters) do
			if IsValid(j) and j == ply then
				//remove them from the boutny and ban them from claiming again
				table.remove(v.hunters, k2);
				v.banned[#v.banned + 1] = j;

				net.Start("VANILLABOUNTY_net_FauxComms");
				net.WriteString(j:Nick() .. " has flatlined. Failing the bounty, for them atleast.");
				net.Broadcast();

				net.Start("VANILLABOUNTY_net_BroadcastBounty");
				net.WriteTable(bountyBoard);
				net.Broadcast();

				if table.Empty(v.hunters) and timer.Exists("VANILLABOUNTY_timer_DepressedClient_" .. v.id) then
					timer.Start("VANILLABOUNTY_timer_DepressedClient_" .. v.id);
				end
			end
		end
	end
end)

//insurance
timer.Create("VANILLABOUNTY_timer_Insurance", 300, 0, function()
	local found = false;
	for _, v in ipairs(player.GetAll()) do
		if v:GetRegiment() == "Bounty Hunter" then
			found = true;
			break; //break to save performance cuz we only really need to find one
		end
	end

	//if no bounty hunters r online anymore then give all the credits back to the poor poor clients
	if not found then
		for k, v in ipairs(bountyBoard) do
			if not IsValid(v.owner) then return end

			v.owner:SH_AddPremiumPoints(v.reward - (v.reward * 0.1), nil, false, false);

			net.Start("VANILLABOUNTY_net_PrettyText");
			net.WriteString("I have returned your credits as no Bounty Hunters are currently at your location.");
			net.Send(v.owner);

			table.remove(bountyBoard, k);
		end

		net.Start("VANILLABOUNTY_net_BroadcastBounty");
		net.WriteTable(bountyBoard);
		net.Broadcast();
	end
end)

//leave
timer.Create("VANILLABOUNTY_timer_Leave", 0, 0, function()
	for k, v in ipairs(bountyBoard) do
		if not IsValid(v.target) then
			table.remove(bountyBoard, k);

			if IsValid(v.owner) then
				v.owner:SH_AddPremiumPoints(v.reward, nil, false, false);

				net.Start("VANILLABOUNTY_net_PrettyText");
				net.WriteString("I have returned your credits as the target has left the locale.");
				net.Send(v.owner);
			end

			net.Start("VANILLABOUNTY_net_FauxComms");
			net.WriteString("Hunters, it seems that a target has left the locale. Cancelling that bounty.");
			net.Broadcast();
		end
	end
end)

net.Receive("VANILLABOUNTY_net_LoginBroadcast", function( len, ply )
	net.Start("VANILLABOUNTY_net_BroadcastBounty");
	net.WriteTable(bountyBoard);
	net.Send(ply);
end)