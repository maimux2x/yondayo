user = User.create!(
  email_address: 'test_1@example.com',
  password:      'password'
)

book = Book.create!(
  title:                  'アジャイルサムライ――達人開発者への道',
  author:                 'Jonathan Rasmusson',
  cover:                  '',
  google_books_volume_id: 'qqkQ-HhjZf0C'
)

Reading.create!(
  user:,
  book:,
  status:  'unread',
  comment: 'これから読む'
)
