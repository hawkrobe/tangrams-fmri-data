# Installation

Our fMRI dataset is managed under version control using [`datalad`](https://www.datalad.org/). 

This repository holds the 'structure' of the data, along with the smaller files, but if you clone the repository you will notice that the big files show up on your machine as 'empty' symlinks. 

The real files are chopped up into little pieces and stored elsewhere (currently [this Dropbox folder](https://www.dropbox.com/sh/wh1k1z70hq0w45m/AAD_F2sb2VsK5JC4lColvYAIa?dl=0)). The idea behind datalad is that you only pull down the data you need for the analyses you want to run (otherwise you'd end up with over 200GB on your machine). To do so, you'll do something like this (essentially following [this guide](https://handbook.datalad.org/en/latest/basics/101-139-dropbox.html#from-the-perspective-of-whom-you-share-your-dataset-with):

## Step 1: Clone the repo
```
datalad clone git@github.com:hawkrobe/tangrams-fmri-data.git
```

## Step 2: Set up dropbox

* [Install `rclone`](https://rclone.org/install)
* [Install `git-annex-remote-rclone`](https://github.com/git-annex-remote-rclone/git-annex-remote-rclone)
* Run `rclone config` in the directory and use the following settings as you work through the prompts:

```
$ rclone config
 No remotes found - make a new one
 n/s/q> n
 name> dropbox-fmri      # use this exact name
 Storage> dropbox
 client_id>              # leave this line blank
 client_secret>          # leave this line blank
 y/n> n
 If your browser doesn't open automatically go to the following link: http://127.0.0.1:53682/auth
 Log in and authorize rclone for access
```

## Step 3: Add sibling

* Run the line you were told to run when you first ran `datalad clone ...` It should look like this.

```
datalad siblings -d "<path>" enable -s dropbox-fmri
```

* Now you can pull down any files you want, e.g. `datalad get bids/sub-p002/*` will download the raw `nii` files associated with subject `p002`. 

# `bids` Directory Structure

TODO

# `masks` Directory Structure

TODO

# `behavioral` Directory Structure

## Final
* `cleaned_transcripts` contains cleaned up versions of raw transcripts, checked by hand, and split out by trial
* `cleaned_behavioral` contains cleaned up versions of behavioral data, fixing various naming glitches

## Intermediate
* `cleaned_audio` contains trimmed recordings split by run (manually checked using audacity)
* `raw_transcripts` contains output of `transcribe.sh` which runs WHISPER on the `cleaned_audio` files`

## Raw
* `raw_audio` contains raw recordings in `.wav` format
* `raw_behavioral` contains raw files exported from Empirica
