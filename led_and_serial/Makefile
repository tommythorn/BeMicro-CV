QUIET= > /dev/null

all:
	@time $(MAKE) bemicrocv.sof.programmed

bemicrocv.map.summary: bemicrocv.v bemicrocv.qsf
	@echo MAPPING
	@quartus_map bemicrocv $(QUIET)
	@-grep ^Error bemicrocv.map.summary && mv bemicrocv.map.summary bemicrocv.map.summary.broken || true

bemicrocv.fit.summary: bemicrocv.map.summary
	@echo FITTING
	@quartus_fit bemicrocv $(QUIET)
	@-grep ^Error bemicrocv.fit.rpt && mv bemicrocv.fit.summary bemicrocv.fit.summary.broken || true

bemicrocv.sta.summary: bemicrocv.fit.summary
	@echo TIMING
	@quartus_sta bemicrocv $(QUIET)
	@-grep ^Error bemicrocv.sta.rpt && mv bemicrocv.sta.summary bemicrocv.sta.summary.broken || true

bemicrocv.sof: bemicrocv.fit.summary bemicrocv.sta.summary
	@echo ASSEMBLING
	@quartus_asm bemicrocv $(QUIET)
	@-grep ^Error bemicrocv.asm.rpt && rm bemicrocv.sof || true

# Because jtagd is so reliable
bemicrocv.sof.programmed: bemicrocv.sof
	@echo PROGRAMING
	@-sudo killall jtagd
	@-sudo killall -9 jtagd
	@quartus_pgm bemicrocv.cdf $(QUIET) && cp bemicrocv.sof bemicrocv.sof.programmed || true
