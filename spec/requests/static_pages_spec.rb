require 'spec_helper'

describe "Paginas estaticas" do
  
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  
  
  describe "Pagina Home" do
    
    it "debe tener el contenido 'Sample App'" do
      visit root_path
      page.should have_content('Sample App')
    end
    
    it "debe tener un h1 'Sample App'" do
      visit root_path
      page.should have_selector('h1', :text => 'Sample App')
    end

    it "debe tener titulo 'Home'" do
      visit root_path
      page.should have_selector('title',
                        :text => "#{base_title} | Home")
    end
  end
  
  describe "pagina Help" do
    
    it "debe contener 'Help'" do
      visit help_path
      page.should have_content('Help')
    end
    it "debe tener el h1 'Help'" do
      visit help_path
      page.should have_selector('h1', :text => 'Help')
    end

    it "debe tener el titulo 'Help'" do
      visit help_path
      page.should have_selector('title',
                        :text => "#{base_title} | Help")
    end
  end
  
  describe "pagina About" do
    
    it "debe contener 'About Us'" do
      visit about_path
      page.should have_content('About Us')
    end
    it "debe tener el h1 'About'" do
      visit about_path
      page.should have_selector('h1', :text => 'About Us')
    end

    it "debe tener el titulo 'About Us'" do
      visit about_path
      page.should have_selector('title',
                    :text => "#{base_title} | About Us")
    end
  end
  
  describe "pagina Contact" do
    
    it "debe tener h1 'Contact'" do
      visit contact_path
      page.should have_selector('h1', text: 'Contact')
    end

    it "debe tener el title 'Contact'" do
      visit contact_path
      page.should have_selector('title',
                    text: "Ruby on Rails Tutorial Sample App | Contact")
    end
  end
  
end
