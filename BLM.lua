---------------------------------------------------------------------------------
-- This lua is based off of the Kinematics template and uses Motenten globals. --
--                                                                             --
-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Byrne (Asura) --------------- [Author			 Primary]    --
--	  Gamergiving (Asura) --------- [movement speed conversion mechanics]    --
-- 	  Verbannt (Asura) ------------ [organization of job functions And Github updates]    --
--   
--                                                                             --
---------------------------------------------------------------------------------

	
-- This file should be treated as a work in progress, check back to The Black Sacrament Guide or Github for updates


	
	
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
 
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
     
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
 
end
 
 
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
 
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
 
-- Setup vars that are user-dependent.  Setup which sets you want to contain which sets of gear. 
-- By default my sets are: MagicBurst is bursting gear, Occult_Acumen is Conserve MP/MP return body, FreeNuke_Effect self explanatory.
-- If you're new to gearswap, the F9~12 keys and CTRL keys in combination is how you activate this stuff.

function job_setup()
    state.OffenseMode:options('None', 'Locked')
    state.CastingMode:options('MagicBurst', 'OccultAcumen', 'FreeNuke')
    state.IdleMode:options('Refresh', 'Death')
	state.VorsealMode = M('Normal', 'Vorseal')
	state.ManawallMode = M('Swaps', 'No_Swaps')
	state.Enfeebling = M('None', 'Effect')
	--Vorseal mode is handled simply when zoning into an escha zone--
    state.Moving  = M(false, "moving")
   
	lockstyleset = 200

    element_table = L{'Earth','Wind','Ice','Fire','Water','Lightning'}

    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II'}
 
    degrade_array = {
        ['Fire'] = {'Fire','Fire II','Fire III','Fire IV','Fire V','Fire VI'},
        ['Firega'] = {'Firaga','Firaga II','Firaga III','Firaja'},
        ['Ice'] = {'Blizzard','Blizzard II','Blizzard III','Blizzard IV','Blizzard V','Blizzard VI'},
        ['Icega'] = {'Blizzaga','Blizzaga II','Blizzaga III','Blizzaja'},
        ['Wind'] = {'Aero','Aero II','Aero III','Aero IV','Aero V','Aero VI'},
        ['Windga'] = {'Aeroga','Aeroga II','Aeroga III','Aeroja'},
        ['Earth'] = {'Stone','Stone II','Stone III','Stone IV','Stone V','Stone VI'},
        ['Earthga'] = {'Stonega','Stonega II','Stonega III','Stoneja'},
        ['Lightning'] = {'Thunder','Thunder II','Thunder III','Thunder IV','Thunder V','Thunder VI'},
        ['Lightningga'] = {'Thundaga','Thundaga II','Thundaga III','Thundaja'},
        ['Water'] = {'Water', 'Water II','Water III', 'Water IV','Water V','Water VI'},
        ['Waterga'] = {'Waterga','Waterga II','Waterga III','Waterja'},
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'},
        ['Sleepgas'] = {'Sleepga','Sleepga II'}
    }
	send_command('bind f10 gs c cycle IdleMode')
	send_command('bind f11 gs c cycle CastingMode')
	send_command('bind ^f11 gs c cycle Enfeebling')
	send_command('bind f12 gs c cycle ManawallMode')
    organizer_items = {aeonic="Khatvanga"}
    select_default_macro_book()
	set_lockstyle()
end
 
-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
	send_command('unbind f10')
	send_command('unbind ^`f11')
	send_command('unbind @`f11')
	send_command('unbind ^f11')
