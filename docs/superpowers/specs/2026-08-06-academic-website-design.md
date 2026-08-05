# Jiahui Chen Academic Website Design

## Goal

Replace the placeholder page with a polished bilingual academic website based on `Resume_Chenjiahui.pdf`. The site will present Jiahui Chen's academic profile, background, research, publications, skills, awards, and verified academic identity links in a concise format suitable for GitHub Pages.

## Information Architecture

The website contains three independent static pages with a shared header and footer:

- `index.html` — Home: introduction, current doctoral role, research focus, featured publication, and primary links.
- `about.html` — About: biography, education, professional skills, fieldwork and service, and selected awards.
- `research.html` — Research: research themes, peer-reviewed publication, working papers, and undergraduate projects.

The existing resume remains in the repository and is exposed as a downloadable PDF.

## Content Source and Accuracy

All biographical, education, research, publication, award, contact, and skill information comes from `Resume_Chenjiahui.pdf`. Wording may be edited for clarity and presentation, but facts will not be invented. The following user-provided identity links are authoritative:

- Google Scholar: `https://scholar.google.com/citations?user=tpFVbtoAAAAJ&hl=zh-CN`
- ORCID: `https://orcid.org/0000-0003-0874-3194`

The site will omit age, gender, phone number, and exact street address from prominent presentation because they are unnecessary for an academic public profile. Both email addresses from the resume may appear in the contact area.

## Visual Direction

The visual language is a modern research-institute aesthetic: warm ivory surfaces, deep ink green, and restrained energy-gold accents. Editorial serif display typography will be paired with a highly legible sans-serif body face. Fine grid lines, disciplined spacing, and subtle energy-flow motifs will create distinction without weakening academic credibility.

Motion is restrained: a staged page-load reveal, gentle link and card transitions, and respect for `prefers-reduced-motion`. The design will avoid stock photography and generic gradient-heavy templates.

## Shared Navigation and Bilingual Behavior

The header contains the name, links for Home, About, and Research, a visible English/中文 language control at the upper right, and a compact mobile navigation trigger.

English is the initial language. Switching language updates all page copy immediately and stores the selection in `localStorage`; the preference persists across page navigation and future visits. HTML `lang`, page title, navigation labels, accessibility labels, and button text change with the selected language. Content is not displayed side by side.

## Page Design

### Home

The opening composition introduces Jiahui Chen as a doctoral researcher in Applied Economics at Beijing Institute of Technology, focused on energy and environmental economics. A concise research statement and current affiliation lead into actions for Research, CV, Google Scholar, and ORCID. Below the hero, a featured research block highlights the 2023 *Energy* article and a compact research-interest strip introduces household energy transition, clean energy access, time use, and gender equality.

### About

The page begins with a short first-person professional biography derived from the resume. A vertical education timeline covers Beijing Institute of Technology and Beijing Forestry University. Secondary sections present software skills, field investigation and volunteer experience, and selected academic/competition awards. Dense CV material is edited into short, readable entries while retaining dates and distinctions.

### Research

Research themes are introduced before the publication list. Publications are grouped into peer-reviewed work, working papers, and undergraduate research projects. The published *Energy* article receives clear bibliographic treatment; working papers are explicitly labeled so their status is not overstated. Google Scholar and ORCID calls to action conclude the page.

## Technical Architecture

The implementation remains framework-free for reliable GitHub Pages hosting:

- Three semantic HTML files.
- One shared `assets/css/styles.css` stylesheet.
- One shared `assets/js/site.js` script for language switching, active navigation state, mobile navigation, and reveal behavior.
- Bilingual strings are stored in semantic HTML using `data-en` and `data-zh` attributes, with longer rich-text variants represented by paired language elements when needed.

The site requires no build step and no backend. External font loading will include robust fallbacks. All pages use relative links so they work both locally and at the GitHub Pages repository root.

## Accessibility, Responsiveness, and Failure Handling

Pages use landmarks, logical heading order, visible keyboard focus, sufficiently large controls, and WCAG-conscious color contrast. Layouts adapt from wide editorial grids to a single-column mobile presentation. Navigation and core content remain usable if JavaScript fails; English content is visible by default. External academic links open safely with `rel="noopener noreferrer"`. If font loading fails, the fallback stack preserves hierarchy and readability.

## Verification

Verification will include:

- Checking every internal page and asset link.
- Checking Scholar, ORCID, mail, and PDF links.
- Testing language persistence and translated navigation/title states.
- Testing desktop and narrow mobile layouts.
- Confirming keyboard navigation and reduced-motion behavior.
- Reviewing all public facts against the resume and supplied profile URLs.

## Scope

This version does not add a CMS, analytics, publication API, contact form, blog, portrait generation, or automatic Scholar synchronization. These can be considered later without changing the three-page foundation.
