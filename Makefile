bootstrap:
	@echo "============="
	@echo "installing app dep"
	cd app; npm install; NODE_PATH=node_modules ./node_modules/gulp/bin/gulp.js
	@echo "============="
	@echo "installing api dep"
	cd api; npm install;
