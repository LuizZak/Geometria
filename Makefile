doc:
	@jazzy \
		--min-acl public \
		--no-hide-documentation-coverage \
		--theme fullwidth \
		--output ./docs \
		--documentation=./*.md
	@cd docs
	@git add .
	@git commit -m "Updating documentation"
	@git push -u origin gh-pages --force-with-lease
	@cd ../
