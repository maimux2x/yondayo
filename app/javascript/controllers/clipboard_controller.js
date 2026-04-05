import { Controller } from '@hotwired/stimulus';
import 'bootstrap';

export default class extends Controller {
  static targets = ['source', 'button'];

  connect() {
    this.tooltip = new bootstrap.Tooltip(this.buttonTarget, {
      title: 'コピーしました',
      trigger: 'click'
    });
  }

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value);

    setTimeout(() => {
      this.tooltip.hide();
    }, '1000');
  }

  disconnect() {
    this.tooltip.dispose();
  }
}
