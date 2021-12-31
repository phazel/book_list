# frozen_string_literal: true

module Format
  LEGEND = <<~LEGEND
    📖 - physical book
    📱 - ebook
    🎧 - audiobook
    👩🏻‍🦱 - I read this with my partner
    🌒 - I listened to this book to go to sleep
  LEGEND

  def section(header, contents)
    [ header, "\n", contents ].join
  end

  def lists(dups:, sleep:, fav:, remaining:, dnf:, current:)
    [
      "\n#{LEGEND}\n",
      section("Books I Read More Than Once:", dups),
      section("Books used as background noise for going to sleep:", sleep),
      section("Favourites:", fav),
      section("Read this year:", remaining),
      section("Books I Decided Not To Finish:", dnf),
      section("Currently reading:", current),
    ].join("---\n\n")
  end

  def post(total:, dups:, sleep:, fav:, remaining:, dnf:, current:)
    [
      '# Books Read In 2021',
      "`Total books read: #{total}`",
      lists(
        dups: dups,
        sleep: sleep,
        fav: fav,
        remaining: remaining,
        dnf: dnf,
        current: current,
      ),
    ].join("\n")
  end
end
