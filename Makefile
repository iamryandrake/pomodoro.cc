bootstrap:
	@echo "============="
	@echo "installing app dep"
	cd app; make bootstrap;
	@echo "============="
	@echo "installing api dep"
	cd api; npm install;
