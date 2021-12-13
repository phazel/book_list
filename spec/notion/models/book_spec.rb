# frozen_string_literal: true

require 'notion/models/book'

describe Book do
  let(:title) { 'Good Book' }
  let(:author) { 'Good Writer' }
  let(:format) { ['audiobook'] }
  let(:book) { Book.new(title: title, author: author, format: format) }

  describe '#initialize' do
    it { expect(book).to be_a Book }
    it { expect { Book.new }.to raise_error(ArgumentError, 'missing keywords: :title, :author, :format') }
    it 'has correct attributes' do
      expect(book).to have_attributes(
        title: title,
        author: author,
        format: format
      )
    end
  end
end
