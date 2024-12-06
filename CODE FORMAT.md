# Code Format

A note for code formatting and style.

## Style:

- Tabs instead of spaces
- Global variables should be in `PascalCase`
- Local variables should be in `snake_case`
- Constatns should be in `UPPER_SNAKE_CASE`


## Naming

- All names should be clear, example `NodeShapes.register_layers_set(node_name)`
- All module (mod) names should start with `th_` prefix (except external mods)
- All assets used in project should have `th_` prefix. Assets should have unique names associated with their content. Assets can have subfolders for better organisation

## Docs

All public functions that are APIs should have docs, example:

```lua
--- Register a set of shapes for the node with radial meny to select them.
---@param source_node string Source node ID to copy parameters from.
---@param shapes table Shapes list where each shape is in format `{type: string, overrides: table (not required)}`.
---
--- **Available shape types:**
--- - "slab" - half cube node, can be placed on all 6 sides
--- - "panel" - quart cube node, can be placed on all 6 sides
--- - "stairs" - 2 connected cuboids node, can be placed on all 6 sides
--- - "pillar" - full cube node with rotations
--- - "thin_pillar" - thin decorative cube node with rotations
--- - "post" - thin cube node with rotations
--- - "wall" - thin cube node with connection to neigbours or solids
--- - "fence_flat" - very thin cube node with flat connection to neigbours or solids
--- - "fence_decorative" - very thin cube node with two small connection to neigbours or solids
--- - "frame" - square frame with borders to other nodes, has 3 directions
NodeShapes.register_shapes_set = function(source_node, shapes)
```