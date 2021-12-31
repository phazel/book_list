# frozen_string_literal: true

module Format
  def section(header, contents)
    [ header, "\n", contents ].join
  end

  def post(dups:, sleep:, fav:, remaining:, dnf:, current:)
    [
      section("Books I Read More Than Once:", dups),
      section("Books used as background noise for going to sleep:", sleep),
      section("Favourites:", fav),
      section("Read this year:", remaining),
      section("Books I Decided Not To Finish:", dnf),
      section("Currently reading:", current),
    ].join("---\n\n")
  end
end
