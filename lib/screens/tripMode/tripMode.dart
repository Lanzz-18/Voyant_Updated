import 'package:flutter/material.dart';

// ── Navigation hooks summary ──────────────────────────────────────────────────
//
//  Hook 1 — Solo  → _onSoloSelected()  (~line 55)
//  Hook 2 — Group → _onGroupSelected() (~line 64)
//  Hook 3 — START → _onStart()         (~line 73)
//                   (calls Hook 1 or 2 depending on selection)
//
// Add your Navigator.push / Navigator.pushReplacement calls
// inside hooks 1 and 2 — hook 3 handles itself automatically.
//
// ─────────────────────────────────────────────────────────────────────────────

class TripModeScreen extends StatefulWidget {
  const TripModeScreen({super.key});

  @override
  State<TripModeScreen> createState() => _TripModeScreenState();
}

class _TripModeScreenState extends State<TripModeScreen>
    with SingleTickerProviderStateMixin {
  // null = nothing selected, false = solo, true = group
  bool? _selected;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ── NAVIGATION HOOK 1 — Solo ──────────────────────────────
  // Fires when the Solo card is tapped OR when START is pressed
  // after Solo is selected. Add your navigation call below the
  // setState line.
  void _onSoloSelected() {
    setState(() => _selected = false);

    // ✏️ ADD SOLO NAVIGATION HERE — e.g.:
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => const SoloTripScreen()),
    // );
  }

  // ── NAVIGATION HOOK 2 — Group ─────────────────────────────
  // Fires when the Group card is tapped OR when START is pressed
  // after Group is selected. Add your navigation call below the
  // setState line.
  void _onGroupSelected() {
    setState(() => _selected = true);

    // ✏️ ADD GROUP NAVIGATION HERE — e.g.:
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
    // );
  }

  // ── NAVIGATION HOOK 3 — START button ─────────────────────
  // No changes needed here — it delegates to hook 1 or 2.
  void _onStart() {
    if (_selected == null) return;
    if (_selected == false) {
      _onSoloSelected();
    } else {
      _onGroupSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A1E),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),

                // ── Header ───────────────────────────────
                const Text(
                  'Quest Selection',
                  style: TextStyle(
                    color: Color(0xFFB0A8D8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'How are you\nTravelling?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    height: 1.2,
                  ),
                ),

                const Spacer(),

                // ── Two icon cards side by side ──────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Solo card
                      Expanded(
                        child: _ModeCard(
                          isSelected: _selected == false,
                          icon: Icons.person_rounded,
                          label: 'Solo',
                          accentColor: const Color(0xFF7C3AED),
                          onTap: _onSoloSelected,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Group card
                      Expanded(
                        child: _ModeCard(
                          isSelected: _selected == true,
                          icon: Icons.group_rounded,
                          label: 'Group',
                          accentColor: const Color(0xFF52B5E0),
                          onTap: _onGroupSelected,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── START button ─────────────────────────
                GestureDetector(
                  onTap: _selected != null ? _onStart : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: _selected != null
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF160D2E),
                      border: Border.all(
                        color: _selected != null
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF2D2550),
                        width: 1.5,
                      ),
                      boxShadow: _selected != null
                          ? [
                              BoxShadow(
                                color: const Color(0xFF7C3AED)
                                    .withValues(alpha: 0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        color: _selected != null
                            ? Colors.white
                            : const Color(0xFF2D2550),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                      child: const Text('START'),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MODE CARD
// ============================================================

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.isSelected,
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  final bool isSelected;
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 52),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.1)
              : const Color(0xFF160D2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFF2D2550),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 28,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? accentColor.withValues(alpha: 0.18)
                    : const Color(0xFF2D2550),
                border: Border.all(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.5)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? accentColor : const Color(0xFFB0A8D8),
                size: 34,
              ),
            ),

            const SizedBox(height: 16),

            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color:
                    isSelected ? Colors.white : const Color(0xFFB0A8D8),
                fontSize: 16,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.3,
              ),
              child: Text(label),
            ),

            const SizedBox(height: 6),

            // Selection dot
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}