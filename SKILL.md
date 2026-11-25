---
name: carousel-engine
description: Turn a carousel script plus messy screenshots into finished Instagram/LinkedIn carousel slides (1080x1350 PNGs, a PDF and a contact sheet) in the user's brand fonts and colours. Use when the user says "make a carousel", drops a script with "Slide 1, Slide 2...", or hands over screenshots for slides. Also use when they ask to set up, install or check the carousel engine, to start a new carousel, to learn or copy their style from their own carousels or Instagram, or to turn a carousel into a Reel.
---

# Carousel engine

Script + screenshots in, finished carousel out. `engine.py` is in this skill's folder. It needs
macOS 14 or later, Python 3 with Pillow, and Google Chrome.

Run engine.py by its full path in this skill's folder (normally `~/.claude/skills/carousel-engine/engine.py`).
Carousels live in `~/Desktop/Carousels/`, one folder (the `<job>`) per carousel, and the saved brand is
`~/Desktop/Carousels/brand.json`, with notes on their style in `~/Desktop/Carousels/style.md`.

## Setup (on first use, or when the user asks to install, set up or check it)

Check each item and fix what you can. Tell the user, in plain words, about anything they must do themselves.
1. macOS 14 or later: `sw_vers -productVersion`. If it's older, stop: cutouts need macOS 14 or later.
2. Google Chrome: `/Applications/Google Chrome.app` exists. If not, ask the user to install it from google.com/chrome.
3. Pillow: `python3 -c "import PIL"`. If that fails, run `pip3 install --user pillow`.
4. Swift compiler for cutouts: `xcrun --find swiftc`. If it's missing, run `xcode-select --install`,
   which opens an Apple installer window. Ask the user to click Install and tell you when it finishes.
5. Make `~/Desktop/Carousels/`.
6. Brand: ask for their Instagram handle, colours (background, text, accent) and fonts, or a screenshot
   of a carousel style they like. Save them to `~/Desktop/Carousels/brand.json` (format: `example/brand.json`,
   plus `"handle": "@them"`). If they skip this, the default cream and pink look is used.
7. Run the self-test: `cd ~/.claude/skills/carousel-engine && python3 -m unittest test_engine`. It must say OK.
8. Tell them setup is done. Then offer **Learn my style** (below): it is what makes carousels look like theirs
   and not like a template. After that, they start with "new carousel" and a name.

## Learn my style (when the user says "learn my style", or setup offers it)

1. **Get examples of their work.** Make `~/Desktop/Carousels/style/`, open it in Finder, and ask for 5–10
   slides from their best carousels (screenshots are fine; covers and inside slides both help). If they have
   their Instagram archive (Instagram → Settings → Accounts Centre → Your information and permissions →
   Download your information), unzip it and copy the carousel images from its `media/posts` folders into `style/`.
   Don't scrape Instagram or log in to it for them.
2. **Study every image** (open each one and look). Write `~/Desktop/Carousels/style.md` covering:
   palette (exact hex values), fonts (see *Fonts* below), how they
   emphasise words (underline, highlighter, colour, circled, all caps), how they treat photos (stickers, frames,
   tilt, outlines, full-bleed), backgrounds and textures, text placement and density, which layouts they reuse,
   and their writing voice (hooks, sentence length, slang, sign-offs, emoji use).
3. **Write the brand.** Put colours, fonts and handle in `~/Desktop/Carousels/brand.json`, and recreate the rest
   with `"css"`, a list of CSS rules added after the engine's own (see *Styling hooks*). Put any texture or
   background images next to brand.json and refer to them by file name, e.g. `url(paper.png)`; you can generate
   one with Pillow.
4. **Prove it.** Pick one of their slides, write a short script that copies its words, render it with the new
   brand, and compare your render with the original side by side. Fix the differences (size, weight, spacing,
   colours, emphasis, photo treatment) and re-render. Do up to three rounds, then show the user both and ask
   what still feels off.
5. From now on, read `style.md` before every carousel: match their voice when splitting copy and choosing
   emphasis, and prefer the layouts they actually use.

## Fonts

Pick fonts in this order, and use the same choice in `style.md`:
1. **The user's own font files.** Ask if they have the real ones (.ttf, .otf, .woff2). Copy them into
   `~/Desktop/Carousels/fonts/`.
2. **Bundled free fonts**, if `~/.claude/skills/ui-styling/canvas-fonts/` exists. It has 29 OFL-licensed families
   (e.g. Bricolage Grotesque, Instrument Serif, Boldonse, Gloock, Young Serif, Outfit, Work Sans, Lora). Look at
   the list, pick the closest match by shape and mood, and copy the chosen weight files plus the family's
   `-OFL.txt` into `~/Desktop/Carousels/fonts/`.
3. **Google Fonts.** Add the stylesheet URL to `"font_css": ["https://fonts.googleapis.com/css2?family=Name:wght@400;700&display=swap"]`
   and use the family name. This needs internet access when rendering.
4. **Installed fonts** in `/System/Library/Fonts`, `/Library/Fonts` and `~/Library/Fonts`.

For a font file, write `"headline": {"file": "fonts/BricolageGrotesque-Bold.ttf", "weight": 700}` in brand.json.
The path is relative to brand.json. Use one file per role, matching its weight and style.
After changing fonts, render a test slide and check the headline: tall display fonts need more line spacing
(e.g. `"css": [".h{line-height:1.18}"]`) so underlines don't collide with the next line.

## A fresh look (no examples, or the user wants something new)

