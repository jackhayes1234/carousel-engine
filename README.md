# Carousel engine (Claude Code skill)

Turns a "Slide 1, Slide 2..." script plus screenshots into finished 1080x1350 carousel slides,
a LinkedIn-ready PDF and a contact sheet, in your brand fonts and colours.

## Needs
- A Mac on macOS 14 or later (subject cutouts use Apple's built-in Vision)
- Claude Code (the desktop app's Code tab, or the `claude` CLI)
- Google Chrome
- Python 3 with Pillow: `pip3 install pillow`
- Xcode Command Line Tools for the cutout step: `xcode-select --install`

## Install (easiest)
Accept the GitHub invite, open Claude Code (the Code tab in the Claude desktop app), and paste:

> Clone https://github.com/jackhayes1234/carousel-engine into ~/.claude/skills/carousel-engine, then set up the carousel engine.

Claude clones it, checks Chrome, Pillow and the cutout tool, creates `~/Desktop/Carousels/`, saves your brand,
and runs the self-test. If it asks you to click Install in an Apple window, do that.
Restart Claude Code once afterwards so the skill is picked up in new sessions.

## Make a carousel
Say **"new carousel called blake-pr"**. Claude makes the folder and opens it. Drop your screenshots into `shots`,
paste your script into the chat, and approve the slide plan. Finished slides land in the folder's `out` folder.

## Install by hand
    git clone https://github.com/jackhayes1234/carousel-engine ~/.claude/skills/carousel-engine
    pip3 install pillow
    xcode-select --install

## Check it works
    cd ~/.claude/skills/carousel-engine && python3 -m unittest test_engine
