# Conjoint Design Specification: Menstrual Cycle Data-Sharing Vignettes

## Attributes and levels

| Attribute | Levels |
|---|---|
| sender | physician, athletic trainer, strength coach, sports scientist, head coach |
| purpose | health concern, load management, team readiness |
| recipient | no further sharing, physician, athletic trainer, strength coach, sports scientist, head coach, whole team |

## Constraint rules (restricted randomization)

| ID | Rule | Rationale |
|---|---|---|
| C1 | `purpose = 'health concern' -> sender in {physician, athletic trainer}` | Health-concern evaluation is clinical scope; strength coach/sports scientist/head coach lack the clinical basis to make this judgment. |
| C2a | `purpose = 'load management' -> sender in {strength coach, sports scientist, head coach}` | Load management (increase/reduce training) is within a performance role's normal authority, and also within a head coach's authority when the athlete discloses directly -- this represents an ethical, plausible self-disclosure pathway, distinct from a third party forwarding clinical data without the athlete's involvement. |
| C2b | `purpose = 'team readiness' -> sender in {strength coach, sports scientist}` | Team readiness requires aggregating data across the whole team, which is a performance-staff function, not something a head coach does from a single athlete's report. |
| C3 | `recipient != sender` | A role cannot 'pass along' information to itself; retention is represented separately as 'no further sharing.' |
| C4 | `purpose = 'health concern' -> recipient not in {sports scientist, whole team}` | Health-concern data reaching a non-clinical performance role or the entire team has no real-world analogue and is excluded as implausible. |
| C5 | `purpose = 'load management' -> recipient != whole team` | Load management is individual-level data; broadcasting it to the whole team has no plausible justification, unlike aggregate team readiness. |

## Feasibility count

- Full factorial (unconstrained): **105** combinations (5 senders x 3 purposes x 7 recipients)
- Feasible under C1-C5: **35** combinations
- Excluded: **70** combinations
- Matches the fielded 35-item vignette bank exactly: 8 clinical / 15 load management / 12 team readiness.

**Note on this revision:** head coach was added as a fifth sender level, valid only under load management (C2a), representing an athlete voluntarily disclosing directly to her coach for a practical training decision -- an ethical, plausible pathway, distinct from the existing unethical-but-plausible items where a physician or athletic trainer forwards a health concern to the head coach without the athlete's involvement. Head coach was deliberately NOT added as a sender for health concern, to avoid reintroducing the scope-of-practice problem removed earlier in this design process (a non-clinical role should not be modeled as 'evaluating' clinical data, regardless of who disclosed it).

## Marginal probabilities within the restricted space

Required for unbiased AMCE estimation.

**sender**
| Level | P(level) |
|---|---|
| physician | 0.1143 |
| athletic trainer | 0.1143 |
| strength coach | 0.3143 |
| sports scientist | 0.3143 |
| head coach | 0.1429 |

**purpose**
| Level | P(level) |
|---|---|
| health concern | 0.2286 |
| load management | 0.4286 |
| team readiness | 0.3429 |

**recipient**
| Level | P(level) |
|---|---|
| no further sharing | 0.2 |
| athletic trainer | 0.1714 |
| strength coach | 0.1429 |
| head coach | 0.1714 |
| physician | 0.1714 |
| sports scientist | 0.0857 |
| whole team | 0.0571 |

## Excluded profiles (for transparency / methods appendix)

