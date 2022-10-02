.PHONY: setup lint test

setup:
	bundle

lint:
	bundle exec rubocop

test:
	bundle exec rspec
