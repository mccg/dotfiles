.PHONY: usage
usage:
	@echo "usage: "; \
	echo "       vimrc: (making-flow) -> vimrc && make vimrc"; \
	echo "     vimdict: (making-flow) -> vim dict/*.dict && make vimdict"; \
	echo "           v: make vimrc vimdict"

.PHONY: vimrc
vimrc:
	cp ~/.vimrc .

.PHONY: vimdict
vimdict:
	@DICTS=`ls dict/*`; \
	for dict in $${DICTS[@]}; \
	do \
	  echo "-> Make $$dict"; \
	  cat $$dict | sort -Vu > $${dict}.bak; \
	  mv $${dict}.bak $$dict; \
	done

.PHONY: v
v: vimrc, vimdict

