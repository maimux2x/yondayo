# 共有ページ用の OGP 画像（1200x630 の PNG）を作る。
# 書影は使わず、名前・本のタイトル・著者・進捗とロゴだけで構成する。
#
# Active Storage がアバター画像の安全のため Vips の SVG 読み込みを無効にしているので、
# 図形は Vips の描画機能で描き、ロゴマークは事前に PNG にしたものを使う。
class Reading::OgpImage
  WIDTH  = 1200
  HEIGHT = 630

  ASSETS_DIR = Rails.root.join('vendor/ogp')
  MARK       = ASSETS_DIR.join('mark.png').to_s
  MINCHO     = {file: ASSETS_DIR.join('fonts/ShipporiMinchoB1-SemiBold.ttf').to_s, name: 'Shippori Mincho B1 SemiBold'}.freeze
  GOTHIC     = {file: ASSETS_DIR.join('fonts/ZenKakuGothicNew-Regular.ttf').to_s,  name: 'Zen Kaku Gothic New'}.freeze

  PAPER   = [246, 242, 234].freeze # #F6F2EA
  INDIGO  = [51,  80,  122].freeze # #33507A
  INK     = [46,  52,  64].freeze  # #2E3440
  INK_SUB = [74,  70,  63].freeze  # #4A463F
  AVATAR  = [224, 217, 203].freeze # #E0D9CB

  MARGIN        = 80
  CONTENT_WIDTH = WIDTH - MARGIN * 2
  TITLE_TOP     = 230

  def initialize(reading)
    @reading = reading
  end

  # 画像に載せる内容（進捗・本・名前）が変わると値が変わる。
  # 画像の URL とキャッシュの判定に使い、SNS に古い画像が残らないようにする。
  def version
    [@reading, @reading.book, @reading.user].map { it.updated_at.to_i }.max
  end

  def to_png
    initial   = text(@reading.user.name.first, font: GOTHIC, size: 26, color: INK_SUB)
    user_line = text("#{@reading.user.name}の読書記録", font: GOTHIC, size: 32, color: INK_SUB, max_width: 640, max_height: 48)
    status    = text(@reading.status_i18n, font: GOTHIC, size: 24, color: INDIGO)
    title     = text(@reading.book.title, font: MINCHO, size: 76, color: INK, max_width: CONTENT_WIDTH, max_height: 200)
    author    = (text(@reading.book.author, font: GOTHIC, size: 34, color: INK_SUB, max_width: CONTENT_WIDTH, max_height: 48) if @reading.book.author.present?)
    brand     = text('よんだよ', font: MINCHO, size: 40, color: INK, letter_spacing: 3)
    mark      = Vips::Image.new_from_file(MARK)

    status_x = 164 + user_line.width + 28
    brand_x  = WIDTH - MARGIN - brand.width
    footer_y = 548 # ロゴの縦方向の中心

    canvas
      .then { circle(it, cx: 112, cy: 120, r: 32, color: AVATAR) }
      .then { frame(it, x: status_x, y: 100, width: 112, height: 44, color: INDIGO) }
      .then { place(it, initial,   x: 112 - initial.width / 2, y: 120 - initial.height / 2) }
      .then { place(it, user_line, x: 164, y: 120 - user_line.height / 2) }
      .then { place(it, status,    x: status_x + (112 - status.width) / 2, y: 122 - status.height / 2) }
      .then { place(it, title,     x: MARGIN, y: TITLE_TOP) }
      .then { author ? place(it, author, x: MARGIN, y: TITLE_TOP + title.height + 32) : it }
      .then { place(it, mark,      x: brand_x - 16 - mark.width, y: footer_y - mark.height / 2) }
      .then { place(it, brand,     x: brand_x, y: footer_y - brand.height / 2) }
      .write_to_buffer('.png')
  end

  private

  # 紙色の背景と上端の帯
  def canvas
    Vips::Image.black(WIDTH, HEIGHT)
      .new_from_image(PAPER)
      .copy(interpretation: :srgb)
      .draw_rect(INDIGO, 0, 0, WIDTH, 14, fill: true)
  end

  # 縁を滑らかにするため、4倍の大きさで描いてから縮小した円を重ねる
  def circle(base, cx:, cy:, r:, color:)
    scale = 4
    size  = r * 2 * scale
    alpha = Vips::Image.black(size, size).draw_circle(255, size / 2, size / 2, r * scale, fill: true).resize(1.0 / scale)
    disc  = alpha.new_from_image(color).copy(interpretation: :srgb).bandjoin(alpha)

    place(base, disc, x: cx - r, y: cy - r)
  end

  # 太さ 2px の枠線
  def frame(base, x:, y:, width:, height:, color:)
    base
      .draw_rect(color, x, y, width, height)
      .draw_rect(color, x + 1, y + 1, width - 2, height - 2)
  end

  # 実際の文字幅で折り返す。max_height に収まらないときは、収まるまで文字を小さくする。
  # 文字列は Pango のマークアップとして解釈されるため、& や < をエスケープする。
  def text(string, font:, size:, color:, max_width: nil, max_height: nil, letter_spacing: 0)
    markup  = %(<span letter_spacing="#{letter_spacing * 1024}">#{ERB::Util.html_escape(string)}</span>)
    options = {fontfile: font[:file], font: "#{font[:name]} #{size}"}
    options.merge!(width: max_width, wrap: :word_char) if max_width

    mask = Vips::Image.text(markup, **options, dpi: 72)
    mask = Vips::Image.text(markup, **options, height: max_height) if max_height && mask.height > max_height

    mask.new_from_image(color).copy(interpretation: :srgb).bandjoin(mask)
  end

  def place(base, overlay, x:, y:)
    base.composite(overlay, :over, x: [x], y: [y]).flatten.cast(:uchar)
  end
end
