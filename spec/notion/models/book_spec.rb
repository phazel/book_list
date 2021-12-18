# frozen_string_literal: true

require 'notion/models/book'

describe Book do
  let(:title) { 'Good Book' }
  let(:author) { 'Good Writer' }
  let(:status) { 'To Read' }
  let(:format) { ['audiobook'] }
  subject do
    Book.new(
      title: title,
      author: author,
      status: status,
      format: format
    )
  end

  describe '#initialize' do
    it { expect(subject).to be_a Book }
    it 'has correct attributes' do
      expect(subject).to have_attributes(
        title: title,
        author: author,
        status: status,
        format: format
      )
    end
    it 'errors on missing paramters' do
      missing = ':title, :author, :status, :format'
      expect { Book.new }.to raise_error(ArgumentError, "missing keywords: #{missing}")
    end
  end
end
