describe 'String' do

  describe "#titleize" do

    it "capitalizes each word in a string" do
      s = 'a word in a string'
      expect(s.titleize).to eq 'A Word In A String'
    end
    
    it "works with single-word strings" do
      s = 'a b c'
      expect(s.titleize).to eq 'A B C'
    end
    
    it "capitalizes all uppercase strings" do
      s = 'ALL UPPERCASE STRINGS'
      expect(s.titleize).to eq 'All Uppercase Strings'
    end
    
    it "capitalizes mixed-case strings" do
      s = 'mIxED-cASE STRINGs'
      expect(s.titleize).to eq 'Mixed-case Strings'
    end
    
  end
  
  describe '#blank?' do

    it "returns true if string is empty" do
      s = ''
      expect(s).to be_blank
    end

    it "returns true if string contains only spaces" do
      s = '  '
      expect(s.blank?).to be true
    end

    it "returns true if string contains only tabs" do
      # Get a tab using a double-quoted string with \t
      # example: "\t\t\t"
      s = "\t\t"
      expect(s).to be_blank
    end

    it "returns true if string contains only spaces and tabs" do
      s = "\t\t  "
      expect(s.blank?).to be true
    end
    
    it "returns false if string contains a letter" do
      s = 'a'
      expect(s.blank?).to be false
    end

    it "returns false if string contains a number" do
      s = '123'
      expect(s).not_to be_blank
    end
    
  end
  
end
