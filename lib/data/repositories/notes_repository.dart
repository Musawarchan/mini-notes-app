import '../models/note_model.dart';
import '../../core/utils/storage_service.dart';
import '../../core/constants/app_constants.dart';

class NotesRepository {
  Future<List<NoteModel>> getNotes() async {
    final List<Map<String, dynamic>>? notesJson =
        StorageService.getJsonList(AppConstants.notesKey);

    if (notesJson == null) return [];

    return notesJson.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<void> saveNotes(List<NoteModel> notes) async {
    final List<Map<String, dynamic>> notesJson =
        notes.map((note) => note.toJson()).toList();

    await StorageService.setJsonList(AppConstants.notesKey, notesJson);
  }

  Future<void> addNote(NoteModel note) async {
    final List<NoteModel> notes = await getNotes();
    notes.add(note);
    await saveNotes(notes);
  }

  Future<void> updateNote(NoteModel note) async {
    final List<NoteModel> notes = await getNotes();
    final int index = notes.indexWhere((n) => n.id == note.id);

    if (index != -1) {
      notes[index] = note;
      await saveNotes(notes);
    }
  }

  Future<void> deleteNote(String noteId) async {
    final List<NoteModel> notes = await getNotes();
    notes.removeWhere((note) => note.id == noteId);
    await saveNotes(notes);
  }

  Future<NoteModel?> getNoteById(String noteId) async {
    final List<NoteModel> notes = await getNotes();
    try {
      return notes.firstWhere((note) => note.id == noteId);
    } catch (e) {
      return null;
    }
  }
}