| Sender | Purpose | Recipient | Constraint violated |
|---|---|---|---|
| physician | health concern | physician | C3: recipient cannot equal sender |
| physician | health concern | sports scientist | C4: health concern cannot route to a non-clinical performance role or the whole team |
| physician | health concern | whole team | C4: health concern cannot route to a non-clinical performance role or the whole team |
| physician | load management | no further sharing | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| physician | load management | physician | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| physician | load management | athletic trainer | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| physician | load management | strength coach | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| physician | load management | sports scientist | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| physician | load management | head coach | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| physician | load management | whole team | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| physician | team readiness | no further sharing | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| physician | team readiness | physician | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| physician | team readiness | athletic trainer | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| physician | team readiness | strength coach | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| physician | team readiness | sports scientist | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| physician | team readiness | head coach | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| physician | team readiness | whole team | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| athletic trainer | health concern | athletic trainer | C3: recipient cannot equal sender |
| athletic trainer | health concern | sports scientist | C4: health concern cannot route to a non-clinical performance role or the whole team |
| athletic trainer | health concern | whole team | C4: health concern cannot route to a non-clinical performance role or the whole team |
| athletic trainer | load management | no further sharing | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| athletic trainer | load management | physician | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| athletic trainer | load management | athletic trainer | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| athletic trainer | load management | strength coach | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| athletic trainer | load management | sports scientist | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| athletic trainer | load management | head coach | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| athletic trainer | load management | whole team | C2a: load management must be evaluated by a performance role or the head coach (direct athlete self-disclosure) |
| athletic trainer | team readiness | no further sharing | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| athletic trainer | team readiness | physician | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| athletic trainer | team readiness | athletic trainer | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| athletic trainer | team readiness | strength coach | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| athletic trainer | team readiness | sports scientist | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| athletic trainer | team readiness | head coach | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| athletic trainer | team readiness | whole team | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| strength coach | health concern | no further sharing | C1: health concern must be evaluated by a clinical role |
| strength coach | health concern | physician | C1: health concern must be evaluated by a clinical role |
| strength coach | health concern | athletic trainer | C1: health concern must be evaluated by a clinical role |
| strength coach | health concern | strength coach | C1: health concern must be evaluated by a clinical role |
| strength coach | health concern | sports scientist | C1: health concern must be evaluated by a clinical role |
| strength coach | health concern | head coach | C1: health concern must be evaluated by a clinical role |
| strength coach | health concern | whole team | C1: health concern must be evaluated by a clinical role |
| strength coach | load management | strength coach | C3: recipient cannot equal sender |
| strength coach | load management | whole team | C5: load management is individual-level data; cannot go to whole team |
| strength coach | team readiness | strength coach | C3: recipient cannot equal sender |
| sports scientist | health concern | no further sharing | C1: health concern must be evaluated by a clinical role |
| sports scientist | health concern | physician | C1: health concern must be evaluated by a clinical role |
| sports scientist | health concern | athletic trainer | C1: health concern must be evaluated by a clinical role |
| sports scientist | health concern | strength coach | C1: health concern must be evaluated by a clinical role |
| sports scientist | health concern | sports scientist | C1: health concern must be evaluated by a clinical role |
| sports scientist | health concern | head coach | C1: health concern must be evaluated by a clinical role |
| sports scientist | health concern | whole team | C1: health concern must be evaluated by a clinical role |
| sports scientist | load management | sports scientist | C3: recipient cannot equal sender |
| sports scientist | load management | whole team | C5: load management is individual-level data; cannot go to whole team |
| sports scientist | team readiness | sports scientist | C3: recipient cannot equal sender |
| head coach | health concern | no further sharing | C1: health concern must be evaluated by a clinical role |
| head coach | health concern | physician | C1: health concern must be evaluated by a clinical role |
| head coach | health concern | athletic trainer | C1: health concern must be evaluated by a clinical role |
| head coach | health concern | strength coach | C1: health concern must be evaluated by a clinical role |
| head coach | health concern | sports scientist | C1: health concern must be evaluated by a clinical role |
| head coach | health concern | head coach | C1: health concern must be evaluated by a clinical role |
| head coach | health concern | whole team | C1: health concern must be evaluated by a clinical role |
| head coach | load management | head coach | C3: recipient cannot equal sender |
| head coach | load management | whole team | C5: load management is individual-level data; cannot go to whole team |
| head coach | team readiness | no further sharing | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| head coach | team readiness | physician | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| head coach | team readiness | athletic trainer | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| head coach | team readiness | strength coach | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| head coach | team readiness | sports scientist | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| head coach | team readiness | head coach | C2b: team readiness aggregation is performed only by performance roles, not the head coach |
| head coach | team readiness | whole team | C2b: team readiness aggregation is performed only by performance roles, not the head coach |