Zen Ball
===

##Classes
- Map
  - tile_width (int)
  - tile_height (int)
  - sections (DictGrid)
  - mask_data (configuration)
- Section
  - x (int)
  - y (int)
  - width (int)
  - height (int)
  - tiles (Grid)
- Tile
  - section (Section)
  - x (int)
  - y (int)
  - bit_value (bit)
  - masked_value (int)
