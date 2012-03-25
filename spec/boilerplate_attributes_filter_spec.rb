require 'spec_helper'

describe Muddle::BoilerplateAttributesFilter do
  let(:f) { Muddle::BoilerplateAttributesFilter }

  it "can parse full documents" do
    email = <<-EMAIL
      !DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"&gt;
      <html xmlns="http://www.w3.org/1999/xhtml">
        <body>
          <table>hey</table>
        </body>
      </html>'
      EMAIL
    output = f.filter(email)
    output.should have_xpath('//table[@cellpadding="0"]')
    output.should have_xpath('//table[@cellspacing="0"]')
    output.should have_xpath('//table[@border="0"]')
    output.should have_xpath('//table[@align="center"]')
  end

  describe "table attributes" do
    # NOTE: Should these be CSS-aware?
    
    it "sets the attributes if missing" do
      output = f.filter("<table></table>")
      output.should have_xpath('//table[@cellpadding="0"]')
      output.should have_xpath('//table[@cellspacing="0"]')
      output.should have_xpath('//table[@border="0"]')
      output.should have_xpath('//table[@align="center"]')
    end

    it "doesn't change if existing cellpadding" do
      output = f.filter("<table cellpadding=\"5px\"></table>")
      output.should have_xpath('//table[@cellpadding="5px"]')
      output.should have_xpath('//table[@cellspacing="0"]')
      output.should have_xpath('//table[@border="0"]')
      output.should have_xpath('//table[@align="center"]')
    end

    it "doesn't change if existing cellspacing" do
      output = f.filter("<table cellspacing=\"5px\"></table>")
      output.should have_xpath('//table[@cellpadding="0"]')
      output.should have_xpath('//table[@cellspacing="5px"]')
      output.should have_xpath('//table[@border="0"]')
      output.should have_xpath('//table[@align="center"]')
    end

    it "doesn't change if existing border" do
      output = f.filter("<table border=\"5px\"></table>")
      output.should have_xpath('//table[@cellpadding="0"]')
      output.should have_xpath('//table[@cellspacing="0"]')
      output.should have_xpath('//table[@border="5px"]')
      output.should have_xpath('//table[@align="center"]')
    end

    it "doesn't change if existing align" do
      output = f.filter("<table align=\"right\"></table>")
      output.should have_xpath('//table[@cellpadding="0"]')
      output.should have_xpath('//table[@cellspacing="0"]')
      output.should have_xpath('//table[@border="0"]')
      output.should have_xpath('//table[@align="right"]')
    end
  end

  describe "td attributes" do
    it "sets the attributes if missing" do
      f.filter("<td></td>").should have_xpath('//td[@valign="top"]')
    end

    it "doesn't change if existing valign" do
      f.filter("<td valign=\"bottom\"></td>").should have_xpath('//td[@valign="bottom"]')
    end
  end

  describe "a attributes" do
    it "sets the attributes if missing" do
      f.filter("<a></a>").should have_xpath('//a[@target="_blank"]')
    end

    it "doesn't change if existing _target" do
      f.filter("<a target=\"_parent\"></a>").should have_xpath('//a[@target="_parent"]')
    end
  end
end
