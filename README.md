# Behavioral

## Final
* `cleaned_transcripts` contains cleaned up versions of raw transcripts, checked by hand, and split out by trial
* `cleaned_behavioral` contains cleaned up versions of behavioral data, fixing various naming glitches

## Intermediate
* `cleaned_audio` contains trimmed recordings split by run (manually checked using audacity)
* `raw_transcripts` contains output of `transcribe.sh` which runs WHISPER on the `cleaned_audio` files`

## Raw
* `raw_audio` contains raw recordings in `.wav` format
* `raw_behavioral` contains raw files exported from Empirica

# Changelog

## v0.0.1 (8/13/2023)

* Added raw audio and raw behavioral data
* Added cleaned audio and extracted raw transcripts
* Cleaned `sessid002` transcript
* Added initial version of `combined.csv` dataframe
  - Removed duplicated trials and enforce consistent gameId/playerIds for games
    that were interrupted and restarted midway (`sessid004`, `sessid005`,
    `sessid021`)

