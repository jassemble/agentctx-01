# Lint Checklist -- Brain Verifier Rubric

Swappable rubric: the Verifier reads this file to determine what gets checked.

| # | Check | Criterion | Severity | Machine-verifiable |
|---|-------|-----------|----------|--------------------|
| 1 | Broken wikilinks | Every [[type:name]] resolves to a file | ERROR | Yes |
| 2 | Stale modules | source-hash matches current git hash | WARNING | Yes |
| 3 | Orphan entities | Entity has >=1 inbound wikilink | WARNING | Yes |
| 4 | Missing modules | Every source dir has a module page | ERROR | Yes |
| 5 | Pattern drift | Claims in patterns.md match code | WARNING | Partial |
| 6 | Token overflow | No page exceeds 30K tokens | WARNING | Yes |
| 7 | Protocol bloat | protocol.md under 500 tokens | ERROR | Yes |
| 8 | Contradiction | No opposite facts about same entity | WARNING | Partial |
| 9 | Orphan concepts | Concept has >=1 inbound wikilink | INFO | Yes |
| 10 | Stale log | Last entry <=7 days old | INFO | Yes |
| 11 | Missing verification | status.md has entry for every module | WARNING | Yes |
| 12 | Low-confidence edges | INFERRED < 0.5 flagged for review | INFO | Yes |
| 13 | EXTRACTED edge validity | Edges resolve to code refs | WARNING | Yes |
| 14 | Community map staleness | Clusters match module relationships | WARNING | Partial |

## Severity Levels

- **ERROR**: Must fix before sync completes.
- **WARNING**: Should fix. Reported but does not block.
- **INFO**: Informational.
