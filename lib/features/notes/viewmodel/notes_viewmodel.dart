import 'package:flutter/material.dart';
import '../../../data/models/note_model.dart';
import '../../../data/repositories/notes_repository.dart';

class NotesViewModel extends ChangeNotifier {
  final NotesRepository _repository = NotesRepository();

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _error;
  NoteModel? _deletedNote;
  int? _deletedNoteIndex;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  NoteModel? get deletedNote => _deletedNote;
  int? get deletedNoteIndex => _deletedNoteIndex;

  Future<void> loadNotes() async {
    _setLoading(true);
    _setError(null);

    try {
      _notes = await _repository.getNotes();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load notes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addNote(String title, String description) async {
    if (title.trim().isEmpty) {
      _setError('Title cannot be empty');
      return;
    }

    _setError(null);

    try {
      final note = NoteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        description: description.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.addNote(note);
      await loadNotes();
    } catch (e) {
      _setError('Failed to add note: $e');
    }
  }

  Future<void> updateNote(
      String noteId, String title, String description) async {
    if (title.trim().isEmpty) {
      _setError('Title cannot be empty');
      return;
    }

    _setError(null);

    try {
      final note = NoteModel(
        id: noteId,
        title: title.trim(),
        description: description.trim(),
        createdAt: _notes.firstWhere((n) => n.id == noteId).createdAt,
        updatedAt: DateTime.now(),
      );

      await _repository.updateNote(note);
      await loadNotes();
    } catch (e) {
      _setError('Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final noteIndex = _notes.indexWhere((note) => note.id == noteId);
      if (noteIndex != -1) {
        _deletedNote = _notes[noteIndex];
        _deletedNoteIndex = noteIndex;

        await _repository.deleteNote(noteId);
        await loadNotes();
      }
    } catch (e) {
      _setError('Failed to delete note: $e');
    }
  }

  Future<void> undoDelete() async {
    if (_deletedNote != null && _deletedNoteIndex != null) {
      try {
        await _repository.addNote(_deletedNote!);
        await loadNotes();
        _deletedNote = null;
        _deletedNoteIndex = null;
      } catch (e) {
        _setError('Failed to undo delete: $e');
      }
    }
  }

  void clearDeletedNote() {
    _deletedNote = null;
    _deletedNoteIndex = null;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
