deploy-redis
============

Simple command line Redis deployer. Create and remove Redis instances.

Usage
=====

Create new Redis instance:

	sudo r3 deploy-redis.reb <port-number>

Create more Redis instances:

	sudo r3 deploy-redis.reb <port-number> <another-port-number>

Remove Redis instance:

	sudo r3 deploy-redis.reb remove <port-number>

List all available Redis instances:

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