If `~/.claude/skills/ui-ux-pro-max/` exists, search its palettes and font pairings with words that fit the account
(topic, mood, audience):
`cd ~/.claude/skills/ui-ux-pro-max && python3 scripts/search.py "<mood words>" --domain typography -n 3`
`cd ~/.claude/skills/ui-ux-pro-max && python3 scripts/search.py "<mood words>" --domain color -n 3`
Show the user two or three options as quick one-slide renders, then save the chosen one as the brand.
Without that skill, choose a palette and a pairing from the bundled or Google fonts yourself.

## Styling hooks

The `"css"` rules in brand.json can target:
- `body` (the whole slide; set `background` here), with classes for the layout (`cover`, `text`, `image`,
  `list`, `quote`, `tweet`), the slide number (`slide-3`), and `first` / `last`
- `.h` headline, `.b` body, `.em` the `*word*` emphasis, `.aside` the `_word_` emphasis, `.foot` the footer
  (handle, page count, swipe), `.pic img` any image, `.cut img` a cutout sticker, `.photo img` a framed photo,
  `ol` / `li` list items, `body.tweet .b` the tweet card, `body.quote .b::before` the quote mark
- `.f-headline`, `.f-body`, `.f-aside` font roles

Proven recipes:
- Highlighter emphasis: `.em{text-decoration:none;background:linear-gradient(transparent 55%,#FFD43B 55%,#FFD43B 90%,transparent 90%)}`
- Sticker with white outline and tilt: `.cut img{transform:rotate(-4deg);filter:drop-shadow(6px 0 0 #fff) drop-shadow(-6px 0 0 #fff) drop-shadow(0 6px 0 #fff) drop-shadow(0 -6px 0 #fff)}`
- Polaroid photo: `.photo img{transform:rotate(2deg);border:14px solid #fff;border-radius:6px}`
- Texture: `body{background:url(paper.png) center/cover}`
Text auto-shrinks to fit even with transforms, so tilts and shadows are safe.

## Start a new carousel

When the user says "new carousel" (or gives a topic), make `~/Desktop/Carousels/<short-name>/shots/`,
and open the folder in Finder (`open <folder>`). Don't copy brand.json: jobs point at the shared one.
Then tell them to:
- drop their screenshots into the `shots` folder, and
- paste their script into the chat, or save it as `script.txt` in the folder.

If they paste the script, save it to `<job>/script.txt` yourself. When both are in, run the steps below.

## Steps

1. **Collect inputs.** The script is in `<job>/script.txt` and the screenshots are in `<job>/shots/`.
   Use the shared brand. If there isn't one yet and the user gives colours, fonts or a reference slide,
   write `~/Desktop/Carousels/brand.json` (see `example/brand.json`), choosing fonts as in *Fonts*.

2. **Split the script.**
   `python3 engine.py parse <job>/script.txt > <job>/slides.json`
   Then edit slides.json yourself:
   - Set `"brand": "../brand.json"` (the shared brand in `~/Desktop/Carousels/`) if it exists. Use a job's own
     brand.json only for a one-off look. The handle comes from the brand; set `"handle"` here only to override it.
   - Fix headline/body splits. Keep headlines short and punchy, and put the rest in body.
   - Mark emphasis: `*word*` gives an accent underline, `_word_` gives the aside font in the accent colour.
     Use at most one or two per slide, on the words that carry the point.
   - `layout` is `cover` (slide 1: big headline, image at the bottom), `text` (centred words),
     `image` (headline, image, then body), `list` (each body line becomes a numbered point),
     `quote` (body is the quote, headline is who said it) or `tweet` (body in a social-post card, headline above).

3. **Match screenshots to slides.** Run `python3 engine.py info <job>/shots/*` to get sizes. Look at each
   screenshot and find the actual photo inside it, ignoring browser bars, search UI and captions.
   For each slide that needs a picture, add:
   `"image": {"src": "shots/x.png", "crop": [x, y, w, h], "cutout": true}`
   Use `cutout: true` for a person or object that should float as a sticker (good on covers), and
   `false` for scenes, screenshots of posts, or anything where the background matters.
   Show the user the match plan (slide → screenshot) and let them swap pictures before building.

4. **Render.** Run `python3 engine.py render <job>/slides.json`. Output goes to `<job>/out/`: `slideNN.png`,
   `carousel.pdf` (for LinkedIn) and `contact-sheet.jpg`.

5. **Check your own work.** Open `contact-sheet.jpg` and any doubtful slide. Fix crops that cut
   off heads or include UI, weak emphasis, and text that shrank too small (shorten the copy instead).
   Then re-render. Repeat until every slide is clean.

6. **Hand over.** Give the user the slide paths, plus an Instagram caption (hook line, 2–3 lines of
   value, a call to action, 3–5 niche hashtags) and one line of alt text per slide. Write the caption in their
   voice from `style.md`, then run it through the `no-ai-slop` skill if it's installed. Without it, cut filler,
   hedges, stacked em dashes, "here's the thing" openers and lists of three. Do the same for any slide copy you
   wrote or tightened, but never for the user's own copy unless they ask.

## Turn it into a Reel (when the user asks)

If the `hyperframes` skill is installed, use it to animate the finished `out/slideNN.png` files into a
1080x1920 vertical video: about 2.5 seconds per slide, the slide centred on the brand background colour, with a
simple swipe or push between slides, and no music unless the user supplies a track. Save it as `<job>/out/reel.mp4`.
Without the skill, say it isn't installed on this computer.

## Rules

- Never rewrite the user's copy beyond splitting it and marking emphasis, unless they ask.
- Only use images the user supplied or has rights to. Cutouts of real people are for commentary,
  not for implying endorsement.
