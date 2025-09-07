import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/notes_viewmodel.dart';
import '../widgets/note_card.dart';
import '../widgets/add_edit_note_dialog.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesViewModel>(
      builder: (context, viewModel, child) {
        // Load notes when the view is first built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.notes.isEmpty && !viewModel.isLoading) {
            viewModel.loadNotes();
          }
        });

        return Scaffold(
          body: _buildBody(context, viewModel),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () => _showAddNoteDialog(context),
              backgroundColor: Colors.transparent,
              elevation: 0,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Note'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NotesViewModel viewModel) {
    if (viewModel.isLoading && viewModel.notes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null && viewModel.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.error!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadNotes(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (viewModel.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.note_add_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No notes yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first note',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [
            //         Theme.of(context).colorScheme.primary,
            //         Theme.of(context).colorScheme.primary.withOpacity(0.8),
            //       ],
            //     ),
            //     borderRadius: BorderRadius.circular(24),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(
            //         Icons.add_circle_outline,
            //         color: Theme.of(context).colorScheme.onPrimary,
            //       ),
            //       const SizedBox(width: 8),
            //       Text(
            //         'Create Note',
            //         style: Theme.of(context).textTheme.labelLarge?.copyWith(
            //               color: Theme.of(context).colorScheme.onPrimary,
            //               fontWeight: FontWeight.w600,
            //             ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadNotes(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.notes.length,
        itemBuilder: (context, index) {
          final note = viewModel.notes[index];
          return NoteCard(
            note: note,
            onEdit: () => _showEditNoteDialog(context, note),
            onDelete: () => _deleteNote(context, viewModel, note),
          );
        },
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddEditNoteDialog(),
    );
  }

  void _showEditNoteDialog(BuildContext context, note) {
    showDialog(
      context: context,
      builder: (context) => AddEditNoteDialog(note: note),
    );
  }

  void _deleteNote(BuildContext context, NotesViewModel viewModel, note) {
    viewModel.deleteNote(note.id);

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => viewModel.undoDelete(),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
