# UI Layout Description

The following represents the layout of the game board, divided into rows for both the opponent and the player. Each row corresponds to a specific type of unit placement:

- **Siege Row**: For siege units.
- **Ranged Row**: For ranged units.
- **Melee Row**: For melee units.

## Base UI

```
       Weather     Boosts                     Playable Units                   Row Power  Total Power
    --------------------------------------------------------------------------------------------------
    |           |           |              Player 2's Siege Row              |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |              Player 2's Range Row              |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |              Player 2's Melee Row              |           |           |
    --------------------------------------------------------------------------------------------------
    |           |           |              Player 1's Melee Row              |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |              Player 1's Range Row              |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |              Player 1's Siege Row              |           |           |
    --------------------------------------------------------------------------------------------------

    Cards
    Weather, Horn, Common, Bond, Shield
    Clear, Morale, Hero, Bond.H, Morale.H

```
