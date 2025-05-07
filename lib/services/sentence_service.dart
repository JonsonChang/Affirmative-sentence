import '../models/sentence.dart';

class SentenceService {
  // TODO: 實作本地資料儲存與 CRUD
  List<Sentence> getDefaultSentences() {
    return [
      Sentence(id: '1', content: '我值得被愛。', category: '自信'),
      Sentence(id: '2', content: '今天會是美好的一天。', category: '正向'),
    ];
  }
}
