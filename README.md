# \# PROJECT: NEO-BUSHI

# \## A Heavy-Weight Rogue-lite Survival Action Game

# \*\*Current Development Phase:\*\* Pre-Alpha / Vertical Slice Prep

# 

# \---

# 

# \### THE VISION

# NEO-BUSHI is a tactical survival game centered on "Juice" and mechanical weight. Humanity has retreated to a cloaked lunar research facility to deploy a final hope: a massive, hydraulic-powered warrior sent to reclaim Earth from a superior invading force.

# 

# \---

# 

# \### PROJECT STATUS \& ACTIVE SPRINT

# We are currently building \*\*Level 0: The Moon Proving Grounds\*\*. This phase focuses on the "Inertia \& Impact" system—ensuring the mech feels massive and the combat feels visceral.

# 

# \#### 1. ENVIRONMENT (Implemented)

# \* \*\*Global Lunar Surface:\*\* Utilizes a seamless 1024x1024 high-grit lunar texture.

# \* \*\*Tiling Architecture:\*\* Optimized for massive 10,000 x 10,000 play areas using UV scaling to maintain visual fidelity with zero VRAM bloat.

# 

# \#### 2. THE "INERTIA" MOVEMENT SYSTEM (In Progress)

# \* \*\*Mechanical Weight:\*\* Unlike traditional "snappy" survivors, the Neo-Bushi operates on an acceleration/friction curve to simulate 50 tons of hydraulic steel.

# \* \*\*Physics-Based Handling:\*\* Features "wind-up" starting speeds and "slide" deceleration, forcing players to master the momentum of the machine.

# 

# \#### 3. DISMEMBERMENT \& FEEDBACK (In Progress)

# \* \*\*Modular Enemy Logic:\*\* Enemies are designed as multi-part entities.

# \* \*\*Limb Ejection:\*\* Utilizing a "Pop \& Swap" method—upon critical impact, limb sprites are instantiated as physics-enabled debris with high-velocity impulses.

# \* \*\*Dynamic Bloodbath:\*\* Strategic use of static decals for persistent blood and debris, ensuring the screen becomes a "battlefield" without sacrificing frame rate.

# 

# \---

# 

# \### TECHNICAL STANDARDS (Developer Notes)

# To ensure longevity and community-driven updates, this project follows a \*\*Strict Modular Architecture\*\*:

# 

# \* \*\*Component-Based Design:\*\* Functionality is broken into reusable nodes (e.g., HealthComponent, GoreComponent, InertiaController).

# \* \*\*Data-Driven Stats:\*\* All mechanical variables (Speed, HP, Upgrade Costs) are externalized to Resources/JSON files for rapid balancing.

# \* \*\*Signal-Driven UI:\*\* Decoupled HUD logic for easy "Skinning" between Moon, Earth, and future Dungeon modes.

# 

# \---

# 

# \### THE ROAD TO v1.0

# 1\. \*\*The Moon Threshold:\*\* Survive 15 minutes and defeat the Lunar Sentry to unlock Earth deployment.

# 2\. \*\*The Global Liberation Map:\*\* 6 distinct Earth Regions (The Neon Crater, The Amazonian Scrap-Jungle, etc.).

# 3\. \*\*The 0.05% Factor:\*\* Implementation of the "Overdrive" rare drop—triggering localized time-dilation and speed-cap removal.

# 4\. \*\*Dungeon Mode (Post-Launch):\*\* Procedural subterranean exploration for end-game depth.

# 

# \---

# 

# \### DEVELOPMENT ETHICS

# \* \*\*No Microtransactions:\*\* A pure "Supporter Pack" model to fund long-term development.

# \* \*\*Community-First:\*\* Mechanical balance is dictated by pilot feedback.

