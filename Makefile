run:
	bundle
	rake db:drop db:create db:migrate db:seed
	rails s




