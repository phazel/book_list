# frozen_string_literal: true

require 'format'
include Format

describe 'Format' do
  subject do
    post(
      year: 1534,
      total: 64,
      dups: ["These are the duplicate books\n\n"],
      sleep: ["These are the sleep books\n\n"],
      fav: ["These are the favourite books\n\n"],
      remaining: ["These are all the rest of the books\n\n"],
      dnf: ["These are the DNF books\n\n"],
      current: ["These are the current books\n\n"],
    )
  end
  expected = <<~POST
    # Books Read In 1534
    `Total books read: 64`

    **Formats**
    📖 - physical book
    💾 - ebook
    🎧 - audiobook
    🗣 - read aloud

    **Tags**
    🌟 - favourite
    💞 - I read this with my partner
    💤 - I listened to this book to go to sleep
    🔁 - I've read this book before

    ---

    ## Books I Read More Than Once:

    These are the duplicate books

    ---

    ## Books I used as background noise for going to sleep:

    These are the sleep books

    ---

    ## Favourites:

    These are the favourite books

    ---

    These are all the rest of the books

    ---

    ## Books I Decided Not To Finish:

    These are the DNF books

    ---

    ## Currently reading:

    These are the current books

  POST

  describe '.post' do
    it { expect(subject).to eq(expected) }
  end
end
