# Changelog

## v0.0.1 (8/13/2023)

* Added raw audio and raw behavioral data
* Added cleaned audio and extracted raw transcripts
* Cleaned `sessid002` transcript
* Added initial version of `combined.csv` dataframe
  - Removed duplicated trials and enforce consistent gameId/playerIds for games
    that were interrupted and restarted midway (`sessid004`, `sessid005`, `sessid021`)

## v0.0.2 (8/18/2023)

* Corrected prisma-side "Pretest/Posttest" run labels to match
  skyra-side "PreTest/PostTest"
* Added `bids/` directory with the BIDS-compliant output of
  `heudiconv`
* Added `bids/derivatives/` directory with output of `fmriprep`
* Added `bids/derivatives/sourcedata` directory with `freesurfer` files

## v0.0.3 (8/20/2023)
* Re-ran `fmriprep` for `sub-p013` using `--use-syn-sdc` flag after
  noticing an error using fieldmaps (params must have been copied over 
  incorrectly after taking subject out of the scanner).
