import { Controller } from '@hotwired/stimulus';

// 進捗が「読了」のときだけ読了日の欄を表示し、空なら今日の日付を入れる。
// 読了以外に切り替えたときは欄を隠すだけで値は残し、読了に戻したときに元の日付が見えるようにする。
// 読了以外で保存したときに読了日を消すのはモデル（Reading#sync_finished_on）の役割。
export default class extends Controller {
  static targets = ['field', 'input'];

  toggle(event) {
    const read = event.target.value === 'read';

    this.fieldTarget.hidden = !read;

    if (read) this.inputTarget.value ||= this.#today();
  }

  #today() {
    const now = new Date();
    const pad = (n) => String(n).padStart(2, '0');

    return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`;
  }
}
