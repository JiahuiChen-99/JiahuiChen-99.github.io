# CV PDF Replacement Design

## Decision

Keep the stable public URL `Resume_Chenjiahui.pdf` and publish the contents supplied in `Jiahui Chen_CV.pdf`. The two local files currently have the same SHA-256 hash, so no HTML link change is needed.

## File handling

- Commit the modified tracked file `Resume_Chenjiahui.pdf`.
- Leave the duplicate untracked source file `Jiahui Chen_CV.pdf` in the user workspace and do not publish it.
- Do not delete or modify other CV, Word, screenshot, or Chinese résumé files.

## Verification

- Confirm the published PDF is valid, A4, unencrypted, and three pages.
- Confirm Home and Research continue linking to `Resume_Chenjiahui.pdf`.
- Confirm the local tracked PDF and supplied source PDF have identical SHA-256 hashes.
- Push `main`, download the deployed PDF, and confirm its SHA-256 matches the supplied source.
