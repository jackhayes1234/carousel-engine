---
name: carousel-engine
description: Turn a carousel script plus messy screenshots into finished Instagram/LinkedIn carousel slides (1080x1350 PNGs, a PDF and a contact sheet) in the user's brand fonts and colours. Use when the user says "make a carousel", drops a script with "Slide 1, Slide 2...", or hands over screenshots for slides.
---

# Carousel engine

Script + screenshots in, finished carousel out. `engine.py` is in this skill's folder. It needs
macOS 14 or later, Python 3 with Pillow, and Google Chrome.

## Steps

1. **Collect inputs.** Put the script in `<job>/script.txt` and screenshots in `<job>/shots/`.
   If the user gives a brand (colours, fonts, font files, or a reference slide image), write
   `<job>/brand.json` (see `example/brand.json`). From a reference image, read the background,
   text and accent colours and the closest installed fonts. Font files go in `"file"` (relative to brand.json).
   Google Fonts stylesheet URLs go in `"font_css": [...]`.

2. **Split the script.**
   `python3 engine.py parse <job>/script.txt > <job>/slides.json`
   Then edit slides.json yourself:
   - Set `"brand": "brand.json"` and `"handle": "@user"`.
   - Fix headline/body splits. Keep headlines short and punchy, and put the rest in body.
   - Mark emphasis: `*word*` gives an accent underline, `_word_` gives the aside font in the accent colour.
     Use at most one or two per slide, on the words that carry the point.
   - `layout` is `cover` (slide 1: big headline, image at the bottom), `text` (centred words)
     or `image` (headline, image, then body).

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
   value, a call to action, 3–5 niche hashtags) and one line of alt text per slide.

## Rules

- Never rewrite the user's copy beyond splitting it and marking emphasis, unless they ask.
- Only use images the user supplied or has rights to. Cutouts of real people are for commentary,
  not for implying endorsement.
