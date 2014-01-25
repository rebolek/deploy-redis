deploy-redis
============

Simple command line Redis deployer. Create and remove Redis instances.

Usage
=====

Create new Redis instance:
--------------------------

	sudo r3 deploy-redis.reb <port-number>
	sudo r3 deploy-redis.reb 7000

Create more Redis instances:
----------------------------

	sudo r3 deploy-redis.reb <port-number> <another-port-number>
	sudo r3 deploy-redis.reb 7000 7010 7020

Create Redis instances in port range:
-------------------------------------

	sudo r3 deploy-redis.reb <start-port-number> .. <end-port-number>
	sudo r3 deploy-redis.reb 7000 .. 7005

Create master Redis instance with slave:
----------------------------------------

	sudo r3 deploy-redis.reb <master-port> slave <slave-port>
	sudo r3 deploy-redis.reb 7000 slave 7100

Remove Redis instance:
----------------------

	sudo r3 deploy-redis.reb remove <port-number>

You can also use more ports and ranges as with deployment.

List all available Redis instances:
-----------------------------------

	sudo r3 deploy-redis.reb list

Requirements
============

* Debian based Linux distribution (may work elsewhere, not tested)
* [REBOL 3](https://github.com/rebol/rebol) (REBOL 2 may work also, not tested)
* [Redis](https://github.com/antirez/redis) (v 2.8.4 tested, but should work with other versions also)

License
=======

Same 3-clause BSD as Redis. I guess I should add the license text here,
but I'm no lawyer so I don't care.