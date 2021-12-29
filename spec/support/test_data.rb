# frozen_string_literal: true

require 'notion/convert'
include Convert

module TestData
  CSV_DATA = <<~BOOKS
    Name,Author,Format,Status
    Dune,Frank Herbert,audiobook,📖 Reading 📖
    Wolf Hall,Hilary Mantel,audiobook,Read 2021
    Letters From a Stoic,Seneca,audiobook,Read 2021
    Her Body and Other Parties,Carmen Maria Machado,"physical, read aloud",📖 Reading 📖
    "To Be Taught, If Fortunate",Becky Chambers,"physical, read aloud",Read 2021
    We,Yevgeny Zamyatin,"audiobook, ebook, physical",To Read
    Shaping the Fractured Self: Poetry of Chronic Illness and Pain,Heather Taylor Johnson (Editor),physical,Paused
  BOOKS

  DUNE_HASH = { title: 'Dune', author: 'Frank Herbert', status: 'current', formats: ['audiobook'] }
  WOLF_HALL_HASH = { title: 'Wolf Hall', author: 'Hilary Mantel', status: 'done', formats: ['audiobook'] }
  STOIC_HASH = { title: 'Letters From a Stoic', author: 'Seneca', status: 'done', formats: ['audiobook'] }
  OTHER_PARTIES_HASH = { title: 'Her Body and Other Parties', author: 'Carmen Maria Machado', status: 'current', formats: ['physical', 'read aloud'] }
  IF_FORTUNATE_HASH = { title: 'To Be Taught, If Fortunate', author: 'Becky Chambers', status: 'done', formats: ['physical', 'read aloud'] }
  WE_HASH = { title: 'We', author: 'Yevgeny Zamyatin', status: 'To Read', formats: ['audiobook', 'ebook', 'physical'] }
  FRACTURED_SELF_HASH = { title: 'Shaping the Fractured Self: Poetry of Chronic Illness and Pain', author: 'Heather Taylor Johnson (Editor)', status: 'Paused', formats: ['physical'] }
  HASHES = [DUNE_HASH, WOLF_HALL_HASH, STOIC_HASH, OTHER_PARTIES_HASH, IF_FORTUNATE_HASH, WE_HASH, FRACTURED_SELF_HASH]

  DUNE = hash_to_book(DUNE_HASH)
  WOLF_HALL = hash_to_book(WOLF_HALL_HASH)
  STOIC = hash_to_book(STOIC_HASH)
  OTHER_PARTIES = hash_to_book(OTHER_PARTIES_HASH)
  IF_FORTUNATE = hash_to_book(IF_FORTUNATE_HASH)
  WE = hash_to_book(WE_HASH)
  FRACTURED_SELF = hash_to_book(FRACTURED_SELF_HASH)
  BOOKS = [DUNE, WOLF_HALL, STOIC, OTHER_PARTIES, IF_FORTUNATE, WE, FRACTURED_SELF]

  WE_HASH_DUP = WE_HASH.merge({ status: 'done', formats: ['audiobook', 'ebook'] })
  WE_DUP = hash_to_book(WE_HASH_DUP)
  DUNE_HASH_DUP_1 = DUNE_HASH.merge({ status: 'done', formats: ['audiobook', 'ebook'] })
  DUNE_HASH_DUP_2 = DUNE_HASH.merge({ status: 'done', formats: ['physical'] })
  DUNE_DUP_1 = hash_to_book(DUNE_HASH_DUP_1)
  DUNE_DUP_2 = hash_to_book(DUNE_HASH_DUP_2)
end
