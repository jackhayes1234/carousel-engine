# Carousel engine (Claude Code skill)

Turns a "Slide 1, Slide 2..." script plus screenshots into finished 1080x1350 carousel slides,
a LinkedIn-ready PDF and a contact sheet, in your brand fonts and colours.

## Needs
- A Mac on macOS 14 or later (subject cutouts use Apple's built-in Vision)
- Claude Code (the desktop app's Code tab, or the `claude` CLI)
- Google Chrome
- Python 3 with Pillow: `pip3 install pillow`
- Xcode Command Line Tools for the cutout step: `xcode-select --install`

## Install
Unzip, then move the `carousel-engine` folder into `~/.claude/skills/`:

    unzip carousel-engine.zip -d ~/.claude/skills/

Restart Claude Code, then say "make a carousel" and give it your script and screenshots.

## Check it works
    cd ~/.claude/skills/carousel-engine && python3 -m unittest test_engine
