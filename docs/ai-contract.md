# AI Feature Contract — Mental Zen

> **Status:** FROZEN  
> Any changes to inputs, outputs, thresholds, or evaluation metrics require explicit approval before implementation.

## 1. Specification & Data Contract

### Inputs
The Cloud Function callable endpoint (`generateDailyInsight`) accepts strictly sanitized, structured input payloads:
- `text`: String, maximum 1000 characters (validated client-side and server-side).
- `mood`: Integer, 1 to 5 (1 = very low, 5 = very high).
- `recentHistory`: Array of at most 14 objects representing the last 14 calendar days, restricted to:
  ```json
  [
    {
      "date": "2026-11-19",
      "mood": 4,
      "sentiment": 0.65
    }
  ]
  ```
  *Note:* No historical entry text is sent; only past numerical mood and sentiment scores are included to preserve user privacy and token bandwidth.

### Outputs
The model response must conform to the following schema:
- `sentiment`: Floating point number clamped strictly between `-1.0` and `1.0`.
- `topics`: Array of lowercase string tags (maximum 5 items, e.g., `["academics", "sleep", "relationships"]`).
- `insight`: String, maximum 160 characters (actionable, non-judgmental, reflective feedback).
- `confidence`: Enum, strictly one of `"low"`, `"medium"`, or `"high"`.

## 2. Deterministic Baseline Model
- **Implementation:** Pure offline Dart lexicon scorer (`lib/features/insight/domain/lexicon_scorer.dart`).
- **Lexicon details:** Approximately 200 curated mood stems with modifier weights:
  - Negation words (e.g., *not*, *never*, *no*, *hardly*) invert valence polarity.
  - Intensifier words (e.g., *very*, *extremely*, *completely*, *immensely*) amplify sentiment magnitude by 1.5x.
- **Characteristics:** Runs 100% offline, zero network latency, deterministic output, thoroughly unit-tested.
- The baseline score is computed and persisted for every entry, regardless of whether the remote AI model succeeds or fails.

## 3. Evaluation Benchmark
- **Test Set:** `assets/eval/entries.json` containing 30 human-labelled student journal entries:
  - 10 Positive examples (`label: 1`)
  - 10 Negative examples (`label: -1`)
  - 10 Adversarial edge cases (`label: -1`, `0`, or `1` across negation, sarcasm, double negation, emoji-only, one-word, past-vs-present, hedged, all-caps, understatement, clinical-neutral).
- **Core Evaluation Metrics:**
  - **Accuracy:** Overall categorical match against ground truth labels.
  - **Cohen's Kappa ($\kappa$):** Inter-annotator agreement accounting for chance agreement.
  - **p95 Latency:** 95th-percentile round-trip duration from client request to UI render.
  - **Fallback Rate:** Percentage of total requests falling back to the baseline scorer.

## 4. Documented Failure Modes
Complex linguistic phenomena frequently challenge the baseline and model. Three documented baseline failure patterns:
1. **Sarcastic Valence Inversion:** e.g., *"Oh fantastic, another four-hour debugging session where nothing works."* Lexicon sees "fantastic" and weights positive; model must identify contextual irony.
2. **Double Negative Relief:** e.g., *"I cannot say that I am not relieved."* Classical bag-of-words negators miscalculate polarity shifts.
3. **Past-vs-Present Emotional Arc:** e.g., *"Felt miserable this morning, but right now feeling calm and optimistic."* Unweighted token bags average contrasting sentiments instead of focusing on terminal current state.

## 5. Fallback Ladder & Degradation
1. **Trigger Conditions:**
   - Client-side or callable timeout exceeds 4.0 seconds.
   - Callable returns non-200 HTTP code (network down, rate limited, internal server error).
   - Model response confidence is parsed as `"low"` or below 0.6 threshold.
2. **Graceful Degradation Procedure:**
   - Display insight derived from the local Dart lexicon baseline.
   - Append a visible "Low Confidence" badge/chip to the insight card in the UI.
   - Record a non-fatal exception in Firebase Crashlytics with error code.
   - **Hard Rule:** Entry creation and persistence NEVER block or fail due to AI latency or errors.

## 6. Privacy & Redaction Standards
- **Opt-In Guard:** AI insights require explicit user toggle activation in Settings (`ai_enabled = true`).
- **PII Scrubbing:** Server-side callable and client preprocessing strip prospective personal names via capitalised name regex patterns before dispatching payloads to the model provider.
- **Provider Transparency:** LLM provider (Google Gemini API via Firebase Cloud Functions) and data retention parameters are clearly disclosed in `README.md`.
