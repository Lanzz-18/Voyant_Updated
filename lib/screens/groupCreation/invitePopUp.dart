import 'package:flutter/material.dart';

// ── How to use ────────────────────────────────────────────────────────────────
//
// Call showAcceptInvitePopup() whenever an incoming invite is received,
// passing in the inviter's name, trip name, and group size:
//
//   showAcceptInvitePopup(
//     context,
//     inviterName: 'Alex M.',
//     tripName: 'Galle Fort Explorer',
//     groupSize: 4,
//   );
//
// Navigation hooks are inside _AcceptInviteDialogState:
//   • _onAccept()  (~line 75)  — fires when Accept is tapped
//   • _onDecline() (~line 83)  — fires when Decline is tapped
//
// ─────────────────────────────────────────────────────────────────────────────

void showAcceptInvitePopup(
  BuildContext context, {
  required String inviterName,
  required String tripName,
  required int groupSize,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (_) => _AcceptInviteDialog(
      inviterName: inviterName,
      tripName: tripName,
      groupSize: groupSize,
    ),
  );
}

// ============================================================
// ACCEPT INVITE DIALOG
// ============================================================

class _AcceptInviteDialog extends StatefulWidget {
  const _AcceptInviteDialog({
    required this.inviterName,
    required this.tripName,
    required this.groupSize,
  });

  final String inviterName;
  final String tripName;
  final int groupSize;

  @override
  State<_AcceptInviteDialog> createState() => _AcceptInviteDialogState();
}

class _AcceptInviteDialogState extends State<_AcceptInviteDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  // ── HOOK 1 — Accept ───────────────────────────────────────
  // Closes the dialog then navigates the user into the trip.
  void _onAccept() {
    Navigator.of(context).pop();

    // ✏️ ADD ACCEPT NAVIGATION HERE — e.g.:
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => const TripScreen()),
    // );
  }

  // ── HOOK 2 — Decline ──────────────────────────────────────
  // Closes the dialog then notifies your backend/service.
  void _onDecline() {
    Navigator.of(context).pop();

    // ✏️ ADD DECLINE LOGIC HERE — e.g.:
    // tripService.declineInvite(inviteId);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF120A2E),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Invite icon ──────────────────────────
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.group_add_rounded,
                  color: Color(0xFF7C3AED),
                  size: 30,
                ),
              ),

              const SizedBox(height: 20),

              // ── Title ────────────────────────────────
              const Text(
                'Trip Invite',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 8),

              // ── Subtitle ─────────────────────────────
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFFB0A8D8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: widget.inviterName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                        text: ' has invited you\nto join their trip'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Trip info card ────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF160D2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2D2550),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Trip name row
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF52B5E0)
                                .withValues(alpha: 0.15),
                          ),
                          child: const Icon(
                            Icons.map_outlined,
                            color: Color(0xFF52B5E0),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TRIP',
                                style: TextStyle(
                                  color: Color(0xFFB0A8D8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.tripName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 1,
                      color: const Color(0xFF2D2550),
                    ),

                    const SizedBox(height: 12),

                    // Group size row
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF7C3AED)
                                .withValues(alpha: 0.15),
                          ),
                          child: const Icon(
                            Icons.group_rounded,
                            color: Color(0xFF7C3AED),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'GROUP SIZE',
                              style: TextStyle(
                                color: Color(0xFFB0A8D8),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.groupSize} players',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Decline / Accept buttons ──────────────
              Row(
                children: [
                  // Decline — smaller, muted
                  Expanded(
                    child: GestureDetector(
                      onTap: _onDecline,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color(0xFF160D2E),
                          border: Border.all(
                            color: const Color(0xFF2D2550),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Decline',
                          style: TextStyle(
                            color: Color(0xFFB0A8D8),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Accept — larger, purple, prominent
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _onAccept,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color(0xFF7C3AED),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED)
                                  .withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Accept',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}