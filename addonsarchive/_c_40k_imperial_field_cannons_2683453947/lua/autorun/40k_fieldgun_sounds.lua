game.AddParticles( "particles/40k_plasma_final.pcf" )
PrecacheParticleSystem( "plasma_trail_2_glow" )
PrecacheParticleSystem( "plasma_trail_2_front" )
PrecacheParticleSystem( "plasma_trail_2_final" )

sound.Add( {
	name = "40k_fieldgun_deploy",
	channel = CHAN_STATIC,
	volume = 1,
	level = 90,
	pitch = { 90, 110 },
	sound = { "ordoredactus/wheelchairs/fieldgun_deploy.wav" }
} )

sound.Add( {
	name = "40k_fieldgun_undeploy",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = { 90, 110 },
	sound = { "ordoredactus/wheelchairs/fieldgun_undeploy.wav" }
} )

sound.Add( {
	name = "fieldgun_fieldcannon",
	channel = CHAN_STATIC,
	volume = 1,
	level = 150,
	pitch = { 90, 110 },
	sound = { "^ordoredactus/wheelchairs/fieldcannon_fire.wav" }
} )

sound.Add( {
	name = "fieldgun_fieldcannon_reload",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = { 90, 110 },
	sound = { "ordoredactus/wheelchairs/fieldcannon_reload.wav" }
} )

sound.Add( {
	name = "fieldgun_autocannon",
	channel = CHAN_STATIC,
	volume = 1,
	level = 110,
	pitch = { 120, 130 },
	sound = { "ordoredactus/wheelchairs/autocannon_fire.wav" }
} )

sound.Add( {
	name = "fieldgun_assaultcannon",
	channel = CHAN_STATIC,
	volume = 1,
	level = 150,
	pitch = { 90, 100 },
	sound = { "^ordoredactus/wheelchairs/assaultcannon_fire.wav" }
} )

sound.Add( {
	name = "fieldgun_bolter",
	channel = CHAN_STATIC,
	volume = 1,
	level = 150,
	pitch = { 90, 100 },
	sound = "^ordoredactus/wheelchairs/bolter2.wav"
} )

sound.Add( {
	name = "fieldgun_bolter_reload",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = { 90, 110 },
	sound = { "ordoredactus/wheelchairs/fieldgun_bolter_reload.wav" }
} )

sound.Add( {
	name = "fieldgun_multilaser",
	channel = CHAN_STATIC,
	volume = 0.4,
	level = 90,
	pitch = { 160, 170 },
	sound = { "ordoredactus/wheelchairs/multilaser_fire.wav" }
} )

sound.Add( {
	name = "fieldgun_lascannon_fire",
	channel = CHAN_STATIC,
	volume = 1,
	level = 110,
	pitch = { 100, 100 },
	sound = { "ordoredactus/wheelchairs/fieldgun_lascannon_fire.wav" }
} )

sound.Add( {
	name = "fieldgun_lascannon_reload",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = { 100, 100 },
	sound = { "ordoredactus/wheelchairs/fieldgun_lascannon_reload.wav" }
} )

sound.Add( {
	name = "fieldgun_plasmacannon",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = {"ordoredactus/wheelchairs/vehicle_plasmacannon_1.wav","ordoredactus/wheelchairs/vehicle_plasmacannon_2.wav"}
} )

sound.Add( {
	name = "fieldgun_plasmacannon_powerdown",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = {"ordoredactus/wheelchairs/vehicle_plasmacannon_powerdown.wav"}
} )

sound.Add( {
	name = "fieldgun_plasmacannon_charge",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = {"ordoredactus/wheelchairs/vehicle_plasmacannon_charge.wav"}
} )

sound.Add( {
	name = "fieldgun_plasmacannon_overcharge",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = {"ordoredactus/wheelchairs/vehicle_plasmacannon_overcharge.wav"}
} )

sound.Add( {
	name = "fieldgun_plasmacannon_reload",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = {"ordoredactus/wheelchairs/vehicle_plasmacannon_reload.wav"}
} )

sound.Add( {
	name = "fieldgun_plasmacannon_energy",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	pitch = { 100 },
	sound = {"ordoredactus/wheelchairs/vehicle_plasmacannon_energy.wav"}
} )




