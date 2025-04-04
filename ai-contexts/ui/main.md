# UI Layout Description

The following represents the layout of the game board, divided into rows for both the opponent and the player. Each row corresponds to a specific type of unit placement:

- **Siege Row**: For siege units.
- **Ranged Row**: For ranged units.
- **Close Combat Row**: For close combat units.

## Base UI

```
       Weather     Boosts                     Playable Units                   Row Power  Total Power
    --------------------------------------------------------------------------------------------------
    |           |           |                   Siege Row                    |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |                   Range Row                    |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |                Close Combat Row                |           |           |
    --------------------------------------------------------------------------------------------------
    |           |           |                Close Combat Row                |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |                   Range Row                    |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |                   Siege Row                    |           |           |
    --------------------------------------------------------------------------------------------------

    Cards
    Weather, Horn, Common, Bond, Shield
    Clear, Morale, Hero, Bond.H, Morale.H
```

## Component alignment

```

                                              Player 2 - ○○
    --------------------------------------------------------------------------------------------------
    |           |           |                                                |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |                                                |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |                                                |           |           |
    --------------------------------------------------------------------------------------------------
    |           |           |                                                |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |                                                |           |           |
    |-----------|-----------|------------------------------------------------|-----------|           |
    |           |           |                                                |           |           |
    --------------------------------------------------------------------------------------------------
                                              Player 1 - ○○

    Time Left: 00:00:00.0                                                                       <icon>

    --------------------------------------------------------------------------------------------------
    |                                            <Button 1>                                          |
    --------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------
    |                                            <Button 2>                                          |
    --------------------------------------------------------------------------------------------------

```

## Core Components

### Game Board (BoardSection)

The central game area displaying both players' card rows. Each player has three rows:

- **Siege Row**: Units that attack from long range
- **Ranged Row**: Units that attack from medium range
- **Close Combat Row**: Units that engage in melee combat

Each row displays:

- Weather effects (left)
- Boost effects like Horn (center-left)
- Played cards (center)
- Row power total (right)
- Running total power (far right)

### Round Tracker

Displays the current round number and round wins for each player using circular indicators:

- Filled circle: Round won
- Empty circle: Round not yet won

### Chess Clock (TimerSection)

Displays remaining time for each player in the format MM:SS.S

- Active player's timer counts down
- Timer changes color when time is running low
- Supports pausing and resetting

### Game Actions

- **Pass Button**: End your turn and pass for the remainder of the round
- **Timer Control**: Start/pause the active timer
- **Settings**: Access game settings and timer configuration

### Modals and Overlays

#### Timer Selection Dialog

Allows players to:

- Set custom time limits for each player
- Choose from preset time controls (e.g., 5 min, 10 min)
- Enable/disable timing features

#### Coin Flip Modal

Animation and display for determining which player goes first:

- Shows coin flip animation
- Announces the result
- Provides button to start the game

#### Toast Notifications

Popup messages that:

- Display important game events
- Show errors or warnings
- Automatically dismiss after a few seconds
- Can be manually dismissed

## User Interaction Flow

1. **Game Start**:

   - Players select time controls if desired
   - Coin flip determines starting player
   - Round 1 begins

2. **During Play**:

   - Active player places cards on appropriate rows
   - Power totals update in real-time
   - Timer counts down for active player
   - Toast notifications appear for significant events

3. **Round End**:

   - Round winner determined by highest power total
   - Round tracker updates
   - Board resets for next round

4. **Game End**:
   - Player winning 2 rounds wins the match
   - Final score displayed
   - Option to start new game

## Responsive Design

The UI adapts to different screen sizes following these principles:

- On smaller screens (≤320px width): UI elements scale down by 20%
- On standard screens (321-427px): Default sizing
- On larger screens (≥428px): UI elements scale up by 20%

This ensures optimal usability across various devices while maintaining the game's visual integrity.
