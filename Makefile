bootstrap:
	@echo "============="
	@echo "installing app dep"
	cd app; npm install;
	@echo "============="
	@echo "installing api dep"
	cd api; npm install;
