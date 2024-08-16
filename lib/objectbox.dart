import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'model.dart';
import 'objectbox.g.dart'; // created by `dart run build_runner build`
// `dart run build_runner build` によって作成されました

/// Provides access to the ObjectBox Store throughout the app.
/// アプリ全体で ObjectBox ストアにアクセスできるようにします。
/// Create this in the apps main function.
/// アプリの main 関数でこれを作成します。
class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<Note> _noteBox;

  ObjectBox._create(this._store) {
    _noteBox = Box<Note>(_store);

    // Add some demo data if the box is empty.
    // ボックスが空の場合は、いくつかのデモデータを追加します。
    if (_noteBox.isEmpty()) {
      _putDemoData();
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  /// アプリ全体で使用する ObjectBox のインスタンスを作成します。
  static Future<ObjectBox> create() async {
    // Note: setting a unique directory is recommended if running on desktop
    // platforms. If none is specified, the default directory is created in the
    // users documents directory, which will not be unique between apps.
    // On mobile this is typically fine, as each app has its own directory
    // structure.
    // 注：デスクトッププラットフォームで実行する場合は、ユニークなディレクトリを設定することをお勧めします。
    // 指定しない場合、デフォルトのディレクトリがユーザーのドキュメントディレクトリに作成されますが、
    // これはアプリ間で一意ではありません。

    // Note: set macosApplicationGroup for sandboxed macOS applications, see the
    // info boxes at https://docs.objectbox.io/getting-started for details.
    // 注：macOS アプリケーションのサンドボックス化には macosApplicationGroup を設定します。
    // 詳細については、https://docs.objectbox.io/getting-started の情報ボックスを参照してください。

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    // 生成された objectbox.g.dart には Future<Store> openStore() {...} が定義されています。
    final store = await openStore(
        directory:
            p.join((await getApplicationDocumentsDirectory()).path, "obx-demo"),
        macosApplicationGroup: "objectbox.demo");
    return ObjectBox._create(store);
  }

  void _putDemoData() {
    final demoNotes = [
      Note('Quickly add a note by writing text and pressing Enter'),
      Note('Delete notes by tapping on one'),
      Note('Write a demo app for ObjectBox')
    ];
    _noteBox.putManyAsync(demoNotes);
  }

  Stream<List<Note>> getNotes() {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries
    // すべてのノートをクエリし、日付でソートします。
    // https://docs.objectbox.io/queries
    final builder = _noteBox.query().order(Note_.date, flags: Order.descending);
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    // クエリをビルドして監視し、
    // triggerImmediately を設定してリッスン時にクエリをすぐに発行します。
    return builder
        .watch(triggerImmediately: true)
        // Map it to a list of notes to be used by a StreamBuilder.
        // StreamBuilder で使用されるノートのリストにマップします。
        .map((query) => query.find());
  }

  /// Add a note.
  ///
  /// To avoid frame drops, run ObjectBox operations that take longer than a
  /// few milliseconds, e.g. putting many objects, asynchronously.
  /// For this example only a single object is put which would also be fine if
  /// done using [Box.put].
  /// フレームのドロップを回避するために、数ミリ秒以上かかる ObjectBox 操作（たとえば、多くのオブジェクトを配置する操作）を非同期で実行します。
  /// この例では、1 つのオブジェクトだけを配置するので、[Box.put] を使用しても問題ありません。
  Future<void> addNote(String text) => _noteBox.putAsync(Note(text));

  Future<void> removeNote(int id) => _noteBox.removeAsync(id);
}
