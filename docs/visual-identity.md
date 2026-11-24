# WatchAtlas (Flutter) visual identity

WatchAtlas pairs a restrained media-library canvas with a recognizable
cyan-to-purple brand gradient. The dark mode uses ink-black surfaces; light
mode uses warm paper colors. Movie status, rating, and recommendation colors
remain semantic rather than being replaced by the brand accent.

| Role | Color |
| --- | --- |
| Dark background / surface | ![#0F1115](https://img.shields.io/badge/-%230F1115?style=flat-square&color=0F1115) `#0F1115` / `#171A21` |
| Light background / surface | ![#FDFBF7](https://img.shields.io/badge/-%23FDFBF7?style=flat-square&color=FDFBF7) `#FDFBF7` / `#F5F0EB` |
| Interactive accent | ![#00B8FF](https://img.shields.io/badge/-%2300B8FF?style=flat-square&color=00B8FF) `#00B8FF` |
| Brand gradient | ![#00D4FF](https://img.shields.io/badge/-%2300D4FF?style=flat-square&color=00D4FF) cyan → ![#8B5CF6](https://img.shields.io/badge/-%238B5CF6?style=flat-square&color=8B5CF6) purple |

The app theme is defined in
[`lib/core/theme/app_theme.dart`](../lib/core/theme/app_theme.dart), with
centralized semantic colors in
[`lib/core/constants/app_colors.dart`](../lib/core/constants/app_colors.dart).
The brand mark is in [`assets/images/logo/`](../assets/images/logo/).
