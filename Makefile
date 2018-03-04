#=============================================================================
# Project related variables
DOCUMENTS_NAMES=example

NEEDS_BIBTEX=
NEEDS_MAKEGLOSSARIES=

PACKAGES_REQUIRED[example]=fontenc pgf tikz xcolor beamercolorthemeutbm beamerinnerthemeutbm beamerouterthemeutbm beamerthemeutbm

#=============================================================================
# Commands variables
LATEX_COMPILER_CMD      = xelatex
BIBTEX_CMD              = bibtex
MAKEGLOSSARIES_CMD      = makeglossaries
KPSEWHICH_CMD           = kpsewhich
DISPLAY                 = printf
RM                      = rm -f

#=============================================================================
# Other configs
TO_DELETE_EXT           = -blx.aux -blx.bib .acn .acr .alg .aux .bbl .bcf .blg .cb .cb2 .dvi .fdb_latexmk .fls .fmt .fot .glg .glo .gls .glsdefs .idx .ilg .ind .ist .lof .log .lol .lot .nav .out .pdf .pdfsync .pre .run.xml .snm .sta .synctex .synctex.gz .toc .vrb .xdv
LATEX_COMPILER_SILENT   = -interaction=batchmode 1>/dev/null 2>/dev/null
BIBTEX_SILENT           = 1>/dev/null 2>/dev/null
MAKEGLOSSARIES_SILENT   = -q

#=============================================================================
# Functions
define check_package
	$(DISPLAY) "\033[0m\033[1;34m[··]\033[0m package $(1)"
	($(KPSEWHICH_CMD) $(1).sty 1>/dev/null 2>/dev/null && \
	$(DISPLAY) "\r\033[1C\033[1;32mOK\033[0m\n") || \
	($(DISPLAY) "\r\033[1C\033[1;31mXX\033[0m\n" && return 1 \
	)

endef

define launch_latex_compiler
	@$(DISPLAY) "\033[0m\033[1;34m>\033[0m Executing $(LATEX_COMPILER_CMD)\n"
	$(LATEX_COMPILER_CMD) $(1) $(if $(SILENT), $(LATEX_COMPILER_SILENT))

endef

define launch_bibtex
	@$(DISPLAY) "\033[0m\033[1;34m>\033[0m Executing $(BIBTEX_CMD)\n"
	$(BIBTEX_CMD) $(1) $(if $(SILENT), $(BIBTEX_SILENT))

endef

define launch_makeglossaries
	@$(DISPLAY) "\033[0m\033[1;34m>\033[0m Executing $(MAKEGLOSSARIES_CMD)\n"
	$(MAKEGLOSSARIES_CMD) $(if $(SILENT), $(MAKEGLOSSARIES_SILENT)) $(1)

endef

define remove_file
	$(if $(wildcard $(1)), \
		@$(DISPLAY) "\033[0m\033[1;34m>\033[0m Removing file $(1)\n", \
	)
	@$(RM) $(1)

endef

define clean_document
	@$(DISPLAY) "\nClean of \033[0;33m$(1)\033[0m:\n"
	$(foreach ext, $(TO_DELETE_EXT), \
		$(call remove_file,$(1)$(ext)) \
	) \

endef

#=============================================================================
# Rules
.PHONY: silent
silent:
	@make --silent all SILENT=true

.PHONY: pdf
pdf: $(foreach doc,$(DOCUMENTS_NAMES),$(doc).pdf)

.PHONY: all
all: pdf

%.pdf: %.tex FORCE
	$(eval DOCUMENT_NAME:=$(patsubst %.pdf,%,$@))
	@$(DISPLAY) "\nBuilding \033[0;33m$@\033[0m:\n"

	$(foreach package, $(PACKAGES_REQUIRED[$(DOCUMENT_NAME)]), \
		$(call check_package,$(package))\
	)

	$(call launch_latex_compiler, $(DOCUMENT_NAME))

	$(if $(findstring $(DOCUMENT_NAME), $(NEEDS_BIBTEX)), \
		$(call launch_bibtex, $(DOCUMENT_NAME)) \
	)

	$(if $(findstring $(DOCUMENT_NAME), $(NEEDS_MAKEGLOSSARIES)), \
		$(call launch_makeglossaries, $(DOCUMENT_NAME)) \
	)

	$(call launch_latex_compiler, $(DOCUMENT_NAME))

	$(call launch_latex_compiler, $(DOCUMENT_NAME))

	@$(DISPLAY) "\n"


.PHONY: clean
clean:
	$(foreach document_name, $(DOCUMENTS_NAMES), \
		$(call clean_document,$(document_name)) \
	)

	@$(DISPLAY) "\n"


FORCE:
