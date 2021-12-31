# frozen_string_literal: true

require 'helpers'
include Helpers::Convert

describe 'Helpers' do
  describe 'Convert' do
    describe '.title_converter' do
      it "converts header 'Name' to 'Title'" do
        expect(title_converter('Name')).to eq('Title')
      end
      it "converts when 'Name' starts with Byte Order Mark character" do
        expect(title_converter("\u{feff}Name")).to eq('Title')
      end
      it 'does not convert a different header' do
        expect(title_converter('Format')).to eq('Format')
      end
      it 'does not convert a different header with Byte Order Mark character' do
        expect(title_converter("\u{feff}Format")).to eq("\u{feff}Format")
      end
    end

    describe '.formats' do
      it "converts header 'Format' to 'Formats'" do
        expect(formats('Format')).to eq('Formats')
      end
      it "converts when 'Format' starts with Byte Order Mark character" do
        expect(formats("\u{feff}Format")).to eq('Formats')
      end
      it 'does not convert a different header' do
        expect(formats('Elsewhise')).to eq('Elsewhise')
      end
      it 'does not convert a different header with Byte Order Mark character' do
        expect(formats("\u{feff}Elsewhise")).to eq("\u{feff}Elsewhise")
      end
    end

    describe '.fav' do
      it "converts header '⭐️' to 'Fav'" do
        expect(fav('⭐️')).to eq('Fav')
      end
      it "converts when '⭐️' starts with Byte Order Mark character" do
        expect(fav("\u{feff}⭐️")).to eq('Fav')
      end
      it 'does not convert a different header' do
        expect(fav('Elsewhise')).to eq('Elsewhise')
      end
      it 'does not convert a different header with Byte Order Mark character' do
        expect(fav("\u{feff}Elsewhise")).to eq("\u{feff}Elsewhise")
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
