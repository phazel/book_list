# frozen_string_literal: true

require 'notion/convert'
include Convert

module TestData
  CSV_DATA = <<~BOOKS
    Name,Author,Format,Genre,Labels,Series,Series Number,Status,Tags,⭐️
    Dune,Frank Herbert,audiobook,fiction-ish,nat,The Dune Sequence,1,📖 Reading 📖,reread,Yes
    Wolf Hall,Hilary Mantel,audiobook,fiction-ish,shelf,Thomas Cromwell,1,Read 2021,reread,Yes
    Letters From a Stoic,Seneca,audiobook,non-fiction,shelf,,,Read 2021,dnf,No
    Her Body and Other Parties,Carmen Maria Machado,"physical, read aloud",fiction-ish,nat,,,📖 Reading 📖,reread,Yes
    "To Be Taught, If Fortunate",Becky Chambers,"physical, read aloud",fiction-ish,"nat, shelf",,,Read 2021,,No
    We,Yevgeny Zamyatin,"audiobook, ebook, physical",fiction-ish,shelf,,,To Read,,No
    Shaping the Fractured Self: Poetry of Chronic Illness and Pain,Heather Taylor Johnson (Editor),physical,fiction-ish,shelf,,,Paused,topics,No
    Punished By Rewards,Alfie Kohn,audiobook,non-fiction,,,,Read 2021,"reread, topics",Yes
    The Lord of the Rings: The Return of the King,J. R. R. Tolkien,audiobook,fiction-ish,sleep,The Lord of the Rings,3,Read 2021,reread,No
  BOOKS

  DUNE_HASH = { title: 'Dune', author: 'Frank Herbert', status: 'current', genre: 'fiction-ish', formats: ['audiobook'], labels: [:nat], series: 'The Dune Sequence', series_number: 1, tags: [:reread], fav: true }.freeze
  WOLF_HALL_HASH = { title: 'Wolf Hall', author: 'Hilary Mantel', status: 'done', genre: 'fiction-ish', formats: ['audiobook'], labels: [:shelf], series: 'Thomas Cromwell', series_number: 1, tags: [:reread], fav: true }.freeze
  STOIC_HASH = { title: 'Letters From a Stoic', author: 'Seneca', status: 'done', genre: 'non-fiction', formats: ['audiobook'], labels: [:shelf], series: nil, series_number: nil, tags: [:dnf], fav: false }.freeze
  OTHER_PARTIES_HASH = { title: 'Her Body and Other Parties', author: 'Carmen Maria Machado', status: 'current', genre: 'fiction-ish', formats: ['physical', 'read aloud'], labels: [:nat], series: nil, series_number: nil, tags: [:reread], fav: true }.freeze
  IF_FORTUNATE_HASH = { title: 'To Be Taught, If Fortunate', author: 'Becky Chambers', status: 'done', genre: 'fiction-ish', formats: ['physical', 'read aloud'], labels: [:nat, :shelf], series: nil, series_number: nil, tags: [], fav: false }.freeze
  WE_HASH = { title: 'We', author: 'Yevgeny Zamyatin', status: 'To Read', genre: 'fiction-ish', formats: ['audiobook', 'ebook', 'physical'], labels: [:shelf], series: nil, series_number: nil, tags: [], fav: false }.freeze
  FRACTURED_SELF_HASH = { title: 'Shaping the Fractured Self: Poetry of Chronic Illness and Pain', author: 'Heather Taylor Johnson (Editor)', status: 'Paused', genre: 'fiction-ish', formats: ['physical'], labels: [:shelf], series: nil, series_number: nil, tags: [:topics], fav: false }.freeze
  PUNISHED_HASH = { title: 'Punished By Rewards', author: 'Alfie Kohn', status: 'done', genre: 'non-fiction', formats: ['audiobook'], labels: [], series: nil, series_number: nil, tags: [:reread, :topics], fav: true }.freeze
  LOTR_3_HASH = { title: 'The Lord of the Rings: The Return of the King', author: 'J. R. R. Tolkien', status: 'done', genre: 'fiction-ish', formats: ['audiobook'], labels: [:sleep], series: 'The Lord of the Rings', series_number: 3, tags: [:reread], fav: false }.freeze
  HASHES = [DUNE_HASH, WOLF_HALL_HASH, STOIC_HASH, OTHER_PARTIES_HASH, IF_FORTUNATE_HASH, WE_HASH, FRACTURED_SELF_HASH, PUNISHED_HASH, LOTR_3_HASH].freeze

  DUNE = hash_to_book(DUNE_HASH)
  WOLF_HALL = hash_to_book(WOLF_HALL_HASH)
  STOIC = hash_to_book(STOIC_HASH)
  OTHER_PARTIES = hash_to_book(OTHER_PARTIES_HASH)
  IF_FORTUNATE = hash_to_book(IF_FORTUNATE_HASH)
  WE = hash_to_book(WE_HASH)
  FRACTURED_SELF = hash_to_book(FRACTURED_SELF_HASH)
  PUNISHED = hash_to_book(PUNISHED_HASH)
  LOTR_3 = hash_to_book(LOTR_3_HASH)
  BOOKS = [DUNE, WOLF_HALL, STOIC, OTHER_PARTIES, IF_FORTUNATE, WE, FRACTURED_SELF, PUNISHED, LOTR_3].freeze

  WE_HASH_DUP = WE_HASH.merge({ status: 'done', formats: ['audiobook', 'ebook', 'read aloud'] }).freeze
  WE_DUP = hash_to_book(WE_HASH_DUP)
  WE_NF_HASH = WE_HASH.merge({ genre: 'non-fiction' }).freeze
  WE_NF = hash_to_book(WE_NF_HASH)
  DUNE_HASH_DUP_1 = DUNE_HASH.merge({ status: 'done', formats: ['audiobook', 'ebook'] }).freeze
  DUNE_HASH_DUP_2 = DUNE_HASH.merge({ status: 'done', formats: ['physical'] }).freeze
  DUNE_DUP_1 = hash_to_book(DUNE_HASH_DUP_1)
  DUNE_DUP_2 = hash_to_book(DUNE_HASH_DUP_2)
end
