# frozen_string_literal: true

module Format
  def post(dups:, sleep:, fav:, remaining:, dnf:, current:)
    output = [
      "Books I Read More Than Once:\n",
      dups,
      "---\n\n",
      "Books used as background noise for going to sleep:\n",
      sleep,
      "---\n\n",
      "Favourites:\n",
      fav,
      "---\n\n",
      "Read this year:\n",
      remaining,
      "---\n\n",
      "Books I Decided Not To Finish:\n",
      dnf,
      "---\n\n",
      "Currently reading:\n",
      current,
    ]
    output.join
  end
end
