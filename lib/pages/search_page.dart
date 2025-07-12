import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E3A8A), // Dark blue
            Color(0xFF3B82F6), // Lighter blue
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false, // Allow content to extend under navbar
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  60, // Account for navbar height
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Search',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Search content goes here',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 60), // Space for navbar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}