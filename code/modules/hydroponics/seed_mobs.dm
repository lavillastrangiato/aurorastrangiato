// The following procs are used to grab players for mobs produced by a seed (mostly for dionaea).
/datum/seed/proc/handle_living_product(var/mob/living/host)
	if(!host || !istype(host))
		return

	var/host_spawner_type = "living_plant"
	if(istype(host, /mob/living/carbon/alien/diona))
		host_spawner_type = "diona_nymph"

	SSghostroles.add_spawn_atom(host_spawner_type, host)
	addtimer(CALLBACK(src, PROC_REF(kill_living_product), WEAKREF(host), host_spawner_type), 3 MINUTES)

/datum/seed/proc/kill_living_product(var/datum/weakref/host_ref, var/product_spawner_type = "living_plant")
	var/mob/living/host = host_ref.resolve()
	if(host && !host.ckey && !host.client)
		SSghostroles.remove_spawn_atom(product_spawner_type, host)
		host.death()  // This seems redundant, but a lot of mobs don't
		host.stat = DEAD // handle death() properly. Better safe than etc.
		host.visible_message(SPAN_DANGER("[host] is malformed and unable to survive. It expires pitifully, leaving behind some seeds."))

		var/total_yield = rand(1,3)
		for(var/j = 0;j<=total_yield;j++)
			var/obj/item/seeds/S = new(get_turf(host))
			S.seed_type = name
			S.update_seed()
