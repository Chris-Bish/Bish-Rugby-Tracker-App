# Bishopton RFC Team Tracker

A progressive web app for managing player records, match history, squad selection and live match tracking for Bishopton RFC.

## Live App
https://chris-bish.github.io/Bish-Rugby-Tracker-App/

## Tech Stack
- Single-file HTML/CSS/JS app hosted on GitHub Pages
- Supabase (PostgreSQL) for data storage
- No build step — edit `index.html` and push to deploy

## Database
Hosted on Supabase. Tables:

| Table | Description |
|-------|-------------|
| `players` | Player profiles, positions, appearance counts |
| `matches` | Fixtures, scores and results across all seasons |
| `squads` | Positional squad data (shirt numbers) per match |
| `attendance` | Who was present at each match |
| `season_appearances` | Per-season appearance counts per player |
| `try_scorers` | One row per try scored |
| `kicking` | Conversions, penalties and drop goals (type column) |
| `yellow_cards` | Yellow card records per match |
| `red_cards` | Red card records per match |
| `training` | Training session attendance |

## Data Coverage

| Data | From | Notes |
|------|------|-------|
| Match results | 2013/14 | All seasons complete |
| Attendance/appearances | 2018/19 | From SCRUMS PDFs |
| Squad positional data | 2024/25 | Shirt numbers per match |
| Try scorer data | 2022/23 | Per-match for 22/23, 24/25, 25/26; season totals for 23/24 |
| Kicking data | 2024/25 | Entered via match edit screen going forward |
| MoM / Bishy Way | 2024/25 | Earlier seasons populated manually |

## Key Player Normalisations
These duplicate/alias issues have been resolved in the database:

- **Jack McDermid** (id=59) — also known as Jack Burns; keep McDermid
- **Jamie MacMillan** (id=214) — also stored as Jamie McMillan / James Macmillan; keep MacMillan
- **Patrick McReynolds** (id=65) — was stored as McRey; now fixed
- **Robbie De Venny** (id=20) — sometimes stored without space as DeVenny
- **Chris Lee** (id=49) — full name Christopher Lee in some SCRUMS PDFs
- **Chris Dunn** (id=87) — full name Christopher Dunn in some SCRUMS PDFs
- **Stevie Phillips** (id=251) — also listed as Stephen Phillips; keep Stevie
- **Matt Wallace** (id=224) — also listed as Matthew Wallace; keep Matthew (505 caps)
- **Ally Dick** (id=22) ≠ **Alexander Dick** (id=261) — different people

## Dual-Registered Players
These players appear in SCRUMS PDFs under other clubs but are registered with Bishopton and should be included in all squad data:

| Player | Other Club |
|--------|-----------|
| Rhys Wilson | Glasgow Academicals RFC |
| Harris Clark | GHK RFC |
| Sione Halafihi | Glasgow Hawks RFC |
| Peter Duncan | Hillfoots RFC |
| Robert De Venny | Glasgow Academicals RFC |
| Louis Fraser | Carrick RFC |
| Jamie MacMillan | Edinburgh Academical FC |
| Dylan Muir | Waid Academy FP RFC |
| Charlie MacKinnon | West of Scotland FC |
| Cameron Seed | West of Scotland FC |
| Ryan Moore | GHK RFC |
| Charlie MacLean-Bristol | Birkmyre RFC |
| Mark Thomson | Garnock RFC |
| Glyn Roberts | Clydebank RFC |
| Ali Peterson | Mid Argyll RFC |

## Adding a New Season
1. Add match rows via the app or SQL
2. Run SCRUMS PDFs through Claude to generate squad SQL files
3. Run squad SQL in Supabase SQL editor
4. Update scores and results via the match edit screen
5. Enter try scorers, conversions and penalties via match edit screen

## Season Appearances Note
The `season_appearances` table is rebuilt from attendance data. Lifetime
totals in `players.appearances` are set from the historical spreadsheet
and cover all seasons back to the club's early records. The two figures
may not match exactly for older players whose pre-digital appearances
predate the SCRUMS system.

## Known Data Gaps
- 2013/14–2017/18: scores only, no squad or attendance data
- 2019/20: 12 matches in DB vs ~21 expected (Covid cancellations)
- 2023/24: try scorer data is season totals only, not per-match
- Glen Sutherland (2023/24, 9 tries): no attendance records in DB
- Kicking data (conversions/penalties/drop goals): being entered retrospectively

## Environment
No environment variables needed — the Supabase URL and anon key are
hardcoded in `index.html`. The anon key is safe to expose publicly as
Supabase row-level security controls data access.

## Maintenance
Built and maintained by Bishopton RFC coaching staff.
Historical data sourced from:
- Scottish Rugby SCRUMS system (team sheets)
- Club spreadsheet records (appearances and points)
- Scottish Rugby website (match scores)
