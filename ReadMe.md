Download a transcript, place it in this directory, run
`./convert_transcript.lua FILE`, fill in author and link as
requested, and you will have a usable epub.

This is heavily WIP.

I used the apply_margin script on a transcript downloaded from
https://www.youtube-transcript.io to correct the poor formatting,
then oops_all_code to add backticks to each line (because else
pandoc encodes all code in a single block no matter how poorly
that aligns with a page boundary when exporting epubs), then
pandoc --from markdown+hard_line_breaks input -o output to finally
have a functional epub that is legible.

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
