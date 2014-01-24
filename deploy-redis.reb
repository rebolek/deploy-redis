REBOL[
	Title: "Deploy Redis server"
	Author: "Boleslav Brezovsky"
	Date: 21-1-2014
	Notes: {
		This script executes instrictions from [this page](http://redis.io/topics/quickstart)
		It expects that you already have redis-server in /usr/local/bin/
		It needs file %redis_init_script in same directory
	}
	Requirements: [
		%redis_init_script
		%redis.conf
	]
	To-Do: [
		"Error checking"
		"Create slaves"
		"Add some instance parameters (memory, ...)"
		"Standalone version"
	]
]

; ==========================

daemon: func [
	"Do daemon action (start, stop,...) for given redis port"
	port 	[ integer! ]	"Redis port"
	action 	[ word! ] 		"Daemon action"
] [
	call rejoin [ "sudo /etc/init.d/redis_" port " " action ]
]

config-file: func [
	"Return config file! for given Redis port"
	port 	[ integer! ]
] [
	rejoin [ %/etc/redis/ port %.conf ]
]

deploy: funct [
	"Setup new Redis instance"
	port	[integer!] "Port number"
] [
	; TODO: check if port isn't already assigned

	; make default dirs if needed

	unless exists? %/etc/redis [ mkdir %/etc/redis ]
	unless exists? %/var/redis [ mkdir %/var/redis ]
	mkdir join %/var/redis/ port

	; customize and copy init script - replace default port number

	init-script: read %redis_init_script
	replace init-script "6379" to string! port
	write join %/etc/init.d/redis_ port init-script
	call join "sudo chmod 755 /etc/init.d/redis_" port

	; customize and copy configuration file

	config: read %redis.conf
	replace config "daemonize no" "daemonize yes"
	replace config "pidfile /var/run/redis.pid" rejoin ["pidfile /var/run/redis" port ".pid"]
	replace config "port 6379" join "port " port
	replace config {logfile ""} rejoin ["logfile /var/log/redis_" port ".log"]
	replace config "dir ./" join "dir /var/redis/" port
	write config-file port config

	; add redis init script to default runlevels

	call rejoin ["sudo update-rc.d redis_" port " defaults"]

	; run redis instance

	daemon port 'start

	; be nice and return something ( TODO: error handling )

	true
]

dispose: funct [
	"Stop Redis instance and remove its files"
	port	[integer!] "Port number"
][
	; TODO: check if this instance exists

	; stop Redis instance and remove daemon script

	call rejoin [ "sudo update-rc.d -f redis_" port " remove" ]
	rm join %/etc/init.d/redis_ port

	; remove logs and config files

	rm config-file port
	var-path: dirize join %/var/redis/ port
	foreach file read var-path [
		rm join var-path file
	]
	rm var-path
]

list: funct [
	"List all available Redis instances"
][
	files: sort read %/etc/init.d/
	print "Available Redis instances by port number:"
	foreach file files [
		if equal? "redis" copy/part file 5 [
			print skip file 6
		]
	]
]

; ======================

list-rule: [
	'list ( list )
]

range-rule: [
	set start-port integer!
	'..
	set end-port integer!
]

remove-rule: [
	'remove
	[
		range-rule (
			repeat port end-port - start-port + 1 [
				dispose start-port + port - 1
			]
		)
	|	some [ set port integer! ( dispose port ) ]
	]
]

deploy-rule: [
	range-rule (
		print "range"
		repeat port end-port - start-port + 1 [
			deploy start-port + port - 1
		]
	)
|	some [ set port integer! ( deploy port ) ]
]

; ======================

; read command line arguments

args: append [] load system/script/args

parse args [
	list-rule
|	remove-rule
|	deploy-rule
]