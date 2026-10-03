# yt-transcript-tools
Getting transcripts into epub format.

Download a transcript, place it in this directory, run
`./convert_transcript.lua FILE`, fill in author and link as
requested, and you will have a usable epub.

**The file name will be set as the title.**

This is heavily WIP.

This will probably fail with videos longer than an hour because
the export will be different enough to fuck up the margin fix.

I am really frustrated because pandoc doesn't support plain text.
I went through many tests and iterations before coming to even
this minimal start and it was extremely frustrating.

## Tasks
- [x] I need an option / 2nd script to output a version with no
  timecode formatting for easier text extraction.
  - I made it actually just combine both in the same document,
    easier to manage that way.
