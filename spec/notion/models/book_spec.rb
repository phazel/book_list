# frozen_string_literal: true

require 'notion/models/book'

describe Book do
  let(:title) { 'Good Book' }
  let(:author) { 'Good Writer' }
  let(:status) { 'To Read' }
  let(:formats) { ['audiobook', 'physical'] }
  subject do
    Book.new(
      title: title,
      author: author,
      status: status,
      formats: formats,
    )
  end

  describe '#initialize' do
    it { expect(subject).to be_a Book }
    it 'has correct attributes' do
      expect(subject).to have_attributes(
        title: title,
        author: author,
        status: status,
        formats: formats,
      )
    end
    it 'errors on missing paramters' do
      missing = ':title, :author, :status, :formats'
      expect { Book.new }.to raise_error(ArgumentError, "missing keywords: #{missing}")
    end
  end

  describe '#format_emojis' do
    it 'has audiobook emoji' do
      expect(subject.format_emojis).to eq('🎧📖')
    end
  end

  describe '#to_s' do
    output = <<~BOOK
      **Good Book**
      *by Good Writer*
      Format: 🎧📖

    BOOK
    it { expect(subject.to_s).to eq(output) }
  end
end
