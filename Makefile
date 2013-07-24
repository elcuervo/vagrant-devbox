all:
	@bundle exec veewee vbox build heroku

force:
	@bundle exec veewee vbox build heroku --force

export:
	@bundle exec veewee vbox export heroku --force

