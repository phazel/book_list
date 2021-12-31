# frozen_string_literal: true

require 'notion/models/book'

describe Book do
  let(:title) { 'Good Book' }
  let(:author) { 'Great Writer' }
  let(:status) { 'To Read' }
  let(:genre) { 'non-fiction' }
  let(:formats) { ['audiobook', 'physical'] }
  let(:fav) { false }
  let(:labels) { [] }
  let(:tags) { [] }
  subject do
    Book.new(
      title: title,
      author: author,
      status: status,
      genre: genre,
      formats: formats,
      fav: fav,
      labels: labels,
      tags: tags,
    )
  end

  describe '#initialize' do
    it { expect(subject).to be_a Book }
    it 'has correct attributes' do
      expect(subject).to have_attributes(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: formats,
        fav: fav,
        labels: labels,
        tags: tags,
      )
    end
    it 'errors on missing paramters' do
      missing = ':title, :author, :status, :genre, :formats, :fav, :labels, :tags'
      expect { Book.new }.to raise_error(ArgumentError, "missing keywords: #{missing}")
    end
  end

  describe '#format_emojis' do
    it 'has audiobook emoji' do
      expect(subject.format_emojis).to eq(' 🎧📖')
    end
    it 'shows talking emoji when read aloud' do
      aloud = Book.new(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: ['read aloud'],
        fav: fav,
        labels: labels,
        tags: tags,
      )
      expect(aloud.format_emojis).to eq(' 🗣')
    end
  end

  describe '#fav_emoji' do
    it 'has star emoji and space if favourite' do
      fav = Book.new(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: formats,
        fav: true,
        labels: labels,
        tags: tags,
      )
      expect(fav.fav_emoji).to eq(' 🌟')
    end
    it 'has empty string if not a favourite' do
      expect(subject.fav_emoji).to eq('')
    end
  end

  describe '#nat_emoji' do
    it 'has hearts emoji with space if labels contains :nat' do
      nat = Book.new(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: formats,
        fav: true,
        labels: [:nat],
        tags: tags,
      )
      expect(nat.nat_emoji).to eq(' 💞')
    end
    it 'has empty string if labels does not contain :nat' do
      expect(subject.nat_emoji).to eq('')
    end
  end

  describe '#sleep_emoji' do
    it 'has moon with space if labels contains :sleep' do
      sleep = Book.new(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: formats,
        fav: true,
        labels: [:sleep],
        tags: tags,
      )
      expect(sleep.sleep_emoji).to eq(' 💤')
    end
    it 'has empty string if labels does not contain :sleep' do
      expect(subject.sleep_emoji).to eq('')
    end
  end

  describe '#reread_emoji' do
    it 'has replay with space if labels contains :reread' do
      reread = Book.new(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: formats,
        fav: fav,
        labels: labels,
        tags: [:reread],
      )
      expect(reread.reread_emoji).to eq(' 🔁')
    end
    it 'has empty string if labels does not contain :reread' do
      expect(subject.reread_emoji).to eq('')
    end
  end

  describe '#series_text' do
    it 'has series name if in a series' do
      series = Book.new(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: formats,
        fav: fav,
        labels: labels,
        tags: tags,
        series: 'Some Series',
      )
      expect(series.series_text).to eq(' -- *of Some Series*')
    end
    it 'has series name and number if in a series with number' do
      series = Book.new(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: formats,
        fav: fav,
        labels: labels,
        tags: tags,
        series: 'Some Series',
        series_number: 2,
      )
      expect(series.series_text).to eq(' -- *#2 of Some Series*')
    end
    it 'does not show series text if it has series number but no series' do
      series = Book.new(
        title: title,
        author: author,
        status: status,
        genre: genre,
        formats: formats,
        fav: fav,
        labels: labels,
        tags: tags,
        series_number: 2,
      )
      expect(series.series_text).to eq('')
    end
    it 'has empty string if not in a series' do
      expect(subject.series_text).to eq('')
    end
  end

  describe '#to_s' do
    output = <<~BOOK
      **Good Book**
      *by Great Writer*
      Format: 🎧📖
      Tags:

    BOOK
    it { expect(subject.to_s).to eq(output) }
  end
end
