require 'spec_helper'

describe "Paginas estaticas" do
  
  describe "Pagina Home" do
    
    it "debe tener el contenido 'Sample App'" do
      visit '/static_pages/home'
      page.should have_content('Sample App')
    end
    
    it "debe tener un h1 'Sample App'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Sample App')
    end

    it "debe tener titulo 'Home'" do
      visit '/static_pages/home'
      page.should have_selector('title',
                        :text => "Ruby on Rails Tutorial Sample App | Home")
    end
  end
  
  describe "pagina Help" do
    
    it "debe contener 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
    it "debe tener el h1 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    it "debe tener el titulo 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title',
                        :text => "Ruby on Rails Tutorial Sample App | Help")
    end
  end
  
  describe "pagina About" do
    
    it "debe contener 'About Us'" do
      visit '/static_pages/about'
      page.should have_content('About Us')
    end
    it "debe tener el h1 'About'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About Us')
    end

    it "debe tener el titulo 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('title',
                    :text => "Ruby on Rails Tutorial Sample App | About Us")
    end
  end
end
