require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Muddle::Parser do
  it "has a default set of filters" do
    pr = Muddle::Parser.new

    pr.filters.size.should eql(5)
    pr.filters[0].should eql(Muddle::Filter::BoilerplateCSS)
    pr.filters[1].should eql(Muddle::Filter::Premailer)
    pr.filters[2].should eql(Muddle::Filter::BoilerplateStyleElement)
    pr.filters[3].should eql(Muddle::Filter::BoilerplateAttributes)
    pr.filters[4].should eql(Muddle::Filter::SchemaValidation)
  end

  it "only adds filters if config says" do
    Muddle.config.parse_with_premailer = false
    Muddle::Parser.new.filters.should_not include(Muddle::Filter::Premailer)

    Muddle.config.insert_boilerplate_styles = false
    Muddle::Parser.new.filters.should_not include(Muddle::Filter::BoilerplateStyleElement)

    Muddle.config.insert_boilerplate_css = false
    Muddle::Parser.new.filters.should_not include(Muddle::Filter::BoilerplateCSS)

    Muddle.config.insert_boilerplate_attributes = false
    Muddle::Parser.new.filters.should_not include(Muddle::Filter::BoilerplateAttributes)

    Muddle.config.validate_html = false
    Muddle::Parser.new.filters.should_not include(Muddle::Filter::SchemaValidation)
  end

  describe "with default options" do
    before(:each) do
      @output = Muddle.parse(minimal_email_body)
    end

    it "displays the output" do
      pending
      puts '--------'
      puts @output
      puts '--------'
    end

    it "retains the document structure" do
      @output.should have_xpath('/html')
      @output.should have_xpath('/html/head')
      @output.should have_xpath('/html/head/title')
      #@output.should have_xpath('/html/head/style') # premailer removes the style tag when using hpricot...
      @output.should have_xpath('/html/body')
      @output.should have_xpath('/html/body/table')
      @output.should have_xpath('/html/body/table/tr')
      @output.should have_xpath('/html/body/table/tr/td')
    end

    it "uses XHTML strict" do
      Nokogiri::XML(@output).internal_subset.to_s.should == "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
    end
  end

  describe "example (sample email)" do
    let(:output) { Muddle.parse(example_email_body) }

    it "displays the output" do
      pending
      puts '--------'
      puts output
      puts '--------'
    end

    it "inserts the head before the body" do
      output.should have_xpath('/html/body/preceding-sibling::head')
    end

    it "inserts the style inside the head" do
      output.should have_xpath('/html/body/style')
    end
  end

  describe "example html5 email" do
    let(:output) {Muddle.parse(html5_email)}

    it "displays the output" do
      pending
      puts output
    end

    it "doesn't vomit" do
      output.should have_xpath('html/body/style')
    end
  end
end
