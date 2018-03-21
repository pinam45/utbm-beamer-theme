# utbm-beamer-theme

A LaTeX beamer version of the UTBM presentation theme using TikZ.

You can preview the theme with the [compiled example](example.pdf).

# Warning

The LaTeX implementation I made is free but the theme belongs to the UTBM and can only be used with their authorization!

**UTBM and all UTBM-related trademarks and logos are trademarks or registered trademarks of University of Technology of Belfort-Montbéliard in France, other countries, or both.**

# Installation

## Install the package

Copy the directory [beamerthemeutbm](beamerthemeutbm) inside one of your **texmf** directory: to follow the TDS (TeX Directory Structure), copy it in ``<texmf_folder>/tex/latex/``.

Your **texmf** directory is usually ``$HOME/texmf`` on Unix operating systems.

On Windows with MiKTeX you can find it in MiKTeX's options:
- Start menu -> MiKTeX -> MiKTeX settings
- The options window should open
- Go in the *Roots* panel
- Check *Show MiKTeX-maintained root directories*
- Take the path with the description: "CommonData, CommonConfig" (It is usually ``C:\ProgramData\MiKTeX\<version>``) or add the path you want

## Refresh the LaTeX databases

On Unix operating systems, in root:
```
$> mktexlsr
$> update-updmap --quiet
```

On Windows with MiKTeX
- Start menu -> MiKTeX -> MiKTeX settings
- Click *Refresh FNDB*
- Click *Update Formats*

# Usage

Select the theme with:
```latex
\usetheme{utbm}
```
You can specify a illustration to use for the title page (``\titlepage``), example with the file *cover.png*:
```latex
\usetheme[illustration=cover]{utbm}
```
The *illustration* option use the ``\includegraphics`` syntax.

The theme also add 2 commands:
- ``\utbmtitle{Title}`` for a simple title page
- ``\utbmclosingframe{Thanks}``: for the closing frame

See [example.tex](example.tex) for a complete example.

## Building the example

### Unix-like systems: makefile
Build:
```
$ make
```
Clean:
```
$ make clean
```
### Windows: make.cmd
Build:
```
> make.cmd
```
Clean:
```
> make.cmd clean
```
