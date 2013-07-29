all:
	@bundle exec veewee vbox build devbox

force:
	@bundle exec veewee vbox build devbox --force

export:
	@bundle exec veewee vbox export devbox --force

