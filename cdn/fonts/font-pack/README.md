# Font Pack Collection

## Purpose
Curated collection of vintage and specialty fonts for specific projects.
**Separate from core fonts** - not used in standard surfaces.

## Fonts Included

### Mallard Family
- **Mallard-Regular.ttf** — Vintage sans-serif
- **Mallard-Bold.ttf** — Bold variant
- **Mallard-Italic.ttf** — Italic variant

## Usage

```css
/* Load from font-pack */
@font-face {
  font-family: 'Mallard';
  src: url('/fonts/font-pack/mallard/Mallard-Regular.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
  font-display: swap;
}
```

## Installation

```bash
# Create directory structure
mkdir -p /cdn/fonts/font-pack/mallard

# Download fonts
cd /cdn/fonts/font-pack/mallard
curl -O https://example.com/Mallard-Regular.ttf
curl -O https://example.com/Mallard-Bold.ttf
curl -O https://example.com/Mallard-Italic.ttf

# Update manifest.json
jq '.bundles["font-pack"].files += [...]' ../manifest.json > manifest.new.json && mv manifest.new.json ../manifest.json
```

## Credits
- **Mallard Family**: Vintage Fonts Archive (MIT License)
- [Add other font credits here]

## License
All fonts are licensed under their respective open-source licenses.
Check individual font documentation for details.