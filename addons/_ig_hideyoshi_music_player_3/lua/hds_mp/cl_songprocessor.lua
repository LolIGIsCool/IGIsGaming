hdsmp_tableOfigmodaudio = {}

function processSong_cl()
    local self = net.ReadEntity()
    local isExternal = net.ReadBool()
    local query = net.ReadString()
    local flags = net.ReadString()
    local songName = net.ReadString()
    local volume = net.ReadInt(11)
    local globalcheckStart, globalcheckEnd = string.find( flags:lower(), "3d" )
	if (globalcheckStart) then
        local soundDistance net.ReadInt(15)
    end

    if (IsValid( frameMuse ) and frameMuse:IsVisible()) then
        hdsmp_renderQueuePanel()
    end

    --print(IsValid(self) and IsValid(flags) and IsValid(query))
    if(IsValid(self) and flags ~= nil and query ~= nil) then
        if (self.mp_thinkFunction == nil) then
            self.mp_thinkFunction = {}
        end

        if (self.sw_station) then
            self.sw_station:Stop()
        end
        self.curSongName = songName

        self.sw_station = nil
        if (isExternal) then
            sound.PlayURL(query, flags, function(station) 
                playSong_cl(station, volume, globalcheckStart, soundDistance or nil, self); 
            end)
        else 
            sound.PlayFile("sound/"..query, flags, function(station)
                playSong_cl(station, volume, globalcheckStart, soundDistance or nil, self); 
            end)
        end
    end
end

function playSong_cl(station, volume, isnotGlobal, soundDistance, self)
    if ( IsValid( station ) ) then
        table.insert(hdsmp_tableOfigmodaudio, station)

		station:SetPos( self:GetPos() )
        if (GetConVar("hdsmp_clientVolumePersistance"):GetBool() == true and GetConVar("hdsmp_clientVolumeSetting"):GetInt() ~= -1) then
            station:SetVolume(GetConVar("hdsmp_clientVolumeSetting"):GetInt()/100)
        else
            GetConVar("hdsmp_clientVolumeSetting"):SetInt(volume)
            station:SetVolume(volume/100)
        end

        if (isnotGlobal && soundDistance) then
            station:Set3DFadeDistance(200, soundDistance)
        end

		station:Play()

		-- Keep a reference to the audio object, so it doesn't get garbage collected which will stop the sound
		self.sw_station = station

        self.queueMovemenetDelay = RealTime() + 2 -- Give some time for them music player to play the music before letting queue proceed

        function self:Think()
            if (self.sw_station) then
                self.sw_station:SetPos(self:GetPos())
            end

            if (self.isProcessing == true and IsValid(self.sw_station) and self.sw_station:GetState() == 1) then
                self.isProcessing = false
            end

            --[[if (IsValid(self.sw_station) and self.sw_station:GetState() == 0) then
                self.curSongName = nil
                self.sw_station = nil
            end]]--

        
            if (IsValid(self.sw_station) and self.sw_station:IsLooping() == false and self.sw_station:GetState() == 0 and RealTime() > self.queueMovemenetDelay and !self.isProcessing) then
                local queueJSON = self:GetqueueConstruct()
                local queue = util.JSONToTable(queueJSON)
                if (queue ~= nil and #queue >= 1 and self.processingSong == nil ) then
                    if (player.GetBySteamID(self:Getent_plyspawner()) == LocalPlayer()) then
   
                        self.isProcessing = true

                        local songTitle = queue[1][1]
                        local songValue = queue[1][2]
                        local isExternal = queue[1][3]
            
                        net.Start("hdsmp_pushQueue")
                            -- Push Queue
                            net.WriteInt(1, 11)
                            net.WriteInt(self:EntIndex(), 21)
                            -- Process Song
                            --[[net.WriteInt(entIndex, 21)
                            net.WriteBool(isExternal)
                            net.WriteBool(false)
                            net.WriteString(songValue)
                            net.WriteInt(100, 11)
                            net.WriteInt(200, 15)]]--
                        net.SendToServer()
            
                        --[[local queueJSON = ent:GetqueueConstruct()
                        local queue = util.JSONToTable(queueJSON)
            
                        PrintTable(queue)]]--

                    end 
                else
                    self.curSongName = nil
                    self.sw_station = nil
                end
            end
        end
	
	else

		LocalPlayer():ChatPrint( "Invalid URL!" )

	end
end

net.Receive("broadcastSongRequest", processSong_cl)