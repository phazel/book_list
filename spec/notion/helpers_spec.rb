# frozen_string_literal: true

require 'notion/helpers'
include Helpers

describe 'Helpers' do
  describe 'Convert' do
    describe '.title' do
      it "converts header 'Name' to 'Title'" do
        expect(title('Name')).to eq('Title')
      end
      it "converts when 'Name' starts with Byte Order Mark character" do
        expect(title("\u{feff}Name")).to eq('Title')
      end
      it 'does not convert a different header' do
        expect(title('Format')).to eq('Format')
      end
      it 'does not convert a different header with Byte Order Mark character' do
        expect(title("\u{feff}Format")).to eq("\u{feff}Format")
      end
    end

    describe '.alt_status' do
      it "converts status '📖 Reading 📖' to 'current'" do
        expect(alt_status('📖 Reading 📖')).to eq('current')
      end
      it "converts status 'Read 2021' to 'done'" do
        expect(alt_status('Read 2021')).to eq('done')
      end
      it 'does not convert another status' do
        expect(alt_status('Paused')).to eq('Paused')
      end
    end

    describe '.blank_to_nil' do
      it "converts empty string value to nil" do
        expect(blank_to_nil('')).to eq(nil)
      end
      it "retains nil value as nil" do
        expect(blank_to_nil(nil)).to eq(nil)
      end
      it "retains non-empty value" do
        expect(blank_to_nil('something')).to eq('something')
      end
    end
  end
end