end
 
 
-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
     
    ---- Precast Sets ----
     
    -- Precast sets to enhance JAs
	
    sets.precast.JA['Mana Wall'] = {
		feet="Wicce Sabots +3",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+4','"Fast Cast"+10',}}
	}
 
    sets.precast.JA.Manafont = {body="Arch. Coat"}
     
    -- Can put HP/MP set here for convert
	
    sets.precast.JA.Convert = {}
  
    -- Base precast Fast Cast set, this set will have to show up many times in the function section of the lua
 
    sets.precast.FC = {
		ammo="Impatiens",
		head={ name="Merlinic Hood", augments={'Crit.hit rate+3','Mag. Acc.+2','"Fast Cast"+6','Accuracy+13 Attack+13','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
		body="Zendik Robe",
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+7','MND+2','Mag. Acc.+10',}},
		legs="Agwu's Slops",
		feet={ name="Merlinic Crackows", augments={'Attack+16','"Fast Cast"+6','Mag. Acc.+8',}},
		neck="Voltsurge torque",
		waist="Witful Belt",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Lebeche ring",
		right_ring="Weather. Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
		--FC cap is 80%

	sets.precast['Impact'] = {
		--main={ name="Rubicundity", augments={'Mag. Acc.+8','"Mag.Atk.Bns."+9','Dark magic skill +8','"Conserve MP"+6',}},
		--sub="Ammurapi Shield",
		ammo="Impatiens",
		head=empty,
		body="Crepuscular Cloak",
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+7','MND+2','Mag. Acc.+10',}},
		legs="Agwu's Slops",
		feet={ name="Merlinic Crackows", augments={'Attack+16','"Fast Cast"+6','Mag. Acc.+8',}},
		neck="Voltsurge torque",
		waist="Witful Belt",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Lebeche Ring",
		right_ring="Weather. Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
		--Done
	
	sets.precast.FC.HighMP = {
		ammo="Impatiens",
		head={ name="Merlinic Hood", augments={'Crit.hit rate+3','Mag. Acc.+2','"Fast Cast"+6','Accuracy+13 Attack+13','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
		body="Zendik Robe",
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+7','MND+2','Mag. Acc.+10',}},
		legs="Agwu's Slops",
		feet={ name="Merlinic Crackows", augments={'Attack+16','"Fast Cast"+6','Mag. Acc.+8',}},
		neck="Voltsurge torque",
		waist="Witful Belt",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Lebeche Ring",
		right_ring="Weather. Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
		
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC['Enfeebling Magic'] = sets.precast.FC
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {right_ear="Barkarole earring"})
    sets.precast.FC['Healing Magic'] = sets.precast.FC
 
    -- Midcast set for Death, Might as well only have one set, unless you plan on free-nuking death for some unexplainable reason.

	sets.precast['Death'] = {
		ammo="Sapience orb",
		head={ name="Amalric Coif +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		--body=Rosette jaseran +1
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		--legs=Psycloth lappas
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Voltsurge torque",
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Loquac. Earring",
		right_ear="Barkaro. Earring",
		--left_ring=Mephitas Ring +1
		right_ring="Lebeche ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
		

    sets.midcast['Death'] = {
		--main="Bunzi's Rod",
		--sub="Ammurapi Shield",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body="Wicce coat +3",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Wicce chausses +3",
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Halasz Earring",
		right_ear="Barkaro. Earring",
		--left_ring=Mephitas ring +1
		right_ring="Archon Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		--Need Mephitas ring +1 and Etoliation
 
	sets.engaged = {
		ammo="White tathlum",
		--ammo="Staunch tathlum +1",
		head={ name="Telchine Cap", augments={'Accuracy+18','"Store TP"+6','DEX+8',}},
		body="Wicce Coat +3",
		--hands={ name="Gazu Bracelets +1", augments={'Path: A',}},
		hands="Wicce gloves +3",
		legs="Jhakri Slops +2",
		feet="Battlecast Gaiters",
		neck="Marked gorget",
		waist="Patentia sash",
		left_ear="Telos Earring",
		right_ear="Crep. Earring",
		left_ring="Chirich Ring +1",
		--left_ring="Defending ring",
		right_ring="Lehko's Ring",
		back={ name="Taranus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10', 'Accuracy+10','Damage taken-5%',}},}
		--Prosilio belt +1 gives DA -5% might counteract other gear?
		
    -- Weaponskills
	sets.precast.WS = {}
	
	sets.precast.WS['Myrkr'] = {
		ammo="Hydrocera",
		head="Pixie Hairpin +1",
		body="Ea Houppe. +1",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Dualism Collar +1",
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Barkaro. Earring",
		right_ear="Mendi. Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Lebeche Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+4','"Fast Cast"+10',}},}
		--Done

	sets.precast.WS['Cataclysm'] = {
		ammo="Sroda tathlum",
		head="Pixie Hairpin +1",
		body="Wicce coat +3",
		hands="Wicce Gloves +3",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist="Orpheus's sash",
		left_ear="Ishvara Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Weapon skill damage +10%',}},}
		--Done
	
	sets.precast.WS['Earth Crusher'] = {
		ammo="Sroda tathlum",
		head="Wicce Petasos +3",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Quanpur necklace",
		waist="Orpheus's sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Vidohunir'] = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist="Orpheus's sash",
		left_ear="Malignance Earring",
		right_ear="Barkaro. Earring", --can replace with Regal earring
		left_ring="Epaminondas's ring",
		right_ring="Freke Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Shattersoul'] = {}
	
	sets.precast.WS['Retribution'] = {
		ammo="Oshasha's Treatise",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Rep. Plat. medal",
		waist="Prosilio belt +1",
		left_ear="Ishvara earring",
		right_ear="Malignance earring",
		left_ring="Epaminondas's ring",
		right_ring="Ifrit ring +1",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Weapon skill damage +10%',}},}
			
    ---- Midcast Sets ----
    sets.midcast.FastRecast = {}
 
    sets.midcast['Healing Magic'] = {
		ammo="Hydrocera",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body={ name="Vanya Robe", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		hands={ name="Vanya Cuffs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		legs="Gyve Trousers",
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
		neck="Incanter's torque",
		waist="Bishop's Sash",
		left_ear="Mendi. Earring",
		right_ear="Malignance Earring",
		left_ring="Lebeche Ring",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}

    sets.midcast['Enhancing Magic'] = {
		main="Bolelabunga",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +9',}},
		body={ name="Telchine Chas.", augments={'"Conserve MP"+4','Enh. Mag. eff. dur. +7',}},
		hands={ name="Telchine Gloves", augments={'"Conserve MP"+3','Enh. Mag. eff. dur. +7',}},
		legs={ name="Telchine Braconi", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +8',}},
		feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +9',}},
		neck="Elite Royal Collar",
		waist="Austerity Belt +1",
		left_ear="Calamitous Earring",
		right_ear="Earthcry Earring",
		left_ring="Defending Ring",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		--Done
	
	-- I personally do not have gear to alter these abilities as of the time of disseminating this file, but 
	-- definitely add them here if you have them.

	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {feet="Inspirited Boots",waist="Gishdubar Sash"})
	
    sets.midcast.Haste = set_combine(sets.midcast['Enhancing Magic'], {})
	
    sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {})
	
    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Sneak = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Invisible = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Firestorm = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Rainstorm = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Sandstorm = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Windstorm = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Hailstorm = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Thunderstorm = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Voidstorm = set_combine(sets.midcast['Enhancing Magic'], {})
	
	sets.midcast.Aurorastorm = set_combine(sets.midcast['Enhancing Magic'], {})
	
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Siegel Sash",
		neck="Stone Gorget",
		hands="Telchine Gloves",
		legs="Haven hose",
		ear2="Earthcry Earring"})
 
    sets.midcast['Enfeebling Magic'] = {
		--main={ name="Laevateinn", augments={'Path: A',}},
		--sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head=empty,
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands="Regal cuffs",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Kishar Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
	
    sets.midcast['Enfeebling Magic'].Effect = set_combine(sets.midcast['Enfeebling Magic'],{
		ammo="Pemphredo Tathlum",
		head=empty,
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands="Regal cuffs",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Kishar Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},})

	sets.midcast.ElementalEnfeeble = sets.midcast['Enfeebling Magic']
 
    sets.midcast['Dark Magic'] = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
		body="Wicce Coat +3",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Freke Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}},}
		--Done for now but could be optimized
 
    -- Elemental Magic sets
		-- Magic Burst 
    sets.midcast['Elemental Magic'] = {
		main={ name="Laevateinn", augments={'Path: A',}},
		sub="Enki Strap",
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
		body="Wicce Coat +3",
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}},}
		--40% MB cap
		--51% MB; 27% MBII
		
		--Wicce coat +3 provides MBII +5
		--Agwu's gages provide MB +8, MBII +6
		--New total would be MB +50, MBII +23

    sets.midcast['Elemental Magic'].FreeNuke = set_combine(sets.midcast['Elemental Magic'], {
		main={ name="Laevateinn", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Sroda tathlum",
		--ammo="Staunch tathlum +1",
		head="Wicce petasos +3",
		body="Spaekona's Coat +3",
		hands="Wicce Gloves +3",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		--waist="Orpheus's sash",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		--right_ear="Halasz earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Freke Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}},})
		--Done
		--test out Mephitas ring +1 for additional +15 Conserve MP
		--if so, replace tathlum with Pemphredo tathlum for additional +4 Conserve MP
		--with traits and above gear, Conserve MP procs 50% of the time
		
		
    sets.midcast['Elemental Magic'].OccultAcumen = {
		ammo="Seraphic Ampulla",
		head="Mall. Chapeau +2",
		body={ name="Merlinic Jubbah", augments={'"Occult Acumen"+11','"Mag.Atk.Bns."+10',}},
		hands={ name="Merlinic Dastanas", augments={'"Occult Acumen"+11','MND+8','Mag. Acc.+7',}},
		legs="Perdition Slops",
		feet={ name="Merlinic Crackows", augments={'"Occult Acumen"+10','Mag. Acc.+1','"Mag.Atk.Bns."+10',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist="Oneiros Rope",
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Crepuscular Ring",
		right_ring="Lehko's Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Store TP"+10',}},}
		
    sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {})
	
    sets.midcast['Elemental Magic'].HighTierNuke.FreeNuke = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {
		main={ name="Laevateinn", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Sroda tathlum",
		--ammo="Staunch tathlum +1",
		head="Wicce petasos +3",
		body="Spaekona's Coat +3",
		hands="Wicce Gloves +3",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		--waist="Orpheus's sash",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Barkaro. Earring",
		--right_ear="Halasz earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Freke Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}},})
	
    sets.midcast['Elemental Magic'].HighTierNuke.OccultAcumen = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {
		ammo="Seraphic Ampulla",
		head="Mall. Chapeau +2",
		body={ name="Merlinic Jubbah", augments={'"Occult Acumen"+11','"Mag.Atk.Bns."+10',}},
		hands={ name="Merlinic Dastanas", augments={'"Occult Acumen"+11','MND+8','Mag. Acc.+7',}},
		legs="Perdition Slops",
		feet={ name="Merlinic Crackows", augments={'"Occult Acumen"+10','Mag. Acc.+1','"Mag.Atk.Bns."+10',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist="Oneiros Rope",
		left_ear="Dedition Earring",
		right_ear="Telos Earring",
		left_ring="Crepuscular Ring",
		right_ring="Lehko's Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Store TP"+10',}},})
	
	sets.midcast['Elemental Magic'].SIRD = {
		ammo="Staunch tathlum +1",
		head="Wicce petasos +3",
		--head="Agwu's cap", --add augs
		--body="Rosette jaseran +1" --add augs
		body="Spaekona's Coat +3", --for better MP management
		hands="Wicce gloves +3",
		legs="Wicce chausses +3",
		--legs="Lengo pants", --add augs (SR)
		feet={ name="Agwu's pigaches", augments={'Path: A',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist="Emphatikos rope",
		left_ear="Malignance Earring",
		right_ear="Halasz earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}},}
		--78% Spell Interruption Rate Down with Spaekona's coat +3
		--103% Spell Interruption Rate Down with Rosette jaseran +1
		
 	sets.midcast['Burn'] = {
		ammo="Pemphredo Tathlum",
		head="Wicce Petasos +3",
		body="Spaekona's Coat +3",
		hands="Spae. Gloves +3",
		legs={ name="Arch. Tonban +3", augments={'Increases Elemental Magic debuff time and potency',}},
		feet={ name="Arch. Sabots +3", augments={'Increases Aspir absorption amount',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
    sets.midcast['Impact'] = {
		--main={ name="Rubicundity", augments={'Mag. Acc.+8','"Mag.Atk.Bns."+9','Dark magic skill +8','"Conserve MP"+6',}},
		--sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head=empty,
		body="Crepuscular Cloak",
		hands="Spae. Gloves +3",
		legs={ name="Arch. Tonban +3", augments={'Increases Elemental Magic debuff time and potency',}},
		feet={ name="Arch. Sabots +3", augments={'Increases Aspir absorption amount',}},
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		--Done
	
	sets.midcast['Aspir III'] = set_combine(sets.midcast['Dark Magic'],{
		--main={ name="Rubicundity", augments={'Mag. Acc.+8','"Mag.Atk.Bns."+9','Dark magic skill +8','"Conserve MP"+6',}},
		--sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body="Shango Robe",
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+29','"Drain" and "Aspir" potency +11','MND+7',}},
		legs="Wicce Chausses +3",
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Hirudinea Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},})
	
	sets.midcast['Drain'] = set_combine(sets.midcast['Dark Magic'],{
		--main={ name="Rubicundity", augments={'Mag. Acc.+8','"Mag.Atk.Bns."+9','Dark magic skill +8','"Conserve MP"+6',}},
		--sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body="Shango Robe",
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+29','"Drain" and "Aspir" potency +11','MND+7',}},
		legs="Wicce Chausses +3",
		feet={ name="Agwu's Pigaches", augments={'Path: A',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Hirudinea Earring",
		right_ear={ name="Wicce Earring +1", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+14','Enmity-4',}},
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},})
		
	sets.midcast['Stun'] = set_combine(sets.midcast['Dark Magic'], {
		ammo="Sapience orb",
		head="Wicce petasos +3",
		body="Wicce coat +3",
		--hands="Arch. gloves +3",
		--legs="Spae. tonban +3",
		feet="Wicce sabots +3",
		--neck="Unmoving collar +1", --add augs
		--waist="Goading belt",
		--left_ear="Incubus earring +1",
		--right_ear="Cryptic earring",
		left_ring="Eihwaz ring",
		right_ring="Supershear ring",
		--back= JSE cape w/ enmity
		})
	
	sets.midcast['Comet'] = set_combine(sets.midcast['Elemental Magic'], {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
		body="Wicce Coat +3",
		hands="Wicce Gloves +3",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Barkaro. Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Archon ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}},})
		
	sets.midcast['Comet'].FreeNuke = set_combine(sets.midcast['Elemental Magic'], {
		ammo="Sroda tathlum",
		head="Pixie Hairpin +1",
		body="Spaekona's Coat +3",
		hands="Wicce Gloves +3",
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Barkaro. Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Archon ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Damage taken-5%',}},})
	
-- These next two sets are used later in the functions to determine what gear will be used in High MP and Low MP situations
-- SPECIFICALLY for Aspir spells.  In the LowMP set, put your best Aspir+ gear, in the other set put your best Max MP gear.
-- Find out how much your maximum MP is in each set, and adjust the MP values in the function area accordingly
-- (CTRL+F: Aspir Handling)

	--sets.midcast.HighMP = {
		--main="Bunzi's Rod",
		--sub="Ammurapi Shield",
		--ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		--head="Pixie Hairpin +1",
		--body="Ea Houppe. +1",
		--hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		--legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		--feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		--neck="Sanctity Necklace",
		--waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		--left_ear="Flashward Earring",
		--right_ear="Barkaro. Earring",
		--left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		--right_ring="Archon Ring",
		--back={ name="Aurist's Cape +1", augments={'Path: A',}},}
 
	--sets.midcast.LowMP = {
		--main={ name="Rubicundity", augments={'Mag. Acc.+8','"Mag.Atk.Bns."+9','Dark magic skill +8','"Conserve MP"+6',}},
		--sub="Ammurapi Shield",
		--ammo="Pemphredo Tathlum",
		--head="Pixie Hairpin +1",
		--body="Shango Robe",
		--hands="Wicce Gloves +2",
		--legs="Wicce Chausses +2",
		--feet="Agwu's Pigaches",
		--neck="Erra Pendant",
		--waist="Fucho-no-Obi",
		--left_ear="Calamitous Earring",
		--right_ear="Halasz Earring",
		--left_ring="Evanescence Ring",
		--right_ring="Archon Ring",
		--back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		
    --Set to be equipped when Day/Weather match current spell element

	sets.Obi = {waist="Hachirin-no-Obi",}
	
	sets.Quanpur = {neck="Quanpur Necklace",}
 
	sets.Osash = {waist="Orpheus's sash",}
 
    -- Resting sets
	
    sets.resting = {}
 
    -- Idle sets: Make general idle set a max MP set, later hooks will handle the rest of your refresh sets, but
	-- remember to alter the refresh sets (Ctrl+F to find them)

    sets.idle = {
		main={ name="Laevateinn", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Staunch Tathlum +1",
		head={ name="Merlinic Hood", augments={'INT+1','Attack+10','"Refresh"+2','Accuracy+18 Attack+18','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
		body="Wicce coat +3", --refresh +4
		hands={ name="Merlinic Dastanas", augments={'Magic burst dmg.+10%','STR+10','"Refresh"+2','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		--refresh +2
		legs="Assiduity pants +1", --refresh +1~2
		feet="Volte gaiters", --refresh +1
		neck="Sibyl Scarf", --refresh +1
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Halasz Earring", 
		right_ear="Loquac. Earring",
		left_ring="Stikini Ring +1", --refresh +1
		right_ring="Stikini Ring +1", --refresh +1
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+4','"Fast Cast"+10',}},
		}
 
	 --Melee set
	 sets.idle.Melee = {
		ammo="Amar Cluster",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Gazu Bracelets +1", augments={'Path: A',}},
		legs="Wicce Chausses +3",
		feet="Wicce Sabots +3",
		neck="Chrys. torque",
		waist="Grunfeld Rope",
		left_ear="Telos Earring",
		right_ear="Mache Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Lehko's Ring",
		back={ name="Taranus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Accuracy+10','Damage taken-5%',}},}
	 
    sets.Adoulin = {body="Councilor's Garb",}

    sets.MoveSpeed = {feet = "Herald's Gaiters",}
 
    -- Set for Conserve MP toggle, convert damage to MP body.
	
    sets.AFBody = {body="Spaekona's Coat +3", right_ear="Regal Earring"}
 
    sets.Kiting = {feet="Herald's Gaiters"}
	
	sets.latent_refresh = {waist="Fucho-no-Obi"}
	
	sets.auto_refresh = {
		main={ name="Laevateinn", augments={'Path: A',}},
		sub="Khonsu",
		ammo="Staunch Tathlum +1",
		head={ name="Merlinic Hood", augments={'INT+1','Attack+10','"Refresh"+2','Accuracy+18 Attack+18','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
		body="Wicce coat +3", --refresh +4
		hands={ name="Merlinic Dastanas", augments={'Magic burst dmg.+10%','STR+10','"Refresh"+2','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		--refresh +2
		legs="Assiduity pants +1", --refresh +1~2
		feet="Volte gaiters", --refresh +1
		neck="Sibyl Scarf", --refresh +1
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Halasz Earring", 
		right_ear="Loquac. Earring",
		left_ring="Stikini Ring +1", --refresh +1
		right_ring="Stikini Ring +1", --refresh +1
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
		}
		--12-13 refresh
	
	sets.idle.Death = {
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Wicce petasos +3",
		--body="Ros. Jaseran +1,
		--hands=
		--legs=
		feet="Wicce sabots +3",
		neck="Sanctity necklace",
		waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
		left_ear="Halasz Earring",
		right_ear="Barkaro. Earring",
		--left_ring=Mephitas ring +1
		right_ring="Stikini Ring +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},
		}
	
    -- Mana Wall idle set

    sets.buff['Mana Wall'] = {
		main="Archmage's Staff",
		sub="Oneiros grip",
		ammo="Staunch Tathlum +1",
		head="Wicce petasos +3",
		body="Wicce coat +3",
		hands="Wicce gloves +3",
		legs="Wicce chausses +3",
		feet="Wicce Sabots +3",
		neck="Unmoving collar +1", --export augments
		waist="Platinum moogle belt",
		left_ear="Hearty Earring",
		right_ear="Eabani Earring",
		left_ring="Supershear Ring",
		right_ring="Defending Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10',}},}
		--50% -DT Cap
			--13% from Wicce Gloves +3
			--12% from Archmage's Staff
			--11% from Wicce Petasos +3
			--11% from Wicce Sabots +3
			--3% from Platinum moogle belt
			
			--look into Ethereal Earring for "converts damage taken to MP" attribute
		
		--95% Mana Wall Cap
			--50% default
			--25% from Wicce Sabots +3
			--10% from JSE Cape
			--20% from Archmage's Staff
		
		--look into getting Ethereal Earring (3% of damage to MP)
		
	sets.midcast.Cure = {
		ammo="Hydrocera",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body={ name="Vanya Robe", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		hands={ name="Agwu's Gages", augments={'Path: A',}},
		legs="Gyve Trousers",
		feet="Skaoi Boots",
		neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist="Bishop's Sash",
		left_ear="Malignance Earring",
		right_ear="Mendi. Earring",
		left_ring="Defending Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Taranus's Cape", augments={'MND+20','"Cure" potency +10%',}},
		}
		--Cure Potency caps at 50%
		--CP 
		
	sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {waist="Gishdubar Sash"})
    
	sets.midcast.Geomancy = {
		ammo="Pemphredo tathlum",
		head="Hike Khat +1",
		body="Vedic Coat",
		hands="Shrieker's Cuffs",
		legs="Vanya slops", --export for augs
		feet="Medium's Sabots", --export for augs
		neck="Incanter's Torque",
		waist="Kobo Obi",
		left_ear="Gna Earring",
		right_ear="Fulla Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},}
		--Additional +88 combined handbell & geomancy skill, additional 45% Conserve MP
	
end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
 
--- Define MP and buff specific Fast Cast and Midcast sets for conservation of MP for death sets, most will be
--- handled on thier own. What you need to change is the player.mp value to match slightly under what your max
--- MP is in your standard fast cast set. The set is designed to Dynamically switch fast cast sets to sets that
--- preserve your MP total if you are above the amount at which equiping your standard set would decrease your
--- maximum MP. Due to a rework in how these arguments are organised, all gearsets are being handled above the
--- function block for this file.
 
function job_precast(spell, action, spellMap, eventArgs)
    enable('feet','back')	
	if spell.english == "Impact" then
		sets.precast.FC = sets.precast['Impact']
	elseif spell.english == 'Vidohunir' then
		if world.day_element == 'Dark' or world.weather_element == 'Dark' then
		equip(set_combine(sets.Vidohunir,{waist="Hachirin-no-Obi"}))
		end
	elseif spell.english == 'Earth Crusher' then
		if world.day_element == 'Earth' or world.weather_element == 'Earth' then
		equip(set_combine(sets.EarthCrusher,{waist="Hachirin-no-Obi"}))
		end
	elseif spell.english == 'Cataclysm' then
		if world.day_element == 'Dark' or world.weather_element == 'Dark' then
		equip(set_combine(sets.Cataclysm,{waist="Hachirin-no-Obi"}))
		end
	end	
end

--function job_post_precast(spell, action, spellMap, eventArgs)
	--if player.status == 'Engaged' and player.tp == 3000 then
		--equip({head="Chrys. torque"})
	--end
--end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

	
	if spell.english == 'Jettatura' or spell.english == 'Geist Wall' 
	or spell.english == 'Soporific' or spell.english == 'Blank Gaze' 
	or spell.english == 'Sheep Song' or spell.english == 'Chaotic Eye' 
	or spell.english == 'Cursed Sphere' or spell.english == 'Flash' then
	equip(sets.midcast.Flash)
	end
	
    if spell.english == 'Death' then
        equip(sets.midcast['Death'])
	end
	
	if spell.english == "Impact" then
        equip({head=empty,body="Crepuscular Cloak"})
    end
	
end


-- Aspir Handling
 
-- This section is for you to define at what value your Aspir sets will change. This is to let your aspirs
-- get you into your death idle and higher MP values. This number should be around 100 MP lower than the
-- Fast cast argument above this to prevent looping. The intent is to ensure that if you use aspir while you
-- are already above a value defined in this section then it will put on your highest MP set, capping you off
-- rather than simply capping you to whatever your Aspir potency set's max MP value happens to be.

function job_post_midcast(spell, action, spellMap, eventArgs)
	
	if (spell.skill == 'Elemental Magic' or spell.skill == 'Healing Magic') and (spell.element == world.weather_element or spell.element == world.day_element) then
        equip(sets.Obi)
	end
	
	if spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and state.VorsealMode.value == 'Vorseal' and player.mp > 1765 then
		equip(sets.midcast.HighMP)
	elseif spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and state.VorsealMode.value == 'Vorseal' and player.mp < 1765 then
		equip(sets.midcast.LowMP)
	elseif spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and state.VorsealMode.value == 'Normal' and player.mp > 1580 then
		equip(sets.midcast.HighMP)
	elseif spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and state.VorsealMode.value == 'Normal' and player.mp < 1580 then
		equip(sets.midcast.LowMP)
	end
	
    if spell.element == world.day_element or spell.element == world.weather_element then
        if string.find(spell.english,'helix') then
            equip(sets.midcast.Helix)
        else 
            equip(sets.Obi)
        end
    end
	
	if spell.english == 'Stoneja' or spell.english == 'Stone VI' or spell.english == 'Stone V' or spell.english == 'Stone IV' then
		equip(sets.Quanpur)
	end
	
	if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' and (player.mp-spell.mp_cost) < 436 then
		equip(sets.AFBody)
	end
	
	if spell.skill == 'Enfeebling Magic' and state.Enfeebling.Value == 'Effect' then
		equip(sets.midcast['Enfeebling Magic'].Effect)
	end
	
	if spell.skill == 'Elemental Magic' and (string.find(spell.english,'ga') or string.find(spell.english,'ja') or string.find(spell.english,'ra')) then
            equip(sets.AFBody)
	end
	
	if spellMap == 'Cure' and state.ManawallMode.Value == 'No_Swaps' then
		equip(sets.midcast.Mana_Wall_No_Swap)
	elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
	end
	
	if spell.skill == 'Enhancing Magic' and state.ManawallMode.Value == 'No_Swaps' then
		equip(sets.midcast.Mana_Wall_No_Swap)
	end
end
 
-- Duration arguments
-- Below you can include wait inputs for all spells that you are interested in having timers for
-- For the sake of brevity, I've only included crowd control spells into this list, but following
-- the same general format you should be able to intuitively include whatever you like.
 
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    if buffactive['Mana Wall'] then
        enable('feet','back')
        equip(sets.buff['Mana Wall'])
        disable('feet','back')
    end
	
    if not spell.interrupted then
        if spell.english == "Sleep II" or spell.english == "Sleepga II" then -- Sleep II Countdown --
            send_command('wait 60;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('wait 30;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Break" or spell.english == "Breakga" then -- Break Countdown --
            send_command('wait 25;input /echo Break Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Paralyze" then -- Paralyze Countdown --
             send_command('wait 115;input /echo Paralyze Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Slow" then -- Slow Countdown --
            send_command('wait 115;input /echo Slow Effect: [WEARING OFF IN 5 SEC.]')        
        end
    end
	--if buffactive['poison'] then
	--send_command('input /item "antidote" <me>')
	--end
end
 
function nuke(spell, action, spellMap, eventArgs)
    if player.target.type == 'MONSTER' then
        if state.AOE.value then
            send_command('input /ma "'..degrade_array[element_table:append('ga')][#degrade_array[element_table:append('ga')]]..'" '..tostring(player.target.name))
        else
            send_command('input /ma "'..degrade_array[element_table][#degrade_array[element_table]]..'" '..tostring(player.target.name))
        end
    else 
        add_to_chat(5,'A Monster is not targetted.')
    end
end
 
function job_self_command(commandArgs, eventArgs)
    if commandArgs[1] == 'element' then
        if commandArgs[2] then
            if element_table:contains(commandArgs[2]) then
                element_table = commandArgs[2]
                add_to_chat(5, 'Current Nuke element ['..element_table..']')
            else
                add_to_chat(5,'Incorrect Element value')
                return
            end
        else
            add_to_chat(5,'No element specified')
        end
    elseif commandArgs[1] == 'nuke' then
        nuke()
    end
end
 
 
function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}
    local sleeps = S{'Sleep','Sleep II'}
    local sleepgas = S{'Sleepga','Sleepga II'}
 
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
 
    local spell_index
 
end

mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
    mov.x = windower.ffxi.get_mob_by_index(player.index).x
    mov.y = windower.ffxi.get_mob_by_index(player.index).y
    mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

moving = false
windower.raw_register_event('prerender',function()
    mov.counter = mov.counter + 1;
	if buffactive['Mana Wall'] then
		moving = false
    elseif player.status =='Engaged' then
		moving = false
	elseif mov.counter>15 then
        local pl = windower.ffxi.get_mob_by_index(player.index)
        if pl and pl.x and mov.x then
            dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
            if dist > 1 and not moving then
                state.Moving.value = true
                send_command('gs c update')
				if world.area:contains("Adoulin") then
                send_command('gs equip sets.Adoulin')
				else
                send_command('gs equip sets.MoveSpeed')
                end

        moving = true

            elseif dist < 1 and moving then
                state.Moving.value = false
                send_command('gs c update')
                moving = false
            end
        end
        if pl and pl.x then
            mov.x = pl.x
            mov.y = pl.y
            mov.z = pl.z
        end
        mov.counter = 0
    end
end)
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
 
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	--if buff == "poison" and gain then
	--send_command('input /item "antidote" <me>')
	--end
	if buff == "Vorseal" then
	send_command('gs c cycle VorsealMode')
	elseif buff == "Vorseal" and not gain then
	send_command('gs c cycle VorsealMode')
	end
	if buff == "Visitant" then
	send_command('gs l blm3.lua')
	end
    -- Unlock feet when Mana Wall buff is lost.
	if buff == "Mana Wall" then
	send_command('wait 0.5;gs c update')
	end
    if buff == "Mana Wall" and not gain then
        enable('feet','back')
        handle_equipping_gear(player.status)
    end
    if buff == "Commitment" and not gain then
        equip({ring2="Capacity Ring"})
        if player.equipment.right_ring == "Capacity Ring" then
            disable("ring2")
        else
            enable("ring2")
        end
    end
	if buff == "Vorseal" and gain then
	send_command('input //setbgm 75')
	elseif buff == "Vorseal" and not gain then
	send_command('input //setbgm 251')
	end
end
 
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)

end
 
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
--[[function job_update(cmdParams, eventArgs)
    job_display_current_state(eventArgs)
    eventArgs.handled = true
end]]
 
function display_current_job_state(eventArgs)

end
 
-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        if lowTierNukes:contains(spell.english) then
            return 'LowTierNuke'
        else
            return 'HighTierNuke'
        end
    end
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if buffactive['Mana Wall'] then
        idleSet = sets.buff['Mana Wall']
	elseif state.IdleMode.value == 'Death' then
		idleSet = sets.idle.Death
	elseif state.IdleMode.value == 'Refresh' then
		idleSet = set_combine(sets.auto_refresh, sets.latent_refresh)	
	end
    return idleSet
end

--- This is where I handle Death Mode Melee set modifications
function customize_melee_set(meleeSet)
    if buffactive['Mana Wall'] then
        meleeSet = set_combine(meleeSet, sets.buff['Mana Wall'])
    end
    return meleeSet
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
 
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(3, 7)
	-- Do not remove below argument or the file WILL NOT WORK PROPERLY when reloaded in an escha area--
	if buffactive['Vorseal'] and state.VorsealMode.value == 'Normal' then
	send_command('gs c cycle VorsealMode')
	end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end

--{{Emulator Backend: log_filter=*:Info}}