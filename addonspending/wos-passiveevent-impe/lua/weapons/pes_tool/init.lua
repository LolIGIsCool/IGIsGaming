

function SWEP:PrimaryAttack()
    return true
end

function SWEP:SecondaryAttack()
    return true
end

function SWEP:Reload()
    if !self.firstReload then
        self.firstReload = true
        wOS.PES.NetworkTriggers(self.Owner)
        wOS.PES.NetworkSubEvents(self.Owner)
    end
end
