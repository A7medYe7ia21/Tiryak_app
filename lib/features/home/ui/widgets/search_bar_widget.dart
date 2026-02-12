import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback? onTap;
  final bool inHeader;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearch,
    this.onTap,
    this.inHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final input = SizedBox(
      height: inHeader ? 60 : null,
      child: TextField(
        controller: searchController,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: inHeader ? "Search..." : "Search medicines...",
          hintStyle: TextStyle(
              color: inHeader
                  ? Colors.grey
                  : theme.colorScheme.secondary.withOpacity(0.8)),
          prefixIcon: Icon(
            Icons.search,
            color: inHeader ? Colors.grey : theme.colorScheme.primary,
          ),
          filled: true,
          fillColor: theme.colorScheme.tertiary.withOpacity(0.06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inHeader ? 8 : 16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: inHeader ? 5 : 20,
            vertical: inHeader ? 0 : 15,
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: onTap != null
          ? GestureDetector(
              onTap: onTap,
              child: AbsorbPointer(child: input),
            )
          : input,
    );
  }
}
