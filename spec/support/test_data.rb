# frozen_string_literal: true

require 'notion/convert'
include Convert

module TestData
  CSV_DATA = <<~BOOKS
    Name,Author,Format,Labels,Status,⭐️
    Dune,Frank Herbert,audiobook,nat,📖 Reading 📖,Yes
    Wolf Hall,Hilary Mantel,audiobook,shelf,Read 2021,Yes
    Letters From a Stoic,Seneca,audiobook,shelf,Read 2021,No
    Her Body and Other Parties,Carmen Maria Machado,"physical, read aloud",nat,📖 Reading 📖,Yes
    "To Be Taught, If Fortunate",Becky Chambers,"physical, read aloud","nat, shelf",Read 2021,No
    We,Yevgeny Zamyatin,"audiobook, ebook, physical",shelf,To Read,No
    Shaping the Fractured Self: Poetry of Chronic Illness and Pain,Heather Taylor Johnson (Editor),physical,shelf,Paused,No
    Punished By Rewards,Alfie Kohn,audiobook,,Read 2021,Yes
  BOOKS

  DUNE_HASH = { title: 'Dune', author: 'Frank Herbert', status: 'current', formats: ['audiobook'], tags: [:nat], fav: true }.freeze
  WOLF_HALL_HASH = { title: 'Wolf Hall', author: 'Hilary Mantel', status: 'done', formats: ['audiobook'], tags: [:shelf], fav: true }.freeze
  STOIC_HASH = { title: 'Letters From a Stoic', author: 'Seneca', status: 'done', formats: ['audiobook'], tags: [:shelf], fav: false }.freeze
  OTHER_PARTIES_HASH = { title: 'Her Body and Other Parties', author: 'Carmen Maria Machado', status: 'current', formats: ['physical', 'read aloud'], tags: [:nat], fav: true }.freeze
  IF_FORTUNATE_HASH = { title: 'To Be Taught, If Fortunate', author: 'Becky Chambers', status: 'done', formats: ['physical', 'read aloud'], tags: [:nat, :shelf], fav: false }.freeze
  WE_HASH = { title: 'We', author: 'Yevgeny Zamyatin', status: 'To Read', formats: ['audiobook', 'ebook', 'physical'], tags: [:shelf], fav: false }.freeze
  FRACTURED_SELF_HASH = { title: 'Shaping the Fractured Self: Poetry of Chronic Illness and Pain', author: 'Heather Taylor Johnson (Editor)', status: 'Paused', formats: ['physical'], tags: [:shelf], fav: false }.freeze
  PUNISHED_HASH = { title: 'Punished By Rewards', author: 'Alfie Kohn', status: 'done', formats: ['audiobook'], tags: [], fav: true }.freeze
  HASHES = [DUNE_HASH, WOLF_HALL_HASH, STOIC_HASH, OTHER_PARTIES_HASH, IF_FORTUNATE_HASH, WE_HASH, FRACTURED_SELF_HASH, PUNISHED_HASH].freeze

  DUNE = hash_to_book(DUNE_HASH)
  WOLF_HALL = hash_to_book(WOLF_HALL_HASH)
  STOIC = hash_to_book(STOIC_HASH)
  OTHER_PARTIES = hash_to_book(OTHER_PARTIES_HASH)
  IF_FORTUNATE = hash_to_book(IF_FORTUNATE_HASH)
  WE = hash_to_book(WE_HASH)
  FRACTURED_SELF = hash_to_book(FRACTURED_SELF_HASH)
  PUNISHED = hash_to_book(PUNISHED_HASH)
  BOOKS = [DUNE, WOLF_HALL, STOIC, OTHER_PARTIES, IF_FORTUNATE, WE, FRACTURED_SELF, PUNISHED].freeze

  WE_HASH_DUP = WE_HASH.merge({ status: 'done', formats: ['audiobook', 'ebook', 'read aloud'] }).freeze
  WE_DUP = hash_to_book(WE_HASH_DUP)
  DUNE_HASH_DUP_1 = DUNE_HASH.merge({ status: 'done', formats: ['audiobook', 'ebook'] }).freeze
  DUNE_HASH_DUP_2 = DUNE_HASH.merge({ status: 'done', formats: ['physical'] }).freeze
  DUNE_DUP_1 = hash_to_book(DUNE_HASH_DUP_1)
  DUNE_DUP_2 = hash_to_book(DUNE_HASH_DUP_2)
end
