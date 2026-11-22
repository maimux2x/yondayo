# Bootstrap 5.3 の Sass ソースが出す非推奨警告（gem 由来）を表示しない。
# application.scss 自身の @import の警告は、Dart Sass 3.0 での削除に気づけるよう残している。
Rails.application.config.dartsass.build_options += ['--quiet-deps']
