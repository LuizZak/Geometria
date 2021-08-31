publish:
	@git add .
	@git commit -m "Updating documentation"
	git push -u origin gh-pages --force-with-lease
