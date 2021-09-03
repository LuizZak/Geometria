BUNDLE = bundle exec

doc:
	@$(BUNDLE) jazzy \
		--min-acl public \
		--no-hide-documentation-coverage \
		--theme fullwidth \
		--output ./docs \
		--documentation=./*.md

doc-publish: doc
	@$(MAKE) -C docs publish

lint:
	@swiftlint

lint-html:
	@swiftlint lint --reporter html > lint-results.html

repl:
	swift run --repl
