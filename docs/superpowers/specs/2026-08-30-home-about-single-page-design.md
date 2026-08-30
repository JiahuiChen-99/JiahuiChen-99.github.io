# Home and About Single-Page Design

## Goal and scope

Consolidate the Home and About pages into `index.html`, making the homepage the single primary profile page. Keep `research.html` as the separate publications page. Delete `about.html` without adding a redirect, as requested.

## Homepage information architecture

Use this order:

1. About Me profile introduction, portrait, research focus, job-market statement, and academic links.
2. Education.
3. Upcoming presentations and trips.
4. Selected honors.
5. Academic service.

Replace the current compact Education list with the more detailed dated Education entries from `about.html`. Move Selected honors and Academic service from `about.html` into the homepage. Do not move the old About-page introduction or Research interests section because the homepage already contains the author-approved biography and research-focus wording.

## Navigation and page lifecycle

- Remove the About link from the headers of `index.html` and `research.html`.
- Keep only Home and Research in primary navigation.
- Delete `about.html` completely.
- Do not create a redirect or compatibility page for the old About URL.
- Preserve bilingual navigation labels and automatic current-page behavior.

## Content and presentation

- Preserve all existing bilingual Education, Selected honors, and Academic service content when moving it.
- Preserve the current homepage portrait, links, job-market statement, upcoming AEA trip, footer, styling, and responsive layout.
- Reuse the existing `dated-list` and `plain-section` components; no visual redesign or unrelated CSS refactor is included.

## Verification

- Update `tests/verify-site.ps1` so only `index.html` and `research.html` are required HTML pages.
- Assert that no remaining page links to `about.html`.
- Assert that the homepage contains Education, Selected honors, Academic service, and the updated research focus.
- Run automated verification and browser checks at desktop and mobile widths in English and Chinese.
- Confirm that the deployed homepage contains the merged sections and the deployed navigation no longer links to About.
