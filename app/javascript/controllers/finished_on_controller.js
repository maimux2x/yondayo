import { Controller } from '@hotwired/stimulus';

// 進捗が「読了」のときだけ読了日の欄を表示し、空なら今日の日付を入れる。
// 読了以外に戻したときは欄を隠して値を消す（サーバー側でも同じルールで保存される）。
export default class extends Controller {
  static targets = ['field', 'input'];

  toggle(event) {
    const read = event.target.value === 'read';

    this.fieldTarget.hidden = !read;

    if (read) {
      this.inputTarget.value ||= this.#today();
    } else {
      this.inputTarget.value = '';
    }
  }

  #today() {
    const now = new Date();
    const pad = (n) => String(n).padStart(2, '0');

    return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`;
  }
}
