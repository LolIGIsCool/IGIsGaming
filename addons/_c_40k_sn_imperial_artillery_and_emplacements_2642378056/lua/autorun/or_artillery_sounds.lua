game.AddParticles( "particles/incendiary_shells.pcf" )
PrecacheParticleSystem( "incendiary_1_final" )
PrecacheParticleSystem( "incendiary_2_final" )

sound.Add( {
	name = "artillery_basilisk_shot",
	channel = CHAN_STATIC,
	volume = 1,
	level = 140,
	pitch = { 90, 110 },
	sound = { "ordoredactus/artillery/basilisk_shot_1.wav", "ordoredactus/artillery/basilisk_shot_2.wav", "ordoredactus/artillery/basilisk_shot_3.wav" }
} )

sound.Add( {
	name = "artillery_explosion_1",
	channel = CHAN_STATIC,
	volume = 0.6,
	level = 120,
	pitch = { 120, 150 },
	sound = { "ordoredactus/artillery/artillery_explosion_1.wav" }
} )

sound.Add( {
	name = "artillery_medusa_shot",
	channel = CHAN_STATIC,
	volume = 1,
	level = 140,
	pitch = { 90, 110 },
	sound = { "ordoredactus/artillery/medusa_shot.wav" }
} )

sound.Add( {
	name = "artillery_explosion_2",
	channel = CHAN_STATIC,
	volume = 1,
	level = 130,
	pitch = { 60, 80 },
	sound = { "ordoredactus/artillery/artillery_explosion_1.wav" }
} )

sound.Add( {
	name = "artillery_cannon_clang",
	channel = CHAN_STATIC,
	volume = 1,
	level = 140,
	pitch = { 90, 110 },
	sound = { "ordoredactus/artillery/cannon_clang_1.wav", "ordoredactus/artillery/cannon_clang_2.wav" }
} )

sound.Add( {
	name = "artillery_basilisk_incoming",
	channel = CHAN_STATIC,
	volume = 1,
	level = 120,
	pitch = { 100, 100 },
	sound = { "ordoredactus/artillery/artillery_incoming_1.wav", "ordoredactus/artillery/artillery_incoming_2.wav", "ordoredactus/artillery/artillery_incoming_3.wav" }
} )

sound.Add( {
	name = "artillery_medusa_incoming",
	channel = CHAN_STATIC,
	volume = 1,
	level = 120,
	pitch = { 60, 70 },
	sound = { "ordoredactus/artillery/artillery_incoming_1.wav", "ordoredactus/artillery/artillery_incoming_2.wav", "ordoredactus/artillery/artillery_incoming_3.wav" }
} )

sound.Add( {
	name = "artillery_cannon_reload",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 80,
	pitch = { 100, 120 },
	sound = { "ordoredactus/artillery/cannon_reload.wav" }
} )

sound.Add( {
	name = "artillery_incendiary_fire",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = 100,
	sound = { "ordoredactus/artillery/incendiary_fire.wav" }
} )


